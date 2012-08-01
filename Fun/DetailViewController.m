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
#import <Accounts/Accounts.h>
#import <Twitter/TWTweetComposeViewController.h>

@interface DetailViewController ()<MFMailComposeViewControllerDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIImageView *creatorProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *originalCreatorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *originalCreatorIndicator;
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
@property (nonatomic,strong) NSMutableArray *interestedPeople;
@property (nonatomic,strong) NSMutableArray *garbageCollection;
@property (nonatomic,strong) NSString *creator_id;
@property (nonatomic,strong) NSString *event_address;

@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSDictionary *peopleGoOutWithMessage; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSString *preDefinedMode; //change between sms mode and email mode
@property (nonatomic) int via;//used to keep track theuser activity , then send to the server
@property (nonatomic) BOOL isEventOwner; //used to indicate whether it is a editable event (based on who is the owner)


@end

@implementation DetailViewController
@synthesize eventImageView;
@synthesize creatorProfileImageView;
@synthesize originalCreatorLabel;
@synthesize originalCreatorIndicator = _originalCreatorIndicator;
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
@synthesize garbageCollection=_garbageCollection;
@synthesize interestedPeople=_interestedPeople;

@synthesize peopleGoOutWith=_peopleGoOutWith;
@synthesize peopleGoOutWithMessage=_peopleGoOutWithMessage;
@synthesize preDefinedMode=_preDefinedMode;
@synthesize delegate=_delegate;
@synthesize via=_via;
@synthesize isEventOwner=_isEventOwner;
#pragma mark - self defined getter and setter

-(NSMutableArray *)comments{
    if (!_comments) {
        _comments=[NSMutableArray array];
    }
    return _comments;
}

-(NSMutableArray *)interestedPeople{
    if (!_interestedPeople) {
        _interestedPeople=[NSMutableArray array];
    }
    return _interestedPeople;
}

//used by choose email people
-(void)setPeopleGoOutWith:(NSDictionary *)peopleGoOutWith{
    _peopleGoOutWith=peopleGoOutWith;
}

-(NSDictionary*)peopleGoOutWith{
    if (_peopleGoOutWith == nil){
        _peopleGoOutWith = [[NSDictionary alloc	] init];
    }
    return _peopleGoOutWith;
}

//used by choose sms people
-(void)peopleGoOutWithMessage:(NSDictionary *)peopleGoOutWithMessage{
    _peopleGoOutWithMessage=peopleGoOutWithMessage;
}

-(NSDictionary*)peopleGoOutWithMessage{
    if (_peopleGoOutWithMessage == nil){
        _peopleGoOutWithMessage = [[NSDictionary alloc] init];
    }
    return _peopleGoOutWithMessage;
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
    //set up the weixin delegate
    FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.delegate=(id)appDelegate;
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
    [self setOriginalCreatorIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    //delete notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
    //initial the contentsize of the myScrollView
    [self.myScrollView setContentSize:CGSizeMake(DETAIL_VIEW_CONTROLLER_SCROLLVIEW_INITIAL_CONTENTSIZE_WIDTH, DETAIL_VIEW_CONTROLLER_SCROLLVIEW_INITIAL_CONTENTSIZE_HEIGHT)];
    
    //start a new connection, to fetch data from the server (about event detail)
    NSString *request_string=[NSString stringWithFormat:@"%@/events/view?event_id=%@&shared_event_id=%@&via=%d",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,self.via];
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
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id andSetIsOwner:(BOOL)isOwner{
    self.event_id = event_id;
    self.shared_event_id = shared_event_id;
    self.isEventOwner=isOwner;
}

//server log need method
-(void)preSetServerLogViaParameter:(int)via{
    self.via=via;
}

//handle the action: addViewCommentButtonClicked (the TableViewControlelr that used to show all the comment and add the comment)
-(void)addViewCommentButtonClicked:(id)sender{
    [self performSegueWithIdentifier:@"addAndViewComment" sender:self];
}

- (IBAction)PickButtonClicked:(id)sender {
    [self performSegueWithIdentifier:@"repin to create new event" sender:self];
}

- (IBAction)shareButton:(UIButton *)sender {
    //give user several way to share
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose To Share:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"SMS Message",@"Facebook Wall",@"Twitter",@"Wechat", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

//handle the action: interestedButtonClicked
- (IBAction)interestedButtonClicked:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/interest?event_id=%@&shared_event_id=%@&auth_token=%@",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,[defaults objectForKey:@"login_auth_token"]]];
    NSLog(@"request: %@",url);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[block_request responseData] options:kNilOptions error:&error];
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Interest showed" message: [NSString stringWithFormat:@"Your Interested is upload to our server."] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
            success.delegate=self;
            [success show];
        }
        else {
            UIAlertView *unsuccess = [[UIAlertView alloc] initWithTitle:@"Interest not uploaded." message: [NSString stringWithFormat:@"Some thing went wrong."] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
            unsuccess.delegate=self;
            [unsuccess show];
        }
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Some thing went wrong." message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        notsuccess.delegate=self;
        [notsuccess show];
    }];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
}

