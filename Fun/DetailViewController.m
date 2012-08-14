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

@property (weak,nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak,nonatomic) IBOutlet UIView *actionButtonHolder;
@property (nonatomic,strong) NSMutableData *data;

@property (nonatomic,strong) UIImageView *eventImageView;
@property (nonatomic,strong) UIImageView *creatorProfileView;
@property (nonatomic,strong) UILabel *creatorNameLabel;
@property (nonatomic,strong) UIButton *creatorProfileButton;
@property (nonatomic,strong) UILabel *eventTitleLabel;
@property (nonatomic,strong) UIView *timeSectionView;
@property (nonatomic,strong) UIView *locationSectionView;
@property (nonatomic,strong) UIView *interestedPeopleLabelView;
@property (nonatomic,strong) UIView *likedPeopleLabelView;
@property (nonatomic,strong) UIView *commentSectionView;
@property (nonatomic,strong) UIView *descriptionSectionView;
@property (nonatomic,strong) UIView *invitedPeopleSectionView;
@property (nonatomic,strong) UIButton *editButton;
@property (weak,nonatomic) IBOutlet UIView *likeButtonSection;
@property (weak,nonatomic) IBOutlet UIView *joinButtonSection;
@property (weak,nonatomic) IBOutlet UIView *doitmyselfButtonSection;
@property (nonatomic,strong) UIImageView *like_icon;
@property (nonatomic,strong) UIImageView *join_icon;
@property (nonatomic,strong) UIImageView *doitmyself_icon;
@property (nonatomic,strong) UILabel *like_label;
@property (nonatomic,strong) UILabel *join_label;
@property (nonatomic,strong) UILabel *description_content;
@property (nonatomic,strong) UILabel *doitmyself_label;
@property (nonatomic,strong) NSString *isLiked;
@property (nonatomic,strong) NSString *isJoined;
@property (nonatomic,strong) NSString *isAdded;

@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) NSString *event_title;
@property (nonatomic,strong) NSString *event_time;
@property (nonatomic,strong) NSURL *event_img_url;
@property (nonatomic,strong) NSString *location_name;
@property (nonatomic,strong) NSNumber *longitude;
@property (nonatomic,strong) NSNumber *latitude;
@property (nonatomic,strong) NSString *description;
@property (nonatomic,strong) NSMutableArray *comments;
@property (nonatomic,strong) NSMutableArray *interestedPeople;
@property (nonatomic,strong) NSMutableArray *likedPeople;
@property (nonatomic,strong) NSMutableArray *invitee;
@property (nonatomic,strong) NSMutableArray *garbageCollection;
@property (nonatomic,strong) NSString *creator_id;
@property (nonatomic,strong) NSURL *creator_img_url;
@property (nonatomic,strong) NSString *creator_name;
@property (nonatomic,strong) NSString *event_address;
@property (nonatomic,strong) NSString *tap_user_id;
@property (nonatomic) NSInteger *view_height;

@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSDictionary *peopleGoOutWithMessage; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSString *preDefinedMode; //change between sms mode and email mode
@property (nonatomic) int via;//used to keep track theuser activity , then send to the server
@property (nonatomic) int next_page_profile_via; //used to send via information to the next segue (used for show others user profile)
@property (nonatomic) BOOL isEventOwner; //used to indicate whether it is a editable event (based on who is the owner)
@property (nonatomic,strong)NSString* mysendMessageType; //differentiate share and invite
@property (nonatomic,strong)NSArray* alreadyInvitedFriend; //the json data of already invited friends

//@property (nonatomic)BOOL shouldGoBack; //if the event not exist, go back to the former page
@end

@implementation DetailViewController
@synthesize myScrollView;
@synthesize data=_data;
@synthesize eventImageView=_eventImageView;
@synthesize creatorProfileView=_creatorProfileView;
@synthesize creator_img_url=_creator_img_url;
@synthesize creator_name=_creator_name;
@synthesize creatorNameLabel=_creatorNameLabel;
@synthesize creatorProfileButton=_creatorProfileButton;
@synthesize eventTitleLabel=_eventTitleLabel;
@synthesize timeSectionView=_timeSectionView;
@synthesize locationSectionView=_locationSectionView;
@synthesize commentSectionView=_commentSectionView;
@synthesize descriptionSectionView=_descriptionSectionView;
@synthesize invitedPeopleSectionView=_invitedPeopleSectionView;
@synthesize likeButtonSection = _likeButtonSection;
@synthesize joinButtonSection=_joinButtonSection;
@synthesize doitmyselfButtonSection=_doitmyselfButtonSection;
@synthesize description_content=_description_content;
@synthesize editButton=_editButton;
@synthesize like_icon=_like_icon;
@synthesize join_icon=_join_icon;
@synthesize doitmyself_icon=_doitmyself_icon;
@synthesize like_label=_like_label;
@synthesize join_label=_join_label;
@synthesize doitmyself_label=_doitmyself_label;
@synthesize isLiked=_isLiked;
@synthesize isJoined=_isJoined;
@synthesize isAdded=_isAdded;

@synthesize shareButton=_shareButton;
@synthesize actionButtonHolder=_actionButtonHolder;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize event_title=_event_title;
@synthesize event_time=_event_time;
@synthesize event_img_url=_event_img_url;
@synthesize location_name=_location_name;
@synthesize longitude=_longitude;
@synthesize latitude=_latitude;
@synthesize description=_description;
@synthesize comments=_comments;
@synthesize creator_id=_creator_id;
@synthesize event_address=_event_address;
@synthesize garbageCollection=_garbageCollection;
@synthesize interestedPeople=_interestedPeople;
@synthesize likedPeople=_likedPeople;
@synthesize invitee=_invitee;
@synthesize interestedPeopleLabelView=_interestedPeopleLabelView;
@synthesize likedPeopleLabelView=_likedPeopleLabelView;
@synthesize tap_user_id=_tap_user_id;

