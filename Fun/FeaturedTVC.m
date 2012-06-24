//
//  FeaturedTVC.m
//  Cookie
//
//  Created by He Yang on 6/20/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "FeaturedTVC.h"
#import "DocManager.h"
#import "XMLParser.h"
#import "Event.h"
#import "AppData.h"
#import "Cache.h"
#import <QuartzCore/QuartzCore.h>

@interface FeaturedTVC ()
//@property (nonatomic, strong) FeaturedCollectionVC *collectionViewCsontroller;
@property (nonatomic) AppData *appdata;
@property (nonatomic) NSMutableDictionary *loadedPhotos;

@end

@implementation FeaturedTVC 

//@synthesize collectionViewController;
@synthesize appdata = _appdata;
@synthesize loadedPhotos = _loadedPhotos;

// image default width: 525, default height 394;
#define THUMB_WIDTH 133.2
#define THUMB_HEIGHT 100

- (NSDictionary *)loadedPhotos {
    if (_loadedPhotos == nil) {
        _loadedPhotos = [NSMutableDictionary new];
    }
    
    return _loadedPhotos;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    spinner.transform = transform;
    spinner.center = self.view.center;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
    NSString *appDir = [[NSBundle mainBundle] resourcePath];
    NSString *xmlPath = [appDir stringByAppendingString:@"/events.xml"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:xmlPath];
    [DocManager useSharedManagedDocumentForDocumentNamed:@"Events" 
                                          toExecuteBlock:^(UIManagedDocument *document) {
                                              [XMLParser parse:data inContext:document.managedObjectContext];
                                              NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
                                              NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"event_id" ascending:YES];
                                              request.sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
                                              self.appdata.events = [document.managedObjectContext executeFetchRequest:request error:nil];
                                              //event *event = [self.appdata.eventes objectAtIndex:0];
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [spinner stopAnimating];
                                                  [spinner removeFromSuperview];
                                                  [self.tableView reloadData];
                                              });
                                          }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"%i",[self.appdata.eventes count]);
    return [self.appdata.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Event *event = [self.appdata.events objectAtIndex:indexPath.row];
    cell.imageView.bounds = CGRectMake(0, 0, 130, 100);
    
    cell.textLabel.text = event.title;
    cell.detailTextLabel.text = event.intro;
    cell.imageView.frame = CGRectMake(0, 0, THUMB_WIDTH, THUMB_HEIGHT);
    
    
    /*
    dispatch_async(loadQueue, ^{
        NSURL *url = [NSURL URLWithString:event.photoURL];
        UIImage *image;
        if ([Cache isURLCached:url]) {
            image = [UIImage imageWithData:[Cache getCachedData:url]];
        } else {
            NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
            MANUAL_LATENCY
            image = [UIImage imageWithData:imageData];
            [Cache addDataToCache:url withData:imageData];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            cell.imageView.image = image; 
            // [self.tableView reloadData];
        });
    });
    */
    
    UIImage *image = [_loadedPhotos objectForKey:indexPath];
    
    
    if (image == nil) {
        cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        
    
        cell.imageView.layer.borderWidth = 3.f;
        cell.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        //cell.imageView.bounds = CGRectMake(0, 0, THUMB_WIDTH, THUMB_HEIGHT);
        
        dispatch_queue_t loadQueue = dispatch_queue_create("Thumbnail Load Queue", NULL);
        
        dispatch_async(loadQueue, ^{
            NSURL *url = [NSURL URLWithString:event.img_url];
            NSData *data;
            if ([Cache isURLCached:url]) {
                data = [Cache getCachedData:url];
            } else {
                data = [[NSData alloc] initWithContentsOfURL:url];
                MANUAL_LATENCY
                [Cache addDataToCache:url withData:data];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^ {
                [_loadedPhotos setObject:image forKey:indexPath];
                UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                UIImage *image = [UIImage imageWithData:data];
                cell.imageView.image = image; 
                // [self.tableView reloadData]; 
            });
        });
        dispatch_release(loadQueue);
    } else {
        cell.imageView.image = image;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEvent"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        self.appdata.event_id = indexPath.row;
    } 
}



- (AppData *)appdata {
    if (_appdata == nil) {
        _appdata = [AppData getAppDataInstance];
    }
    return _appdata;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


@end