#pragma mark - action sheet related stuff
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    /*
     //give user several way to share
     UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose To Share:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook Wall",@"Twitter",@"Wechat",@"Self enter", nil];
     pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
     [pop showFromTabBar:self.tabBarController.tabBar];
     */
    if([actionSheet.title isEqualToString:@"Choose To Share:"]){
        if (buttonIndex == 0) {
            NSLog(@"email");
            self.preDefinedMode=@"email";
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
        }
        else if (buttonIndex == 1) {
            NSLog(@"SMS message");
            self.preDefinedMode=@"message";
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
        }
        else if (buttonIndex == 2) {
            NSLog(@"facebook");
            NSLog(@"need to do sth about post on wall");
            FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
            if (!funAppdelegate.facebook) funAppdelegate.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:(id)funAppdelegate];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
                //if already login : start the action sheet
                funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            [params setObject:@"OrangeParc event" forKey:@"name"];
            [params setObject:@"new OrangeParc event" forKey:@"description"];
            [params setObject:[NSString stringWithFormat:@"Hi All,\n\nI feels good, want to inivite you to do %@ . The time I think %@ is good. Dose that sounds good? Shall we meet at %@?\n\nYeah~\n\nCheers~",self.event_title,self.event_time,self.location_name] forKey:@"message"];
            
            if ([funAppdelegate.facebook isSessionValid]) {
                [funAppdelegate.facebook requestWithGraphPath:@"me/feed"
                                              andParams:params
                                          andHttpMethod:@"POST"
                                            andDelegate:self];
            }
            else{
                //if not login, do it
                NSArray *permissions = [[NSArray alloc] initWithObjects:
                                        @"publish_stream",
                                        @"read_stream",@"create_event",@"email",
                                        nil];
                [funAppdelegate.facebook authorize:permissions];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
            }
        }
        else if (buttonIndex == 3) {
            NSLog(@"twitter");
            Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");
            if (twitterClass) {
                if ([TWTweetComposeViewController canSendTweet]) {
                    TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
                    [tweetViewController setInitialText:@"test"];
                    if (self.eventImageView.image != nil) {
                        [tweetViewController addImage:self.eventImageView.image];
                    }
                    [self presentViewController:tweetViewController animated:YES completion:nil];
                }
            }
        }
        else if (buttonIndex == 4) {
            NSLog(@"wechat");
            UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose A WeChat Way" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share On Moment",@"Send Friend Message", nil];
            pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
            [pop showFromTabBar:self.tabBarController.tabBar];
        }
    }
    else if([actionSheet.title isEqualToString:@"Choose A WeChat Way"]){
        if(buttonIndex == 0){
            //shared on moment
            [self.delegate SendMoment:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.event_title,self.event_time,self.location_name]];
        }
        else if(buttonIndex == 1){
            //send message to friend
            [self.delegate sendText:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.event_title,self.event_time,self.location_name]];
            
        }
    }
    
    
}

#pragma mark - comment handle part