@synthesize peopleGoOutWith=_peopleGoOutWith;
@synthesize peopleGoOutWithMessage=_peopleGoOutWithMessage;
@synthesize preDefinedMode=_preDefinedMode;
@synthesize delegate=_delegate;
@synthesize interestOrInviteButton = _interestOrInviteButton;
@synthesize pickOrEditButton = _pickOrEditButton;
//@synthesize shareButton = _shareButton;
@synthesize via=_via;
@synthesize next_page_profile_via=_next_page_profile_via;
@synthesize view_height=_view_height;
@synthesize isEventOwner=_isEventOwner;
@synthesize mysendMessageType=_mysendMessageType;
@synthesize alreadyInvitedFriend=_alreadyInvitedFriend;
//@synthesize shouldGoBack=_shouldGoBack;
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
    
    //--------Navigation bar and Back button--------//
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.shareButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    
    //initiate views
    self.eventImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DVC_EVENT_IMG_WIDTH, DVC_EVENT_IMG_HEIGHT)];
    [self.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.eventImageView setClipsToBounds:YES];
    [self.myScrollView addSubview:self.eventImageView];
    
    self.creatorProfileView = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.eventImageView.frame.origin.y+self.eventImageView.frame.size.height+10, 35, 35)];
    [self.creatorProfileView setClipsToBounds:YES];
    [self.creatorProfileView setContentMode:UIViewContentModeScaleAspectFill];
    [self.myScrollView addSubview:self.creatorProfileView];
    
    self.creatorNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.creatorProfileView.frame.origin.x+self.creatorProfileView.frame.size.width+5, self.creatorProfileView.frame.origin.y, 150, 35)];
    [self.creatorNameLabel setTextAlignment:UITextAlignmentCenter];
    [self.creatorNameLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.creatorNameLabel setTextColor:[UIColor colorWithRed:0/255 green:51/255 blue:204/255 alpha:1]];
    [self.myScrollView addSubview:self.creatorNameLabel];
    
    self.creatorProfileButton = [[UIButton alloc] init];
    [self.creatorProfileButton addTarget:self action:@selector(profileClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.myScrollView addSubview:self.creatorProfileButton];
    
    self.eventTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.creatorNameLabel.frame.origin.y+self.creatorNameLabel.frame.size.height+15, 300, 40)];
    [self.eventTitleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    self.eventTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.eventTitleLabel.numberOfLines = 0;
    [self.myScrollView addSubview:self.eventTitleLabel];
    
    self.timeSectionView = [[UIView alloc] init];
    [self.myScrollView addSubview:self.timeSectionView];
    
    self.locationSectionView = [[UIView alloc] init];
    [self.myScrollView addSubview:self.locationSectionView];
    
    self.commentSectionView = [[UIView alloc] init];
    [self.myScrollView addSubview:self.commentSectionView];
    
    self.editButton = [[UIButton alloc] init];
    [self.myScrollView addSubview:self.editButton];
        
    self.descriptionSectionView = [[UIView alloc] init];
    [self.myScrollView addSubview:self.descriptionSectionView];
}

- (void)viewDidUnload
{
    [self setMyScrollView:nil];
    [self setEventImageView:nil];
    [self setInterestOrInviteButton:nil];
    [self setPickOrEditButton:nil];
    
    [self setShareButton:nil];
    [self setActionButtonHolder:nil];
    [self setLikeButtonSection:nil];
    [self setJoinButtonSection:nil];
    [self setDoitmyselfButtonSection:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    //delete notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set the should back to false
//    self.shouldGoBack=NO;
    
    //judge whether the user is login? if not, do the login
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"login_auth_token"]) {
        //if not login, do it
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        LoginPageViewController* loginVC=[storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
        loginVC.parentVC=self;
        loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginVC animated:YES completion:^{}];
    }
    else{

        //initial the contentsize of the myScrollView
        [self.myScrollView setContentSize:CGSizeMake(DETAIL_VIEW_CONTROLLER_SCROLLVIEW_INITIAL_CONTENTSIZE_WIDTH, self.commentSectionView.frame.origin.y + 50)];
        
        //start a new connection, to fetch data from the server (about event detail)
        NSString *request_string=[NSString stringWithFormat:@"%@/events/view?event_id=%@&shared_event_id=%@&via=%d",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,self.via];//self.via
        
        
        if ([defaults objectForKey:@"login_auth_token"]) {
            request_string=[NSString stringWithFormat:@"%@/events/view?event_id=%@&shared_event_id=%@&via=%d&auth_token=%@",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,self.via,[defaults objectForKey:@"login_auth_token"]];
        }
        
        
        NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        
        //change the button title based on the BOOL isOwner
        if (self.isEventOwner) {
            [self.actionButtonHolder setHidden:YES];
            self.editButton.frame = CGRectMake(240, 190, 70, 30);
            [self.editButton addTarget:self action:@selector(editButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            self.like_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail-interested-color.png"]];
            self.like_icon.frame = CGRectMake(15, 13, 24, 24);
            self.like_label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 45, 50)];
            [self.like_label setBackgroundColor:[UIColor clearColor]];
            [self.like_label setFont:[UIFont boldSystemFontOfSize:14]];
            [self.like_label setTextColor:[UIColor whiteColor]];
            
            
            self.join_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail-invite-color.png"]];
            self.join_icon.frame = CGRectMake(10, 13, 24, 24);            
            self.join_label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 50, 50)];
            [self.join_label setBackgroundColor:[UIColor clearColor]];
            [self.join_label setFont:[UIFont boldSystemFontOfSize:14]];
            [self.join_label setTextColor:[UIColor whiteColor]];
            
            
            self.doitmyself_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail-pick-color.png"]];
            self.doitmyself_icon.frame = CGRectMake(5, 13, 24, 24);            
            self.doitmyself_label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 105, 50)];
            [self.doitmyself_label setBackgroundColor:[UIColor clearColor]];
            [self.doitmyself_label setFont:[UIFont boldSystemFontOfSize:14]];
            [self.doitmyself_label setTextColor:[UIColor whiteColor]];            
        }
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //if the event not exist, go back
//    if (self.shouldGoBack) {
//        [self.navigationController popViewControllerAnimated:NO];
//    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined method 
//return the share message
-(NSString*)shareMessagetoSend{
    return [NSString stringWithFormat:@"Hey,\n\nI found an event that you may be interested in.\n\nEvent : %@  \nLocation : %@ \nTime : %@ \n\nLet me know whether you wanna join! \n\n-Shared via OrangeParc (http://www.orangeparc.com)",self.event_title,self.location_name,self.event_time];
}

