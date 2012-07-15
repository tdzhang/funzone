//
//  DetailViewController.m
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Cache.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contributorProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *contributorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventIntroLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;


@end

@implementation DetailViewController
@synthesize contributorProfileImageView;
@synthesize eventImageView;
@synthesize contributorNameLabel;
@synthesize timestampLabel;
@synthesize eventTitleLabel;
@synthesize eventLocationLabel;
@synthesize eventLocationDistanceLabel;
@synthesize eventTimeLabel;
@synthesize eventPriceLabel;
@synthesize eventIntroLabel;
@synthesize myScrollView;
@synthesize data=_data;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;

#pragma mark - View Life Circle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setContributorProfileImageView:nil];
    [self setContributorNameLabel:nil];
    [self setTimestampLabel:nil];
    [self setEventTitleLabel:nil];
    [self setEventLocationLabel:nil];
    [self setEventLocationDistanceLabel:nil];
    [self setEventTimeLabel:nil];
    [self setEventPriceLabel:nil];
    [self setEventIntroLabel:nil];
    [self setMyScrollView:nil];
    [self setEventImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.myScrollView setContentSize:CGSizeMake(320, 500)];
    
    //start a new connection, to fetch data from the server (about event detail)
    NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/events/view?event_id=%@&shared_event_id=%@",self.event_id,self.shared_event_id];
    NSLog(@"%@",request_string);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined method
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id{
    self.event_id = event_id;
    self.shared_event_id = shared_event_id;
}

#pragma mark - implement NSURLconnection delegate methods 
//to deal with the returned data

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    /*UIAlertView *someError = [[UIAlertView alloc] initWithTitle:@"Connection Error" message: @"Unable to connect to searching server" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
     [someError show];*/
    //NSLog(@"%@",connection.originalRequest.URL);
    //NSLog(@"%@",error);
}


//when the connection get the returned data (json form)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //renew the 10 newest features!!!!
    NSError *error;
    NSDictionary *event = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    //after reget the newest 10 popular event, the next page that need to be retrait is page 2


    NSString *title=[event objectForKey:@"title"]!=[NSNull null]?[event objectForKey:@"title"]:@"some thing";
    NSString *description=[event objectForKey:@"description"]!=[NSNull null]?[event objectForKey:@"description"]:@"No description";
    NSString *photo=[event objectForKey:@"photo_url"] !=[NSNull null]?[event objectForKey:@"photo_url"]:@"no url";
    NSString *time=[event objectForKey:@"time"] !=[NSNull null]?[event objectForKey:@"time"]:@"some time";
    NSLog(@"%@",title);
    NSLog(@"%@",description);
    NSLog(@"%@",photo);
    NSLog(@"%@",time);
       // NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
        //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
        NSString *locationName=[event objectForKey:@"location"];
       // NSString *longitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"longitude"]];
       // NSString *latitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"latitude"]];

        if (!title) {
            return;
        }
        
        [self.eventTitleLabel setText:title];
        [self.eventLocationLabel setText:locationName];
        [self.eventTimeLabel setText:time];
        [self.eventIntroLabel setText:description];
        
        
        //NSLog(@"%@",title);
        //NSLog(@"%@",photo);
        //NSLog(@"%@",description);
        //NSLog(@"%@",num_pins);
        //NSLog(@"%@",num_views);
        
        NSURL *url=[NSURL URLWithString:photo];
        if (![Cache isURLCached:url]) {
            //using high priority queue to fetch the image
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
                //get the image data
                NSData * imageData = nil;
                imageData = [[NSData alloc] initWithContentsOfURL: url];
                
                if ( imageData == nil ){
                    //if the image data is nil, the image url is not reachable. using a default image to replace that
                    //NSLog(@"downloaded %@ error, using a default image",url);
                    UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
                    imageData=UIImagePNGRepresentation(image);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [self.eventImageView setImage:image];
                        });
                    }
                }
                else {
                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                    //NSLog(@"downloaded %@",url);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [self.eventImageView setImage:[UIImage imageWithData:imageData]];
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [self.eventImageView setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
            });
        }
}

@end