//handle the intereted people part and handle the comment part from self.comments
-(void)handleTheCommentPart{
    if (self.garbageCollection) {
        for (UIView* view in self.garbageCollection) {
            [view removeFromSuperview];
        }
        [self.garbageCollection removeAllObjects];
    }
    
    self.garbageCollection=[NSMutableArray array];
    //comment
    float height=340; //default 340
    
    //handle the interest people part
    if ([self.interestedPeople count]>0) {
        UILabel* interestedPeopleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, height, 300, DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT)];
        [interestedPeopleLable setText:[NSString stringWithFormat:@" %d interested",[self.interestedPeople count]]];
        [interestedPeopleLable setFont:[UIFont boldSystemFontOfSize:15]];
        [interestedPeopleLable setTextColor:[UIColor darkGrayColor]];
        [interestedPeopleLable setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        [self.myScrollView addSubview:interestedPeopleLable];
        [self.garbageCollection addObject:interestedPeopleLable];
        height+=DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT;
        
        UIView *interested_people_view = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 45)];
        [interested_people_view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        
        int x_position_photo=0;
        for (int i=0; i<5&&i<([self.interestedPeople count]); i++) {
            UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x_position_photo+5, 3, 35, 35)];
            ProfileInfoElement* element=[self.interestedPeople objectAtIndex:i];
            NSURL* backGroundImageUrl=[NSURL URLWithString:element.user_pic];
            if (![Cache isURLCached:backGroundImageUrl]) {
                //using high priority queue to fetch the image
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                    //get the image data
                    NSData * imageData = nil;
                    imageData = [[NSData alloc] initWithContentsOfURL: backGroundImageUrl];
                    if (imageData == nil ){
                        //if the image data is nil, the image url is not reachable. using a default image to replace that
                        //NSLog(@"downloaded %@ error, using a default image",url);
                        UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                        imageData=UIImagePNGRepresentation(image);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:backGroundImageUrl withData:imageData];
                                userImageView.image=[UIImage imageWithData:imageData];
                            });
                        }
                    }
                    else {
                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                        //NSLog(@"downloaded %@",url);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:backGroundImageUrl withData:imageData];
                                userImageView.image=[UIImage imageWithData:imageData];
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    userImageView.image=[UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]];
                });
            }
            [interested_people_view addSubview:userImageView];
            [self.garbageCollection addObject:userImageView];
            x_position_photo+=38;
        }
        [self.myScrollView addSubview:interested_people_view];
        height+=60;        
    }
    
    //comment header view
    UIView *comments_header_view = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 30)];
    [comments_header_view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
    [self.myScrollView addSubview:comments_header_view];
    
    //comment icon
    UIImageView *comment_icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 12, 30)];
    UIImage *image_comment_icon = [UIImage imageNamed:@"comments.png"]; 
    [comment_icon setImage:image_comment_icon];
    [comment_icon setContentMode:UIViewContentModeScaleAspectFit];
    [comment_icon setAlpha:0.4];
    [comments_header_view addSubview:comment_icon];
    
    //comment header label
    UILabel *comment_header_label = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, 100, 30)];
    NSString *comment_header;
    if ([self.comments count] != 0) {
        comment_header = [NSString stringWithFormat:@"%d comments", [self.comments count]];
    }else {
        comment_header = [NSString stringWithFormat:@"0 comment"];
    }
    [comment_header_label setText:comment_header];
    [comment_header_label setBackgroundColor:[UIColor clearColor]];
    [comment_header_label setFont:[UIFont boldSystemFontOfSize:14]];
    [comment_header_label setTextColor:[UIColor darkGrayColor]];
    [comment_header_label setShadowColor:[UIColor whiteColor]];
    [comment_header_label setShadowOffset: CGSizeMake(0, 1)];
    [comments_header_view addSubview:comment_header_label];
    
    //button
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(230, 4, 65, 22)];
    [button setAlpha:1];
    //add button action
    [button addTarget:self 
               action:@selector(addViewCommentButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Comment" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [button setBackgroundImage:[UIImage imageNamed:@"button_comment.png"] forState:UIControlStateNormal];
    [comments_header_view addSubview:button];
    [self.garbageCollection addObject:button];
    
    height = 32 + height;
    //add every single comment entry
    for (int i = 0; i<[self.comments count]; i++) {
        if(i==5)break; //in this page, only present a few comments
        eventComment* comment=[self.comments objectAtIndex:i];  
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 0)];
        [commentView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];        
        
        //        UILabel *comment_user_name=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT)];
    
        UILabel *comment_user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 0)];
        NSString *comment_user_name =[NSString stringWithFormat:@"%@",comment.user_name];
        [comment_user_name_label setText:comment_user_name];
        [comment_user_name_label setFont:[UIFont boldSystemFontOfSize:14]];
        [comment_user_name_label setBackgroundColor:[UIColor clearColor]];
        comment_user_name_label.lineBreakMode = UILineBreakModeWordWrap;
        comment_user_name_label.numberOfLines = 0;
        
        CGSize maximumLabelSize1 = CGSizeMake(100,9999);
        CGSize expectedLabelSize1 = [comment_user_name sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeWordWrap];
        CGSize expectedWidth = [comment_user_name sizeWithFont:[UIFont boldSystemFontOfSize:14] forWidth:100 lineBreakMode:UILineBreakModeWordWrap];
        
        CGRect newFrame1 = comment_user_name_label.frame;
        newFrame1.size.height = expectedLabelSize1.height;
        newFrame1.size.width = expectedWidth.width;
        comment_user_name_label.frame = newFrame1;
        
        UILabel *indent = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [indent setFont:[UIFont boldSystemFontOfSize:14]];
        NSString *indent_string = [NSString stringWithFormat:@" "];
        while (indent.frame.size.width < comment_user_name_label.frame.size.width) {
            indent_string = [NSString stringWithFormat:@"%@ ", indent_string];
            [indent setText:indent_string];
            CGSize indentExpectedWidth = [indent_string sizeWithFont:[UIFont boldSystemFontOfSize:14] forWidth:100 lineBreakMode:UILineBreakModeWordWrap];
            CGRect indentNewFrame = indent.frame;
            indentNewFrame.size.width = indentExpectedWidth.width;
            indent.frame = indentNewFrame;
        }
        UILabel *comment_content_label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 290, 0)];
        NSString *comment_content = [NSString stringWithFormat:@"%@ %@", indent_string,comment.content];
        [comment_content_label setText:comment_content];
        [comment_content_label setFont:[UIFont systemFontOfSize:14]];
        [comment_content_label setBackgroundColor:[UIColor clearColor]];
        comment_content_label.lineBreakMode = UILineBreakModeWordWrap;
        comment_content_label.numberOfLines = 0;
        
        CGSize maximumLabelSize2 = CGSizeMake(290,9999);
        CGSize expectedLabelSize2 = [comment_content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maximumLabelSize2 lineBreakMode: UILineBreakModeWordWrap];   
        
        CGRect newFrame2 = comment_content_label.frame;
        newFrame2.size.height = expectedLabelSize2.height;
        comment_content_label.frame = newFrame2;
        
        [commentView addSubview:comment_content_label];
        [commentView addSubview:comment_user_name_label];
        
        CGRect newFrame3 = commentView.frame;
        newFrame3.size.height = comment_content_label.bounds.size.height+10;
        commentView.frame = newFrame3;
        
        [self.myScrollView addSubview:commentView];
        //distance between two comment view is 1px.
        height = height + commentView.bounds.size.height + 1;
        
        [self.garbageCollection addObject:commentView];        
    }
    //set the scroll view content size
    [self.myScrollView setContentSize:CGSizeMake(320, height+10)];}

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
    else if([segue.identifier isEqualToString:@"ChooseFriends"] && [segue.destinationViewController isKindOfClass:[ChoosePeopleToGoTableViewController class]]){
        ChoosePeopleToGoTableViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        if ([self.preDefinedMode isEqualToString:@"email"]) {
            peopleController.alreadySelectedContacts=[self.peopleGoOutWith copy];
        } else {
            peopleController.alreadySelectedContacts=[self.peopleGoOutWithMessage copy];
        }
        peopleController.preDefinedMode=self.preDefinedMode;
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
    NSLog(@"%@",event);
    //get the detail information
    NSString *title=[event objectForKey:@"title"];
    //NSString *description=[event objectForKey:@"description"]!=[NSNull null]?[event objectForKey:@"description"]:@"No description";
    NSString *photo=[event objectForKey:@"photo_url"] !=[NSNull null]?[event objectForKey:@"photo_url"]:@"no url";
    NSString *time=[event objectForKey:@"start_time"] !=[NSNull null]?[event objectForKey:@"start_time"]:@"Anytime";
    NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
    NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
    NSLog(@"%@",creator_id);
    self.creator_id=creator_id;
    //handle the interest people part
    self.interestedPeople=[[ProfileInfoElement generateProfileInfoElementArrayFromJson:[event objectForKey:@"interests"]] mutableCopy];
    //handle the comment part
    self.comments= [[eventComment getEventComentArrayFromArray:[event objectForKey:@"comments"]] mutableCopy];
    [self handleTheCommentPart];
    
    NSString *DEFAULT_IMAGE_REPLACEMENT=nil;
    if ([event_category isEqualToString:FOOD]) {
        DEFAULT_IMAGE_REPLACEMENT=FOOD_REPLACEMENT;
    }
    else if([event_category isEqualToString:MOVIE]){
        DEFAULT_IMAGE_REPLACEMENT=MOVIE_REPLACEMENT;
    }
    else if([event_category isEqualToString:SPORTS]){
        DEFAULT_IMAGE_REPLACEMENT=SPORTS_REPLACEMENT;
    }
    else if([event_category isEqualToString:NIGHTLIFE]){
        DEFAULT_IMAGE_REPLACEMENT=NIGHTLIFE_REPLACEMENT;
    }
    else if([event_category isEqualToString:OUTDOOR]){
        DEFAULT_IMAGE_REPLACEMENT=OUTDOOR_REPLACEMENT;
    }
    else if([event_category isEqualToString:ENTERTAIN]){
        DEFAULT_IMAGE_REPLACEMENT=ENTERTAIN_REPLACEMENT;
    }
    else if([event_category isEqualToString:SHOPPING]){
        DEFAULT_IMAGE_REPLACEMENT=SHOPPING_REPLACEMENT;
    }
    else if([event_category isEqualToString:OTHERS]){
        DEFAULT_IMAGE_REPLACEMENT=OTHERS_REPLACEMENT;
    }
    
    NSString *locationName=[event objectForKey:@"location"] !=[NSNull null]?[event objectForKey:@"location"]:@"location name unavailable";
    self.location_name=locationName;
    NSString *address=[event objectForKey:@"address"];
    self.event_address=address;
       // NSString *longitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"longitude"]];
       // NSString *latitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"latitude"]];

    if (!title) {return;}
    
#warning add link back to his/her parc page using coordinates
    //add creator's profile image and name. Link back to his/her profile page.
    //self.creatorProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 145, 35, 35)];
    NSURL *profile_url=[NSURL URLWithString:[event objectForKey:@"creator_pic"]];
    NSLog(@"%@",profile_url);
    if (![Cache isURLCached:profile_url]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: profile_url];
            
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",profile_url);
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:profile_url withData:imageData];
                        [self.creatorProfileImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",profile_url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:profile_url withData:imageData];
                        [self.creatorProfileImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.creatorProfileImageView setImage:[UIImage imageWithData:[Cache getCachedData:profile_url]]];
        });
    }
    
    //[self.myScrollView addSubview:self.creatorProfileImageView];
    NSString *creator_name=[event objectForKey:@"creator_name"];
    [self.contributorNameLabel setText:[NSString stringWithFormat:@"%@",creator_name]];
    
    