//return the share message
-(NSString*)inviteMessagetoSend{
    return [NSString stringWithFormat:@"I just found an interesting event \"%@\" at %@. It will start \"%@\". I want to invite you to join me.\nYou can check out more details at http://www.orangeparc.com",self.event_title,self.location_name,self.event_time];
}

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

- (void)editButtonClicked{
    [self performSegueWithIdentifier:@"repin to create new event" sender:self];
}

- (IBAction)shareButtonClicked:(UIBarButtonItem *)sender {
    //give user several way to share
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Share with:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"SMS Message",@"Facebook Wall",@"Twitter",@"WeChat", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

- (void)profileClicked{
    if (self.isEventOwner) {
        [self performSegueWithIdentifier:@"ViewProfile" sender:self];
    } else {
        [self performSegueWithIdentifier:@"ViewOthersProfile" sender:self];
    }
}

//handle the action: doitmyselfButtonClicked
- (IBAction)PickButtonClicked:(id)sender {
    if ([self.isAdded isEqualToString:@"1"]) {
        return;
    }
    [self performSegueWithIdentifier:@"repin to create new event" sender:self];
    
}

//handle the action: joinButtonClicked
- (IBAction)joinButtonClicked:(UIButton *)sender {
    //send join information to server
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url;
    if ([self.isJoined isEqualToString:@"0"]) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/interest?event_id=%@&shared_event_id=%@&auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,[defaults objectForKey:@"login_auth_token"],self.via]];
        [self.join_label setText:@"Joined"];
        self.isJoined = @"1"; 
    } else {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/uninterest?event_id=%@&shared_event_id=%@&auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,[defaults objectForKey:@"login_auth_token"],self.via]];
        [self.join_label setText:@"Join"];
        self.isJoined = @"0";
    }
    

    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"GET"];
        [request startSynchronous];

        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                // Use when fetching text data
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    NSLog(@"%@",[NSString stringWithFormat:@"Joined!"]);
                } else {
                    NSLog(@"%@",[NSString stringWithFormat:@"Oops, something went wrong:%@",[json objectForKey:@"message"]]);
                }
            }
            else{
                //connect error
                NSError *error = [request error];
                NSLog(@"%@",[NSString stringWithFormat:@"Error: %@",error.description ]);
            }
            
        });
        
    });
    
}

- (IBAction)likeButtonClicked:(UIButton *)sender {
    //send like information to server
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url;
    if ([self.isLiked isEqualToString:@"0"]) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/like?event_id=%@&shared_event_id=%@&auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,[defaults objectForKey:@"login_auth_token"],self.via]];
        [self.like_label setText:@"Unlike"];
        self.isLiked=@"1";
    } else {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/unlike?event_id=%@&shared_event_id=%@&auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,[defaults objectForKey:@"login_auth_token"],self.via]];
        [self.like_label setText:@"Like"];
        self.isLiked=@"0";
    }
    
    

    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    NSLog(@"%@",[NSString stringWithFormat:@"Liked!"]);
                } else {
                    NSLog(@"%@",[NSString stringWithFormat:@"Something went wrong:%@",[json objectForKey:@"message"]]);
                }
            }
            else{
                //connect error
                NSError *error = [request error];
                NSLog(@"%@",[NSString stringWithFormat:@"Error: %@",error.description]);
            }
            
        });
        
    });
}

#pragma mark - action sheet related stuff
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{    
    /*
     //give user several way to share
     UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose To Share:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email",@"Facebook Wall",@"Twitter",@"Wechat",@"Self enter", nil];
     pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
     [pop showFromTabBar:self.tabBarController.tabBar];
     */
    if([actionSheet.title isEqualToString:@"Share with:"]){
        NSString *channel=nil;
        
        //this is for share, the message/email is different
        self.mysendMessageType=@"share";
        if (buttonIndex == 0) {
            NSLog(@"email");
            self.preDefinedMode=@"email";
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
            
            channel=[NSString stringWithFormat:@"%d",VIA_EMAIL];
        }
        else if (buttonIndex == 1) {
            NSLog(@"SMS message");
            self.preDefinedMode=@"message";
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
            
            channel=[NSString stringWithFormat:@"%d",VIA_SMS];
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
            [params setObject:[self shareMessagetoSend] forKey:@"message"];
            //[params setObject:[NSString stringWithFormat:@"Hi All,\n\nI feels good, want to inivite you to do %@ . The time I think %@ is good. Dose that sounds good? Shall we meet at %@?\n\nYeah~\n\nCheers~",self.event_title,self.event_time,self.location_name] forKey:@"message"];
            
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
            
            channel=[NSString stringWithFormat:@"%d",VIA_FACEBOOK];
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
            
            channel=[NSString stringWithFormat:@"%d",VIA_TWITTER];
        }
        else if (buttonIndex == 4) {
            NSLog(@"wechat");
            UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose A WeChat Way" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share On Moment",@"Send Friend Message", nil];
            pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
            [pop showFromTabBar:self.tabBarController.tabBar];
            channel=[NSString stringWithFormat:@"%d",VIA_WECHAT];
        }
        
        //send log to server
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/share?event_id=%@&shared_event_id=%@&via=%d&auth_token=%@&channel=%@",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,self.via,[defaults objectForKey:@"login_auth_token"],channel]];
        
        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);

        });
        
        
        
    }
    else if([actionSheet.title isEqualToString:@"Choose A WeChat Way"]){
        if(buttonIndex == 0){
            //shared on moment
            [self.delegate SendMoment:[NSString stringWithFormat:@"Event: %@  Location: %@ Time: %@ --Shared via OrangeParc",self.event_title,self.location_name,self.event_time] WithImageURL:self.event_img_url];
        }
        else if(buttonIndex == 1){
            //send message to friend
            [self.delegate sendText:[self shareMessagetoSend]];
        }
    }
    else if ([actionSheet.title isEqualToString:@"Invite Friend:"]){
        //this type if for inviting people
        self.mysendMessageType=@"invite";
        if(buttonIndex == 0){
            //email invite
            NSLog(@"email invite");
            self.preDefinedMode=@"email";
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
        }
        else if(buttonIndex == 1){
            //sms invite
            NSLog(@"SMS message invite");
            self.preDefinedMode=@"message";
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
        }
        else if (buttonIndex ==2){
            //WeChat Invite
            //send message to friend
            [self.delegate sendText:[self inviteMessagetoSend]];
        }
    }
}

