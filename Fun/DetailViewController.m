//
//  DetailViewController.m
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Cache.h"
#import "eventComment.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UILabel *contributorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventIntroLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (nonatomic,strong) NSMutableData *data;

@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) NSString *event_title;
@property (nonatomic,strong) NSString *event_time;
@property (nonatomic,strong) NSString *location_name;
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSString *creator_id;
@property (nonatomic,strong) NSString *event_address;

@end

@implementation DetailViewController
@synthesize eventImageView;
@synthesize contributorNameLabel;
@synthesize eventTitleLabel;
@synthesize eventLocationLabel;
@synthesize eventTimeLabel;
@synthesize eventPriceLabel;
@synthesize eventIntroLabel;
@synthesize myScrollView;
@synthesize data=_data;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize event_title=_event_title;
@synthesize event_time=_event_time;
@synthesize location_name=_location_name;
@synthesize longitude=_longitude;
@synthesize latitude=_latitude;
@synthesize description=_description;
@synthesize comments=_comments;
@synthesize creator_id=_creator_id;
@synthesize event_address=_event_address;

#pragma mark - self defined getter and setter
-(NSMutableArray *)comments{
    if (!_comments) {
        _comments=[NSMutableArray array];
    }
    return _comments;
}


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
    [self setContributorNameLabel:nil];
    [self setEventTitleLabel:nil];
    [self setEventLocationLabel:nil];
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
    [self.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    //clean up the comment part
    for (UIView *oneview in [self.myScrollView subviews]) {
        [oneview removeFromSuperview];
    }
    
    [self.myScrollView setContentSize:CGSizeMake(320, 400)];
    
    //start a new connection, to fetch data from the server (about event detail)
    NSString *request_string=[NSString stringWithFormat:@"%@/events/view?event_id=%@&shared_event_id=%@",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id];
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
//(this method is called by the explorer page before loading to set the event id and shared event id)
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id{
    self.event_id = event_id;
    self.shared_event_id = shared_event_id;
}


//handle the action: addViewCommentButtonClicked
-(void)addViewCommentButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"addAndViewComment" sender:self];
}

#pragma mark - comment handle part
#define COMMENT_HEIGHT 24
//handle the comment part from self.comments
-(void)handleTheCommentPart{
    //comment
    float height=340;
    for (int i = 0; i<[self.comments count]; i++) {
        if(i==5)break; //in this page, only present a few comments
        eventComment* comment=[self.comments objectAtIndex:i];        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, COMMENT_HEIGHT)];
        height+=COMMENT_HEIGHT;
        
        NSString *content =[NSString stringWithFormat:@"%@",comment.user_name];
        UILabel *comment_user_name=[[UILabel alloc] initWithFrame:CGRectMake(0, commentView.frame.size.height/2-12, 100, 24)];
        [comment_user_name setBackgroundColor:[UIColor clearColor]];
        [comment_user_name setText:content];
        [comment_user_name setFont:[UIFont boldSystemFontOfSize:14]];
        [comment_user_name setTextAlignment:UITextAlignmentCenter];
        [comment_user_name sizeToFit];
        [commentView addSubview:comment_user_name];
        
        UILabel *comment_content=[[UILabel alloc] initWithFrame:CGRectMake(comment_user_name.frame.size.width+5, commentView.frame.size.height/2-12, 100, 24)];
        [comment_content setBackgroundColor:[UIColor clearColor]];
        [comment_content setText:comment.content];
        [comment_content setTextAlignment:UITextAlignmentCenter];
        [comment_content setFont:[UIFont boldSystemFontOfSize:14]];
        [comment_content setTextColor:[UIColor darkGrayColor]];
        comment_content.lineBreakMode = UILineBreakModeWordWrap;
        comment_content.numberOfLines = 2;
        [comment_content sizeToFit];
        [commentView addSubview:comment_content];
        [self.myScrollView addSubview:commentView];
    }    
    //button
    //UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, COMMENT_HEIGHT)];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 90, 60)];
    height+=COMMENT_HEIGHT;
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 30)];
    [button setAlpha:1];
    //add button action
    [button addTarget:self 
               action:@selector(addViewCommentButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [buttonView setBackgroundColor:[UIColor whiteColor]];
    [button setTitle:@"Comment" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [button setBackgroundImage:[UIImage imageNamed:@"button_comment.png"] forState:UIControlStateNormal];
    [buttonView addSubview:button];
    [self.myScrollView addSubview:buttonView];
    
    //set the scroll view content size
    [self.myScrollView setContentSize:CGSizeMake(320, height+30)];
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"repin to create new event"]) {
        NewEventVC *newEventVC = segue.destinationViewController;
        [newEventVC repinTheEventWithEventID:self.event_id sharedEventID:self.shared_event_id creatorID:self.creator_id eventTitle:self.event_title eventTime:self.event_time eventImage:self.eventImageView.image locationName:self.location_name address:self.event_address longitude:self.longitude latitude:self.latitude description:self.description];
    }
    else if([segue.identifier isEqualToString:@"addAndViewComment"]){
        if ([segue.destinationViewController isKindOfClass:[AddCommentVC class]]) {
            AddCommentVC *commentVC=segue.destinationViewController;
            commentVC.comments=[self.comments copy];
            commentVC.event_id=self.event_id;
            commentVC.shared_event_id=self.shared_event_id;
        }
    }
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
    
    //get the detail information
    NSString *title=[event objectForKey:@"title"]!=[NSNull null]?[event objectForKey:@"title"]:@"some thing";
    NSString *description=[event objectForKey:@"description"]!=[NSNull null]?[event objectForKey:@"description"]:@"No description";
    NSString *photo=[event objectForKey:@"photo_url"] !=[NSNull null]?[event objectForKey:@"photo_url"]:@"no url";
    NSString *time=[event objectForKey:@"start_time"] !=[NSNull null]?[event objectForKey:@"start_time"]:@"Anytime";
    NSString *creator_name=[event objectForKey:@"creator_name"];
    NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
    NSLog(@"%@",creator_id);
    self.creator_id=creator_id;
    
    //handle the comment part
    self.comments= [[eventComment getEventComentArrayFromArray:[event objectForKey:@"comments"]] mutableCopy];
    [self handleTheCommentPart];
    
    NSLog(@"%@",title);
    NSLog(@"%@",description);
    NSLog(@"%@",photo);
    NSLog(@"%@",time);
    //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
    //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
    NSString *locationName=[event objectForKey:@"location"];
    self.location_name=locationName;
    NSString *address=[event objectForKey:@"address"];
    self.event_address=address;
       // NSString *longitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"longitude"]];
       // NSString *latitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"latitude"]];

        if (!title) {
            return;
        }
        
    self.event_title=title;
    self.event_time=time;
    self.location_name=[event objectForKey:@"location"] !=[NSNull null]?[event objectForKey:@"location"]:@"location name unavailable";    
    self.longitude=[event objectForKey:@"longitude"];
    self.latitude=[event objectForKey:@"latitude"];
    self.description=[event objectForKey:@"description"] !=[NSNull null]?[event objectForKey:@"description"]:@"Description unavailable";;
    
    
    //set the content on the screen
    [self.eventLocationLabel setText:locationName];
    [self.eventTimeLabel setText:self.event_time];
    [self.eventTitleLabel setText:self.event_title];
    [self.contributorNameLabel setText:[NSString stringWithFormat:@"%@ would like to",creator_name]];

    
        
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