#warning fetch original creator info
    //show original creator
    self.originalCreatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 145, 100, 25)];
    
    self.event_title=title;
    self.event_time=time;
    self.location_name=[event objectForKey:@"location"] !=[NSNull null]?[event objectForKey:@"location"]:@"location name unavailable";    
    self.longitude=[event objectForKey:@"longitude"];
    self.latitude=[event objectForKey:@"latitude"];
    self.description=[event objectForKey:@"description"] !=[NSNull null]?[event objectForKey:@"description"]:@"Description unavailable";;
    
    //set the content on the screen
    if ([locationName isEqualToString:@""]) {
        locationName = [NSString stringWithFormat:@"TBD"];
    }
    //set event title
    [self.eventTitleLabel setText:self.event_title];
    self.eventTitleLabel.frame =CGRectMake(5, 185, 310, 40);
    [self.eventTitleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    self.eventTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.eventTitleLabel.numberOfLines = 0;
    CGSize maximumLabelSize1 = CGSizeMake(310,9999);    
    CGSize expectedLabelSize1 = [title sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame1 = self.eventTitleLabel.frame;
    newFrame1.size.height = expectedLabelSize1.height;
    self.eventTitleLabel.frame = newFrame1;
    
    //set seperator
    UIImageView *seperator = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.eventTitleLabel.frame.origin.y+self.eventTitleLabel.frame.size.height + 10, 1, 310)];
    [seperator setImage:[UIImage imageNamed:@"seperator.png"]];
    [self.myScrollView addSubview:seperator];
    
    //set time label and clock icon
    [self.eventTimeLabel setText:self.event_time];
    self.eventTimeLabel.frame = CGRectMake(10+12+5, seperator.frame.origin.y + 10, 230, 20);
    [self.eventTimeLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.eventTimeLabel setTextColor:[UIColor darkGrayColor]];
    self.eventTimeLabel.lineBreakMode = UILineBreakModeClip;
    self.eventTimeLabel.numberOfLines = 1;
    CGSize maximumLabelSize2 = CGSizeMake(230,9999);    
    CGSize expectedLabelSize2 = [title sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:maximumLabelSize2 lineBreakMode:UILineBreakModeClip];
    CGRect newFrame2 = self.eventTimeLabel.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    self.eventTimeLabel.frame = newFrame2;
    UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.eventTimeLabel.frame.origin.y + self.eventTimeLabel.frame.size.height/2 - 6, 12, 12)];
    [timeIcon setImage:[UIImage imageNamed:TIME_ICON]];
    [self.myScrollView addSubview:timeIcon];

    //set address section
    [self.eventLocationLabel setText:self.location_name];
    self.eventLocationLabel.frame = CGRectMake(10+12+5, self.eventTimeLabel.frame.origin.y + self.eventTimeLabel.frame.size.height +10, 230, 20);
    [self.eventLocationLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.eventLocationLabel setTextColor:[UIColor darkGrayColor]];
    self.eventLocationLabel.lineBreakMode = UILineBreakModeClip;
    self.eventLocationLabel.numberOfLines = 1;
    CGSize maximumLabelSize3 = CGSizeMake(230,9999);    
    CGSize expectedLabelSize3 = [title sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:maximumLabelSize3 lineBreakMode:UILineBreakModeClip];
    CGRect newFrame3 = self.eventLocationLabel.frame;
    newFrame3.size.height = expectedLabelSize3.height;
    self.eventLocationLabel.frame = newFrame3;
    UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, self.eventLocationLabel.frame.origin.y + self.eventLocationLabel.frame.size.height/2-7, 8, 14)];
    [locationIcon setImage:[UIImage imageNamed:LOCATION_ICON]];
    [self.myScrollView addSubview:locationIcon];
    UILabel *map_indicator = [[UILabel alloc] initWithFrame:CGRectMake(260, self.eventLocationLabel.frame.origin.y + self.eventLocationLabel.frame.size.height/2-12, 30,24)];
    [map_indicator setText:@"Map"];
    [map_indicator setFont:[UIFont boldSystemFontOfSize:13]];
    [map_indicator setTextColor:[UIColor lightGrayColor]];
    [self.myScrollView addSubview:map_indicator];
    //UIImageView right_Arrow = [[UIImageView alloc] initWithFrame:CGRectMake(300, <#CGFloat y#>, 11, 14)]
    

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