//handle joined people section
-(void)handleTheInterestedPeoplePart{
    if (self.garbageCollection) {
        for (UIView* view in self.garbageCollection) {
            [view removeFromSuperview];
        }
        [self.garbageCollection removeAllObjects];
    }
    self.garbageCollection=[NSMutableArray array];
    int height;
    if ([self.likedPeople count]==0) {
        if ([self.invitee count]==0) {
            if ([self.description_content.text isEqualToString:@""]) {
                height = self.locationSectionView.frame.origin.y+self.locationSectionView.frame.size.height+10;
            } else {
                height = self.descriptionSectionView.frame.origin.y+self.descriptionSectionView.frame.size.height+10;
            }
        } else {
            height = self.invitedPeopleSectionView.frame.origin.y+self.invitedPeopleSectionView.frame.size.height+10;
        }
    } else {
        height = self.likedPeopleLabelView.frame.origin.y + self.likedPeopleLabelView.frame.size.height + 10;
    }
    if ([self.interestedPeople count]>0) {
        self.interestedPeopleLabelView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 65)];
        [self.myScrollView addSubview:self.interestedPeopleLabelView];
        //add gesture(tap)
        self.interestedPeopleLabelView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlock:)];
        [self.interestedPeopleLabelView addGestureRecognizer:tapGR];
        [self.interestedPeopleLabelView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        UILabel* numOfInterests=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT)];
        if ([self.interestedPeople count] == 1) {
            [numOfInterests setText:[NSString stringWithFormat:@"1 Join"]];
        } else {
            [numOfInterests setText:[NSString stringWithFormat:@"%d Joins",[self.interestedPeople count]]];
        }
        [numOfInterests setFont:[UIFont boldSystemFontOfSize:14]];
        [numOfInterests setTextColor:[UIColor darkGrayColor]];
        [numOfInterests setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        [self.interestedPeopleLabelView addSubview:numOfInterests];
        //[self.garbageCollection addObject:numOfInterests];
        
        int x_position_photo=5;
        for (int i=0; i<7&&i<([self.interestedPeople count]); i++) {
            UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x_position_photo+5, 25, 35, 35)];
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
            [self.interestedPeopleLabelView addSubview:userImageView];
            x_position_photo+=38;
        }
    }
}

//handle liked people section
-(void)handleLikedPeoplePart{
    if (self.garbageCollection) {
        for (UIView* view in self.garbageCollection) {
            [view removeFromSuperview];
        }
        [self.garbageCollection removeAllObjects];
    }
    self.garbageCollection=[NSMutableArray array];
    
    int height;
    if ([self.invitee count] == 0) {
        if ([self.description_content.text isEqualToString:@""]) {
            height = self.locationSectionView.frame.origin.y + self.locationSectionView.frame.size.height + 10;
        } else {
            height = self.descriptionSectionView.frame.origin.y + self.descriptionSectionView.frame.size.height + 10;
        }
    } else {
        height = self.invitedPeopleSectionView.frame.origin.y+self.invitedPeopleSectionView.frame.size.height+10;
    }
    if ([self.likedPeople count]>0) {
        self.likedPeopleLabelView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 65)];
        [self.myScrollView addSubview:self.likedPeopleLabelView];
        //add gesture(tap)
        self.likedPeopleLabelView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLikeBlock:)];
        [self.likedPeopleLabelView addGestureRecognizer:tapGR];
        [self.likedPeopleLabelView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        UILabel* numOflikes=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT)];
        if ([self.likedPeople count] == 1) {
            [numOflikes setText:[NSString stringWithFormat:@"1 Like"]];
        } else {
            [numOflikes setText:[NSString stringWithFormat:@"%d Likes",[self.likedPeople count]]];
        }
        [numOflikes setFont:[UIFont boldSystemFontOfSize:14]];
        [numOflikes setTextColor:[UIColor darkGrayColor]];
        [numOflikes setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        [self.likedPeopleLabelView addSubview:numOflikes];
        //[self.garbageCollection addObject:numOfInterests];
        
        int x_position_photo=5;
        for (int i=0; i<7&&i<([self.likedPeople count]); i++) {
            UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x_position_photo+5, 25, 35, 35)];
            ProfileInfoElement* element=[self.likedPeople objectAtIndex:i];
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
            [self.likedPeopleLabelView addSubview:userImageView];
            x_position_photo+=38;
        }
    }
}

//handle invited people section
-(void)handleInvitedPeoplePart{
    if (self.garbageCollection) {
        for (UIView* view in self.garbageCollection) {
            [view removeFromSuperview];
        }
        [self.garbageCollection removeAllObjects];
    }
    self.garbageCollection=[NSMutableArray array];
    int height;
    if ([self.description_content.text isEqualToString:@""]) {
        height = self.locationSectionView.frame.origin.y + self.locationSectionView.frame.size.height + 10;
    } else {
        height = self.descriptionSectionView.frame.origin.y + self.descriptionSectionView.frame.size.height + 10;
    }
    
    if ([self.invitee count]>0) {
        self.invitedPeopleSectionView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 65)];
        [self.myScrollView addSubview:self.invitedPeopleSectionView];
        //add gesture(tap)
        self.invitedPeopleSectionView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInviteBlock:)];
        [self.invitedPeopleSectionView addGestureRecognizer:tapGR];
        [self.invitedPeopleSectionView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        UILabel* numOfInvites=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT)];
        if ([self.invitee count] == 1) {
            [numOfInvites setText:[NSString stringWithFormat:@"1 friend invited"]];
        } else {
            [numOfInvites setText:[NSString stringWithFormat:@"%d friends invited",[self.invitee count]]];
        }
        [numOfInvites setFont:[UIFont boldSystemFontOfSize:14]];
        [numOfInvites setTextColor:[UIColor darkGrayColor]];
        [numOfInvites setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        [self.invitedPeopleSectionView addSubview:numOfInvites];
        //[self.garbageCollection addObject:numOfInterests];
        
        int x_position_photo=5;
        for (int i=0; i<7&&i<([self.invitee count]); i++) {
            UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x_position_photo+5, 25, 35, 35)];
            ProfileInfoElement* element=[self.invitee objectAtIndex:i];
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
            [self.invitedPeopleSectionView addSubview:userImageView];
            x_position_photo+=38;
        }
    }
}

