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
@property (nonatomic,strong) NSString *event_title;
@property (nonatomic,strong) NSString *event_time;
@property (nonatomic,strong) NSString *location_name;
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSArray *comments;

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
@synthesize event_title=_event_title;
@synthesize event_time=_event_time;
@synthesize location_name=_location_name;
@synthesize longitude=_longitude;
@synthesize latitude=_latitude;
@synthesize description=_description;
@synthesize comments=_comments;

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
    [self.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
    
    
    [self.myScrollView setContentSize:CGSizeMake(320, 400)];
    
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

#pragma mark - comment handle part
#define COMMENT_HEIGHT 40
//handle the comment part from self.comments
-(void)handleTheCommentPart{
    //comment
    float height=344;

    for (int i = 0; i<[self.comments count]; i++) {
        if(i==5)break;
        eventComment* comment=[self.comments objectAtIndex:i];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, COMMENT_HEIGHT)];
        height+=COMMENT_HEIGHT+5;
        UIImageView *commentImage=[[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 20, 20)];

        [commentView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]];
  
        [commentImage setImage:[UIImage imageNamed:@"intro.png"]];
        [commentImage setContentMode:UIViewContentModeScaleAspectFill];
        [commentImage clipsToBounds];
        [commentView addSubview:commentImage];
        UILabel *commentLabel1=[[UILabel alloc] initWithFrame:CGRectMake(35, 15, 280, 20)];
        [commentLabel1 setBackgroundColor:[UIColor clearColor]];
        [commentLabel1 setText:comment.content];
        [commentView addSubview:commentLabel1];
        UILabel *commentLabel2=[[UILabel alloc] initWithFrame:CGRectMake(20, 2, 280, 15)];
        [commentLabel2 setBackgroundColor:[UIColor clearColor]];
        NSString *temp_content =[NSString stringWithFormat:@"id:%@  time:%@",comment.user_id,comment.timestamp];
        [commentLabel2 setFont:[UIFont fontWithName:@"Gurmukhi MN" size:12.0]];
        [commentLabel2 setText:temp_content];
        [commentView addSubview:commentLabel2];
        [self.myScrollView addSubview:commentView];
    }
    
    //button
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, COMMENT_HEIGHT)];
    height+=COMMENT_HEIGHT;
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, COMMENT_HEIGHT)];
    [button setAlpha:0.5];
    [buttonView setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1]];
    [button setTitle:@"See More / Add Comment" forState:UIControlStateNormal];
    [buttonView addSubview:button];
    [self.myScrollView addSubview:buttonView];
    
    //set the scroll view content size
    [self.myScrollView setContentSize:CGSizeMake(320, height+5)];
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"repin to create new event"]) {
        NewEventVC *newEventVC = segue.destinationViewController;
        [newEventVC repinTheEventWithEventID:self.event_id sharedEventID:self.shared_event_id eventTitle:self.event_title eventTime:self.event_time eventImage:self.eventImageView.image locationName:self.location_name longitude:self.longitude latitude:self.latitude description:self.description];
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
    //after reget the newest 10 popular event, the next page that need to be retrait is page 2


    NSString *title=[event objectForKey:@"title"]!=[NSNull null]?[event objectForKey:@"title"]:@"some thing";
    NSString *description=[event objectForKey:@"description"]!=[NSNull null]?[event objectForKey:@"description"]:@"No description";
    NSString *photo=[event objectForKey:@"photo_url"] !=[NSNull null]?[event objectForKey:@"photo_url"]:@"no url";
    NSString *time=[event objectForKey:@"start_time"] !=[NSNull null]?[event objectForKey:@"start_time"]:@"some time";
    self.comments= [eventComment getEventComentArrayFromArray:[event objectForKey:@"comments"]];
    [self handleTheCommentPart];
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
        
    self.event_title=title;
    self.event_time=time;
    self.location_name=[event objectForKey:@"location"] !=[NSNull null]?[event objectForKey:@"location"]:@"location name unavailable";;
    self.longitude=[event objectForKey:@"longitude"];
    self.latitude=[event objectForKey:@"latitude"];
    self.description=[event objectForKey:@"description"] !=[NSNull null]?[event objectForKey:@"description"]:@"Description unavailable";;
    

    [self.eventLocationLabel setText:self.location_name];
    [self.eventTimeLabel setText:self.event_time];

    
        
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