#pragma mark - self defined protocal <FeedBackToCreateActivityChange> method implementation
////////////////////////////////////////////////
//implement the method for the adding or delete contacts that will be go out with
-(void)AddContactInformtionToPeopleList:(UserContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSMutableDictionary *people=[self.peopleGoOutWith mutableCopy];
    NSString * key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people setObject:(id)person forKey:key];
    self.peopleGoOutWith = [people copy];
}

-(void)DeleteContactInformtionToPeopleList:(UserContactObject*)person{
    NSMutableDictionary *people=[self.peopleGoOutWith mutableCopy];
    NSString *key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people removeObjectForKey:key];
    self.peopleGoOutWith = [people copy];
}

////////////////////////////////////////////////
//implement the method for the adding or delete Message contacts that will be go out with
-(void)AddMessageContactInformtionToPeopleList:(UserContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSMutableDictionary *people=[self.peopleGoOutWithMessage mutableCopy];
    NSString * key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people setObject:(id)person forKey:key];
    self.peopleGoOutWithMessage = [people copy];
}

-(void)DeleteMessageContactInformtionToPeopleList:(UserContactObject*)person{
    NSMutableDictionary *people=[self.peopleGoOutWithMessage mutableCopy];
    NSString *key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people removeObjectForKey:key];
    self.peopleGoOutWithMessage = [people copy];
}