//handle the comment part from self.comments
-(void)handleTheCommentPart{
    if (self.garbageCollection) {
        for (UIView* view in self.garbageCollection) {
            [view removeFromSuperview];
        }
        [self.garbageCollection removeAllObjects];
    }    
    self.garbageCollection=[NSMutableArray array];
    //comment
    int height;
    if ([self.interestedPeople count] == 0) {
        if ([self.likedPeople count] == 0) {
            if ([self.invitee count] == 0) {
                if ([self.description_content.text isEqualToString:@""]) {
                    height = self.locationSectionView.frame.origin.y + self.locationSectionView.frame.size.height + 10;
                } else {
                    height = self.descriptionSectionView.frame.origin.y + self.descriptionSectionView.frame.size.height + 10;
                }
            } else {
                height = self.invitedPeopleSectionView.frame.origin.y+self.invitedPeopleSectionView.frame.size.height+10;
            }            
        } else {
            height=self.likedPeopleLabelView.frame.origin.y + self.likedPeopleLabelView.frame.size.height + 10;
        }        
    } else {
        height = self.interestedPeopleLabelView.frame.origin.y + self.interestedPeopleLabelView.frame.size.height + 10;
    }
    //comment header view
    UIView *comments_header_view = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 30)];
    [comments_header_view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
    [self.myScrollView addSubview:comments_header_view];
    
    //comment icon
//    UIImageView *comment_icon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 1, 12, 30)];
//    UIImage *image_comment_icon = [UIImage imageNamed:@"comments.png"]; 
//    [comment_icon setImage:image_comment_icon];
//    [comment_icon setContentMode:UIViewContentModeScaleAspectFit];
//    [comment_icon setAlpha:0.4];
//    [comments_header_view addSubview:comment_icon];
    
    //comment header label
    UILabel *comment_header_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
    NSString *comment_header;
    if ([self.comments count] == 0 || [self.comments count] == 1) {
        comment_header = [NSString stringWithFormat:@"%d Comment", [self.comments count]];
    }else {
        comment_header = [NSString stringWithFormat:@"%d Comments", [self.comments count]];
    }
    [comment_header_label setText:comment_header];
    [comment_header_label setBackgroundColor:[UIColor clearColor]];
    [comment_header_label setFont:[UIFont boldSystemFontOfSize:14]];
    [comment_header_label setTextColor:[UIColor darkGrayColor]];
    [comment_header_label setShadowColor:[UIColor whiteColor]];
    [comment_header_label setShadowOffset: CGSizeMake(0, 1)];
    [comments_header_view addSubview:comment_header_label];
    
    //button
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(220, 4, 80, 22)];
    [button setAlpha:1];
    //add button action
    [button addTarget:self 
               action:@selector(addViewCommentButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"+ Comment" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [button setBackgroundImage:[UIImage imageNamed:@"button_comment.png"] forState:UIControlStateNormal];
    [comments_header_view addSubview:button];
    [self.garbageCollection addObject:button];
    
    height = 32 + height;
    //add every single comment entry
    for (int i = 0; i<[self.comments count]; i++) {
        //if(i==5)break; //in this page, only present a few comments
        eventComment* comment=[self.comments objectAtIndex:i];  
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(10, height, 300, 0)];
        [commentView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];        
        
        //UILabel *comment_user_name=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, DETAIL_VIEW_CONTROLLER_COMMENT_HEIGHT)];
    
        UILabel *comment_user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 100, 0)];
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
        UILabel *comment_content_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 290, 0)];
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
        //distance between two comment view is 0px.
        height = height + commentView.bounds.size.height;
        
        [self.garbageCollection addObject:commentView];        
    }
    //set the scroll view content size
    self.commentSectionView.frame = CGRectMake(0, height+15, 320, 200);
    [self.myScrollView setContentSize:CGSizeMake(320, height+5+50)];
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"repin to create new event"]) {
        NewEventVC *newEventVC = segue.destinationViewController;
        [newEventVC repinTheEventWithEventID:self.event_id sharedEventID:self.shared_event_id creatorID:self.creator_id eventTitle:self.event_title eventTime:self.event_time eventImage:self.eventImageView.image locationName:self.location_name address:self.event_address longitude:self.longitude latitude:self.latitude description:self.description];
        if (self.isEventOwner) {
            //set the event page to be editable
            [newEventVC presetIsEditPageToTrue];
            [newEventVC preSetAlreadyInvitedFriend:[InviteFriendObject generateAlreadyInvitedInfoElementArrayFromJson:self.alreadyInvitedFriend]];
            
        } else {
            [newEventVC presetIsEditPageToFalse];
        }
        [newEventVC presetVia:self.via];
    }
    else if([segue.identifier isEqualToString:@"addAndViewComment"]){
        if ([segue.destinationViewController isKindOfClass:[AddCommentVC class]]) {
            AddCommentVC *commentVC=segue.destinationViewController;
            commentVC.comments=[self.comments copy];
            commentVC.event_id=self.event_id;
            commentVC.shared_event_id=self.shared_event_id;
            commentVC.via=self.via;
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
    else if([segue.identifier isEqualToString:@"ViewOthersProfile"]){
        OtherProfilePageViewController* OPPVC=segue.destinationViewController;
        OPPVC.creator_id=self.creator_id;
        if(self.via==VIA_FEEDS){
            OPPVC.via=VIA_FEEDS_DETAIL;
        }
        else if(self.via==VIA_EXPLORE){
            OPPVC.via=VIA_EXPLORE_DETAIL;
        }
    }
    else if([segue.identifier isEqualToString:@"ViewJoinedPeopleProfile"]){
        OtherProfilePageViewController* OPPVC=segue.destinationViewController;
        OPPVC.creator_id=self.tap_user_id;
        //send the next page the via information
        OPPVC.via=self.next_page_profile_via;

    }
    else if([segue.identifier isEqualToString:@"ViewLocation"]){
        detailLocationMapViewController* MVC=(detailLocationMapViewController*)segue.destinationViewController;
        CLLocationCoordinate2D location;
        NSLog(@"%@",self.latitude );
        NSLog(@"%@",self.longitude);
        NSLog(@"%@",self.location_name);
        
        location.latitude=[self.latitude floatValue];
        location.longitude=[self.longitude floatValue];
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = location;
        annotationPoint.title=self.location_name;
        [MVC setPredefinedAnnotation:annotationPoint];
    }
    else if([segue.identifier isEqualToString:@"ViewProfile"]){
        ProfilePageViewController* PVVC=segue.destinationViewController;
        if(self.via==VIA_FEEDS){
            PVVC.via=VIA_FEEDS_DETAIL;
        }
        else if(self.via==VIA_EXPLORE){
            PVVC.via=VIA_EXPLORE_DETAIL;
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
    //fetch event info
    NSError *error;
    NSDictionary *event = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    NSLog(@"%@",event);
    
    if (self.isEventOwner) {
        //find the invited friend
        self.alreadyInvitedFriend =[event objectForKey:@"invitees"];
    }
    
    //if the activity is not exist, pop back to the last page
    if ([[event objectForKey:@"response"] isEqualToString:@"error"]) {
        UIAlertView *NotExistAlert = [[UIAlertView alloc] initWithTitle:@"Not Found Error"
                                                        message:[event objectForKey:@"message"]
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [NotExistAlert show];
        //should go back to the former page
//        self.shouldGoBack=YES;
    }
    else{
        //should go back to the former page
//        self.shouldGoBack=NO;
        
        self.event_title=[event objectForKey:@"title"];
        self.event_img_url=[NSURL URLWithString:[event objectForKey:@"photo_url"] !=[NSNull null]?[event objectForKey:@"photo_url"]:@"no url"];
        self.event_time=[event objectForKey:@"start_time"] !=[NSNull null]?[event objectForKey:@"start_time"]:@"Anytime";
        self.creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
        self.location_name=[event objectForKey:@"location"] !=[NSNull null]?[event objectForKey:@"location"]:@"location name unavailable";
        self.event_address=[event objectForKey:@"address"];
        self.creator_img_url=[NSURL URLWithString:[event objectForKey:@"creator_pic"]];
        NSLog(@"%@",self.creator_img_url);
        self.creator_name=[event objectForKey:@"creator_name"];
        self.isLiked=[NSString stringWithFormat:@"%@",[event objectForKey:@"liked"]];
        self.isJoined=[NSString stringWithFormat:@"%@",[event objectForKey:@"joined"]];
        self.isAdded=[NSString stringWithFormat:@"%@",[event objectForKey:@"pinned"]];
        self.latitude=[NSString stringWithFormat:@"%@",[event objectForKey:@"latitude"]];
        self.longitude=[NSString stringWithFormat:@"%@",[event objectForKey:@"longitude"]];
        NSString *description=[event objectForKey:@"description"]!=[NSNull null]?[event objectForKey:@"description"]:@"";
        // NSString *longitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"longitude"]];
        // NSString *latitude=[NSString stringWithFormat:@"%f",[event objectForKey:@"latitude"]];
        NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
        
        //handle the action button label part
        [self.like_icon removeFromSuperview];
        [self.like_label removeFromSuperview];
        [self.join_icon removeFromSuperview];
        [self.join_label removeFromSuperview];
        [self.doitmyself_icon removeFromSuperview];
        [self.doitmyself_label removeFromSuperview];
        if ([self.isLiked isEqualToString:@"0"]) {
            [self.like_label setText:@"Like"];
        } else {
            [self.like_label setText:@"Unlike"];
        }
        if ([self.isJoined isEqualToString:@"0"]) {
            [self.join_label setText:@"Join"];
        } else {
            [self.join_label setText:@"Joined"];
        }
        if ([self.isAdded isEqualToString:@"0"]) {
            [self.doitmyself_label setText:@"Do it myself"];
        } else {
            [self.doitmyself_label setText:@"Already added"];
        }
        [self.likeButtonSection addSubview:self.like_icon];
        [self.likeButtonSection addSubview:self.like_label];
        [self.joinButtonSection addSubview:self.join_icon];
        [self.joinButtonSection addSubview:self.join_label];
        [self.doitmyselfButtonSection addSubview:self.doitmyself_icon];
        [self.doitmyselfButtonSection addSubview:self.doitmyself_label];
        
        //handle the interest people part
        self.interestedPeople=[[ProfileInfoElement generateProfileInfoElementArrayFromJson:[event objectForKey:@"interests"]] mutableCopy];
        
        //handle the liked people part
        self.likedPeople=[[ProfileInfoElement generateProfileInfoElementArrayFromJson:[event objectForKey:@"likes"]] mutableCopy];
        self.invitee = [[ProfileInfoElement generateProfileInfoElementArrayFromJson:[event objectForKey:@"invitees"]] mutableCopy];
        
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
        //set event image
        if (![Cache isURLCached:self.event_img_url]) {
            //using high priority queue to fetch the image
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                //get the image data
                NSData * imageData = nil;
                imageData = [[NSData alloc] initWithContentsOfURL: self.event_img_url];
                if ( imageData == nil ){
                    //if the image data is nil, the image url is not reachable. using a default image to replace that
                    UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
                    imageData=UIImagePNGRepresentation(image);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:self.event_img_url withData:imageData];
                            [self.eventImageView setImage:image];
                        });
                    }
                }
                else {
                    //else, the image date getting finished, directly put it in the cache, and then reload the table view data.
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:self.event_img_url withData:imageData];
                            [self.eventImageView setImage:[UIImage imageWithData:imageData]];
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [self.eventImageView setImage:[UIImage imageWithData:[Cache getCachedData:self.event_img_url]]];
            });
        }
        
        NSLog(@"%@",self.creator_img_url);
        //set creator's profile image and name. Link back to his/her profile page.
        if (![Cache isURLCached:self.creator_img_url]) {
            //using high priority queue to fetch the image
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                //get the image data
                NSData * imageData = nil;
                imageData = [[NSData alloc] initWithContentsOfURL: self.creator_img_url];
                
                if ( imageData == nil ){
                    //if the image data is nil, the image url is not reachable. using a default image to replace that
                    //NSLog(@"downloaded %@ error, using a default image",profile_url);
                    UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
                    imageData=UIImagePNGRepresentation(image);
                    
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:self.creator_img_url withData:imageData];
                            [self.creatorProfileView setImage:[UIImage imageWithData:imageData]];

                        });
                    }
                }
                else {
                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                    //NSLog(@"downloaded %@",profile_url);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:self.creator_img_url withData:imageData];
                            [self.creatorProfileView setImage:[UIImage imageWithData:imageData]];
 
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [self.creatorProfileView setImage:[UIImage imageWithData:[Cache getCachedData:self.creator_img_url]]];
            });
        }
        [self.creatorNameLabel setText:[NSString stringWithFormat:@"%@",self.creator_name]];
        [self.creatorNameLabel setTextColor:[UIColor colorWithRed:0 green:0/255.0 blue:80/255.0 alpha:1]];
        CGSize contributorNameLabel_expectedWidth = [self.creator_name sizeWithFont:[UIFont boldSystemFontOfSize:14] forWidth:150 lineBreakMode:UILineBreakModeClip];
        CGRect contributor_frame = self.creatorNameLabel.frame;
        contributor_frame.size.width = contributorNameLabel_expectedWidth.width;
        self.creatorNameLabel.frame = contributor_frame;
        self.creatorProfileButton.frame = CGRectMake(self.creatorProfileView.frame.origin.x, self.creatorProfileView.frame.origin.y, self.creatorProfileView.frame.size.width+self.creatorNameLabel.frame.size.width + 10,self.creatorProfileView.frame.size.height);
        
        //set event title
        [self.eventTitleLabel setText:self.event_title];
        CGSize maximumLabelSize1 = CGSizeMake(300,9999);
        CGSize expectedLabelSize1 = [self.event_title sizeWithFont:[UIFont boldSystemFontOfSize:16.0] constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeWordWrap];
        CGRect newFrame1 = self.eventTitleLabel.frame;
        newFrame1.size.height = expectedLabelSize1.height;
        self.eventTitleLabel.frame = newFrame1;
        
        //set seperator
        UIImageView *seperator = [[UIImageView alloc] initWithFrame:CGRectMake(10, self.eventTitleLabel.frame.origin.y+self.eventTitleLabel.frame.size.height + 10, 300, 1)];
        [seperator setImage:[UIImage imageNamed:@"seperator.png"]];
        [self.myScrollView addSubview:seperator];
        
        //set time label and clock icon
        if ([self.event_time isEqualToString:@""]) {
            self.event_time = [NSString stringWithFormat:@"Not Specified"];
        }
        self.timeSectionView.frame = CGRectMake(10, self.eventTitleLabel.frame.origin.y+self.eventTitleLabel.frame.size.height+15, 300, 30);
        UIImageView *timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 9, 12, 12)];
        [timeIcon setImage:[UIImage imageNamed:TIME_ICON]];
        [timeIcon setAlpha:0.7];
        [self.timeSectionView addSubview:timeIcon];
        UILabel *eventTime = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 230, 20)];
        [eventTime setText:self.event_time];
        [eventTime setFont:[UIFont boldSystemFontOfSize:14]];
        [eventTime setTextColor:[UIColor darkGrayColor]];
        eventTime.lineBreakMode = UILineBreakModeClip;
        eventTime.numberOfLines = 1;
        [self.timeSectionView addSubview:eventTime];
        
        //set address section
        if ([self.location_name isEqualToString:@""]) {
            self.location_name = [NSString stringWithFormat:@"Not Specified"];
        }
        self.locationSectionView.frame = CGRectMake(10, self.timeSectionView.frame.origin.y+self.timeSectionView.frame.size.height, 300, 30);
        UILabel *eventLocation = [[UILabel alloc] initWithFrame: CGRectMake(20, 5, 220, 20)];
        [eventLocation setText:self.location_name];
        [eventLocation setFont:[UIFont boldSystemFontOfSize:14]];
        [eventLocation setTextColor:[UIColor darkGrayColor]];
        eventLocation.lineBreakMode = UILineBreakModeClip;
        eventLocation.numberOfLines = 1;
        //    CGSize maximumLabelSize3 = CGSizeMake(270,9999);
        //    CGSize expectedLabelSize3 = [self.location_name sizeWithFont:[UIFont boldSystemFontOfSize:14.0] constrainedToSize:maximumLabelSize3 lineBreakMode:UILineBreakModeWordWrap];
        //    CGRect newFrame3 = eventLocation.frame;
        //    newFrame3.size.height = expectedLabelSize3.height;
        //    eventLocation.frame = newFrame3;
        [self.locationSectionView addSubview:eventLocation];
        UIImageView *locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 8, 8, 14)];
        [locationIcon setImage:[UIImage imageNamed:LOCATION_ICON]];
        [locationIcon setAlpha:0.7];
        [self.locationSectionView addSubview:locationIcon];
        
        UILabel *map_indicator_label = [[UILabel alloc] initWithFrame:CGRectMake(255, 5, 35, 20)];
        [map_indicator_label setText:@"Map"];
        [map_indicator_label setFont:[UIFont boldSystemFontOfSize:13]];
        [map_indicator_label setTextColor:[UIColor lightGrayColor]];
        [self.locationSectionView addSubview:map_indicator_label];
        UIImageView *right_Arrow = [[UIImageView alloc] initWithFrame:CGRectMake(285, 10.75, 6, 8.5)];
        [right_Arrow setImage:[UIImage imageNamed:@"detailButton.png"]];
        right_Arrow.alpha = 0.6;
        
        [self.locationSectionView addSubview:right_Arrow];
        UIButton *showMapButton = [[UIButton alloc] initWithFrame:CGRectMake(250, 5, 50, 20)];
        [showMapButton addTarget:self action:@selector(showMapButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.locationSectionView addSubview:showMapButton];
        
        self.description_content = [[UILabel alloc] initWithFrame:CGRectMake(5, 30, 290, 50)];
        [self.description_content setText:description];
        [self.description_content setFont:[UIFont systemFontOfSize:13]];
        [self.description_content setTextColor:[UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1]];
        self.description_content.lineBreakMode = UILineBreakModeWordWrap;
        self.description_content.numberOfLines = 0;
        CGSize maximumLabelSize_description = CGSizeMake(290,9999);
        CGSize expectedLabelSize_description = [description sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize_description lineBreakMode:UILineBreakModeWordWrap];
        CGRect newFrame_description = self.description_content.frame;
        newFrame_description.size.height = expectedLabelSize_description.height;
        self.description_content.frame = newFrame_description;
        UILabel *description_header=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 150, 20)];
        [description_header setText:@"Description"];
        [description_header setFont:[UIFont boldSystemFontOfSize:14]];
        [description_header setTextColor:[UIColor darkGrayColor]];
        self.descriptionSectionView.frame=CGRectMake(10, self.locationSectionView.frame.origin.y+self.locationSectionView.frame.size.height, 300, expectedLabelSize_description.height+35);
        [self.descriptionSectionView addSubview:description_header];
        [self.descriptionSectionView addSubview:self.description_content];
        if ([self.description_content.text isEqualToString:@""]) {
            [self.descriptionSectionView setHidden:YES];
        } else {
            [self.myScrollView addSubview:self.descriptionSectionView];
        }
        
