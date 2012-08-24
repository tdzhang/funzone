//
//  addAndViewCommentTVC.m
//  Fun
//
//  Created by Tongda Zhang on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "addAndViewCommentTVC.h"
#import "Cache.h"
#import "QuartzCore/QuartzCore.h"


@interface addAndViewCommentTVC ()

@end

@implementation addAndViewCommentTVC
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize comments=_comments;

#pragma mark - self defined setter and getter
-(NSArray *)comments{
    if (!_comments) {
        _comments=[[NSArray alloc] init];
    }
    return _comments;
}

-(void)setComments:(NSArray *)comments{
    _comments=comments;
    [self.tableView reloadData];
}

#pragma mark - view life circle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"count:%d",[self.imageUrls count]);
    return [self.comments count];
}

//set the height for each row
- (NSInteger) heightForRow: (NSInteger) row {
    eventComment *comment=[self.comments objectAtIndex:row];
    NSString *user_name = comment.user_name;
    NSString *comment_content = comment.content;
    CGSize maximumLabelSize1 = CGSizeMake(100,9999);
    CGSize expectedLabelSize1 = [user_name sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeClip];
    CGSize maximumLabelSize2 = CGSizeMake(260,9999);
    CGSize expectedLabelSize2 = [comment_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize2 lineBreakMode:UILineBreakModeWordWrap];
    NSInteger height = expectedLabelSize1.height + expectedLabelSize2.height + 5*2;
    height = (height > 55)? height:55;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForRow:[indexPath row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"commentTableViewCell";
    
    commentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"commentTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (commentTableViewCell*)view;
            }
        }
    }    
    //pending operation with the imageview of a cell cell.userPhotoImageView setImage:xxx
    eventComment *comment=[self.comments objectAtIndex:indexPath.row];
    
    cell.userNameLabel.text=[NSString stringWithFormat:@"%@",comment.user_name];
    cell.userNameLabel.frame = CGRectMake(60, 8, 100, 30);
    //[cell.userNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    CGSize maximumLabelSize1 = CGSizeMake(100,9999);
    CGSize expectedLabelSize1 = [comment.user_name sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeWordWrap];
    CGSize expectedWidth1 = [comment.user_name sizeWithFont:[UIFont boldSystemFontOfSize:14] forWidth:100 lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame1 = cell.userNameLabel.frame;
    newFrame1.size.height = expectedLabelSize1.height;
    newFrame1.size.width = expectedWidth1.width;
    cell.userNameLabel.frame = newFrame1;
    
    cell.commentTimeLabel.text=comment.timestamp;
    CGSize maximumLabelSize2 = CGSizeMake(100,9999);
    CGSize expectedLabelSize2 = [comment.timestamp sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize2 lineBreakMode:UILineBreakModeWordWrap];
    CGSize expectedWidth2 = [comment.timestamp sizeWithFont:[UIFont systemFontOfSize:12] forWidth:100 lineBreakMode:UILineBreakModeWordWrap];
    cell.commentTimeLabel.frame = CGRectMake(310-expectedWidth2.width, 9, 100, 30);
    [cell.commentTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.commentTimeLabel  setTextColor:[UIColor lightGrayColor]];
    CGRect newFrame2 = cell.commentTimeLabel.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    newFrame2.size.width = expectedWidth2.width;
    cell.commentTimeLabel.frame = newFrame2;
    
    cell.commentContentLabel.text=comment.content;
    cell.commentContentLabel.frame = CGRectMake(60, cell.userNameLabel.frame.size.height+8, 260, 30);
    [cell.commentContentLabel setFont:[UIFont systemFontOfSize:13]];
    [cell.commentContentLabel setTextColor:[UIColor darkGrayColor]];
    cell.commentContentLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.commentContentLabel.numberOfLines = 0;
    CGSize maximumLabelSize3 = CGSizeMake(260,9999);
    CGSize expectedLabelSize3 = [comment.content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize3 lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame3 = cell.commentContentLabel.frame;
    newFrame3.size.height = expectedLabelSize3.height;
    cell.commentContentLabel.frame = newFrame3;
    
    //cell.userPhotoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    cell.userPhotoImageView.frame = CGRectMake(10, 5, 44, 44);
    
    cell.userPhotoImageView.layer.cornerRadius = 4;
     cell.userPhotoImageView.clipsToBounds = YES;
    [ cell.userPhotoImageView setContentMode:UIViewContentModeScaleAspectFill];
     cell.userPhotoImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    cell.userPhotoImageView.layer.borderWidth = 1;
    
    NSLog(@"!!!!!%@", comment.user_picture_url);
    if (![Cache isURLCached:comment.user_picture_url]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: comment.user_picture_url];
            
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:@"smile_64.png"];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:comment.user_picture_url withData:imageData];
                        [cell.userPhotoImageView setImage:image];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:comment.user_picture_url withData:imageData];
                        [cell.userPhotoImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [cell.userPhotoImageView setImage:[UIImage imageWithData:[Cache getCachedData:comment.user_picture_url]]];
        });
    }
    
    
    [cell setSelectionStyle:UITableViewCellEditingStyleNone];
    return cell;  				
}


//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

@end