//start to compose email(the FeedBackToCreateActivityChange)
-(void)StartComposeEmail{
    //compose the email
    if (self.peopleGoOutWith) {
        if ([self.peopleGoOutWith count] > 0) {
            //Now we have friends to be invided using email
            //get the email list
            NSMutableArray *emailList=[NSMutableArray array];
            for (NSString* key in [self.peopleGoOutWith allKeys] ){
                UserContactObject *user=[self.peopleGoOutWith objectForKey:key];
                if (user.email) {
                    if ([user.email count]>0) {
                        [emailList addObject:[user.email objectAtIndex:0]];
                    }
                }
            }
            //we have the email list, now try to send email invitation
            if([MFMailComposeViewController canSendMail]) {
                //if the device allowed sending email
                MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                mailCont.mailComposeDelegate = self;
                
                //email subject
                [mailCont setSubject:[NSString stringWithFormat:@"Event Invitation! Yeah, Let's %@",self.event_title]];
                //email list
                [mailCont setToRecipients:emailList];
                //email body
                [mailCont setMessageBody:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.event_title,self.event_time,self.location_name] isHTML:NO];
                //go!
                [self presentModalViewController:mailCont animated:YES];
            }
        }
    }
}
//start to compose message(the FeedBackToCreateActivityChange)
-(void)StartComposeMessage{
    //compose the message
    if (self.peopleGoOutWithMessage) {
        if ([self.peopleGoOutWithMessage count] > 0) {
            //Now we have friends to be invided using email
            //get the email list
            NSMutableArray *phoneList=[NSMutableArray array];
            for (NSString* key in [self.peopleGoOutWithMessage allKeys] ){
                UserContactObject *user=[self.peopleGoOutWithMessage objectForKey:key];
                if (user.phone) {
                    if ([user.phone count]>0) {
                        [phoneList addObject:[user.phone objectAtIndex:0]];
                    }
                }
            }
            //we have the phone list, now try to send email invitation
            if([MFMessageComposeViewController canSendText]) {
                //if the device allowed sending email
                MFMessageComposeViewController *messageSender = [MFMessageComposeViewController new];
                messageSender.messageComposeDelegate = self;
                //phone list
                [messageSender setRecipients:phoneList];
                //phone body
                [messageSender setBody:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.event_title,self.event_time,self.location_name]];
                //go!
                [self presentModalViewController:messageSender animated:YES];
            }
        }
    }
    
    
    /*
     if ([MFMessageComposeViewController canSendText]) {
     MFMessageComposeViewController *messageSender = [MFMessageComposeViewController new];
     
     NSString *messageText = [[NSString stringWithFormat:@"Hi, your friend just shared recipe of %@ with you. Check it out here: ",_dish.name] stringByAppendingFormat:_dish.dishURL];
     
     [messageSender setBody:messageText];
     [self presentModalViewController:messageSender animated:YES];
     } else {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to sent SMS"
     message:@"Your device cannot send SMS for now. Please check."
     delegate:nil
     cancelButtonTitle:@"Cancel"
     otherButtonTitles: nil];
     [alert show];
     }
     */
    
}


#pragma mark - facebook related protocal implement
-(void)faceBookLoginFinished{
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose To Share:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"SMS Message",@"Facebook Wall",@"Twitter",@"Wechat", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
        NSLog(@"%@",result);
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Posted on wall" message: [NSString stringWithFormat:@"Your event is uploaded to our server."] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
    success.delegate=self;
    [success show];
}

#pragma mark - implement protocals <MFMessageComposeViewControllerDelegate>
////////////////////////////////////////////////
//implement the MFMailComposeViewControllerDelegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        NSLog(@"Sending Email Error Happended!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
}

@end