#warning fetch original creator info
        [self handleInvitedPeoplePart];
        if (!self.isEventOwner) {
            CGRect temp = self.invitedPeopleSectionView.frame;
            temp.size.height=0;
            self.invitedPeopleSectionView.frame = temp;
        }
        [self handleLikedPeoplePart];
        [self handleTheInterestedPeoplePart];
        //handle the comment part
        self.comments= [[eventComment getEventComentArrayFromArray:[event objectForKey:@"comments"]] mutableCopy];
        [self handleTheCommentPart];
        if (self.isEventOwner) {
            UIImageView *edit_icon = [[UIImageView alloc] initWithFrame:CGRectMake(7, 5, 20, 20)];
            [edit_icon setImage:[UIImage imageNamed:@"detail-edit-color.png"]];
            [self.editButton addSubview:edit_icon];
            UILabel *edit_label = [[UILabel alloc] initWithFrame:CGRectMake(35, 5, 25, 20)];
            [edit_label setText:@"Edit"];
            [edit_label setFont:[UIFont boldSystemFontOfSize:12]];
            [edit_label setBackgroundColor:[UIColor clearColor]];
            [edit_label setTextColor:[UIColor darkGrayColor]];
            [self.editButton addSubview:edit_label];
            [self.editButton setBackgroundImage:[UIImage imageNamed:@"button_comment.png"] forState:UIControlStateNormal];
        }
    }
    
}

-(void)showMapButtonClicked{
    [self performSegueWithIdentifier:@"ViewLocation" sender:self];
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
                
                if ([self.mysendMessageType isEqualToString:@"invite"]) {
                    //email subject
                    [mailCont setSubject:[NSString stringWithFormat:@"I want to invite you to %@",self.event_title]];
                    //email list
                    [mailCont setToRecipients:emailList];
                    //email body
                    [mailCont setMessageBody:[self inviteMessagetoSend] isHTML:NO];
                }
                else if([self.mysendMessageType isEqualToString:@"share"]){
                    //email subject
                    [mailCont setSubject:[NSString stringWithFormat:@"Someone shared an event with you via OrangeParc"]];
                    //email list
                    [mailCont setToRecipients:emailList];
                    //email body
                    [mailCont setMessageBody:[self shareMessagetoSend] isHTML:NO];
                }
                
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
                if ([self.mysendMessageType isEqualToString:@"invite"]) {
                    [messageSender setBody:[self inviteMessagetoSend]];
                }
                else if([self.mysendMessageType isEqualToString:@"share"]){
                    [messageSender setBody:[self shareMessagetoSend]];
                }
                
                
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
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Facebook" message: [NSString stringWithFormat:@"Your message has been posted on your wall."] delegate:self  cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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

//handle when user tap interested people block view
-(void)tapBlock:(UITapGestureRecognizer *)tapGR {
    if ([self.interestedPeople count]==0) {
        return;
    }
    CGPoint touchPoint=[tapGR locationInView:[self interestedPeopleLabelView]];
    float touchPointY=touchPoint.y;
    float touchPointX=touchPoint.x;
    //get the index of the touched block view
    int index=(touchPointX-5)/40;
    if (index >= [self.interestedPeople count]) {
        return;
    }
    ProfileInfoElement* tapped_element=[self.interestedPeople objectAtIndex:index];
    self.tap_user_id=tapped_element.user_id;
    if(touchPointY>25&&index<7){
        self.next_page_profile_via=VIA_JOINED_PEOPLE;
        [self performSegueWithIdentifier:@"ViewJoinedPeopleProfile" sender:self];
    }
}

//handle when user tap liked people block view
-(void)tapLikeBlock:(UITapGestureRecognizer *)tapGR {
    if ([self.likedPeople count]==0) {
        return;
    }
    CGPoint touchPoint=[tapGR locationInView:[self likedPeopleLabelView]];
    float touchPointY=touchPoint.y;
    float touchPointX=touchPoint.x;
    //get the index of the touched block view
    int index=(touchPointX-5)/40;
    if (index >= [self.likedPeople count]) {
        return;
    }
    ProfileInfoElement* tapped_element=[self.likedPeople objectAtIndex:index];
    self.tap_user_id=tapped_element.user_id;
    if(touchPointY>25&&index<7){
        self.next_page_profile_via=VIA_PEOPLE_WHO_LIKE_THIS;
        [self performSegueWithIdentifier:@"ViewJoinedPeopleProfile" sender:self];
    }
}

-(void)tapInviteBlock:(UITapGestureRecognizer *)tapGR {
    if ([self.invitee count]==0) {
        return;
    }
    CGPoint touchPoint=[tapGR locationInView:[self invitedPeopleSectionView]];
    float touchPointY=touchPoint.y;
    float touchPointX=touchPoint.x;
    //get the index of the touched block view
    int index=(touchPointX-5)/40;
    if (index >= [self.invitee count]) {
        return;
    }
    ProfileInfoElement* tapped_element=[self.invitee objectAtIndex:index];
    self.tap_user_id=tapped_element.user_id;
    if(touchPointY>25&&index<7){
        self.next_page_profile_via=VIA_INVITED_PEOPLE;
        [self performSegueWithIdentifier:@"ViewJoinedPeopleProfile" sender:self];
    }
}

#pragma mark - aler view delegate method implementation
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Not Found Error"]) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    

}

@end
