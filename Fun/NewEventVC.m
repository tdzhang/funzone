//
//  NewEventVC.m
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewEventVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Event.h"

#pragma mark - NewEventVC Private Declarition
@interface NewEventVC () <UIActionSheetDelegate>
@property (nonatomic, retain) UIImagePickerController *imgPicker; //using to start a image pick(from camera or album)
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic) BOOL showNewButtonFlag;
@property (weak, nonatomic) IBOutlet UIImageView *uIImageViewEvent;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonEditEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTime;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *inviteIcon;
@property (weak, nonatomic) IBOutlet UITextView *textFieldEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTitleHolder;
@property (weak, nonatomic) IBOutlet UILabel *inviteFriendsLabel;


//@property (weak, nonatomic) IBOutlet UILabel *eventPeopleInfo;
@property (weak, nonatomic) IBOutlet UIImageView *personProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *mapViewFeedBackImageView;
@property (nonatomic,strong) NSString* eventLocationName;
 
//from detail View controller
@property (nonatomic,strong) NSString *detail_event_id;
@property (nonatomic,strong) NSString *detail_shared_event_id;
@property (nonatomic,strong) NSString *detail_event_title;
@property (nonatomic,strong) NSString *detail_event_time;
@property (nonatomic,strong) NSString *detail_location_name;
@property (nonatomic,strong) NSString *detail_address;
@property (nonatomic,strong) NSNumber *detail_longitude;
@property (nonatomic,strong) NSNumber *detail_latitude;
@property (nonatomic,strong) NSString *detail_description;
@property (nonatomic,strong) UIImage *detail_image;
@property (nonatomic,strong) NSString *detail_creator_id;
@property (nonatomic,strong) NSString *already_load_detail_event_id;

//these property used to send back to server when create a event(image, title, location)
@property (nonatomic,strong) UIImage *createEvent_image;
@property (nonatomic) BOOL isCreateEvent_imageUsable; //indicate whether the user has choosed a imgae
@property (nonatomic,strong) NSString *createEvent_title;
@property (nonatomic,strong) NSString *createEvent_latitude;
@property (nonatomic,strong) NSString *createEvent_longitude;
@property (nonatomic,strong) NSString *createEvent_locationName;
@property (nonatomic,strong) NSString *createEvent_time;
@property (nonatomic,strong) NSString *createEvent_address;
@property (nonatomic,strong) NSString *createEvent_imageUrlName;

//the property used to chaneg the UI between edit and create
@property (nonatomic) BOOL isEditPage;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *done_Button;

//used to invite inner friend(following)
@property (nonatomic,strong) NSMutableDictionary *invitedFriend;
@property (nonatomic,strong) NSMutableDictionary *invitedAddressBookFriend;
@property (nonatomic,strong) NSArray* invitedFriendLastReceivedJson;

//used to set the 1st into set teh title part 1st responser
@property (nonatomic) BOOL isnotFirstTime;
@property (nonatomic) BOOL isNeedChoosePhoto;

//used for server log
@property (nonatomic) int via;

//used to filter out unecessary words
@property (nonatomic,strong) NSArray* filterDict;

@property (nonatomic,strong) NSString* isNeedToUseOtherSource;
@end

//////////////////////////////////////

@implementation NewEventVC
@synthesize deleteButton = _deleteButton;
@synthesize done_Button = _done_Button;
@synthesize showNewButtonFlag=_showNewButtonFlag;
@synthesize personProfileImage = _personProfileImage;
@synthesize imgPicker=_imgPicker;
@synthesize uIImageViewEvent = _uIImageViewEvent;
@synthesize keyboardToolbar = _keyboardToolbar;
@synthesize buttonChooseEventPhoto = _buttonChooseEventPhoto;
@synthesize buttonChooseEventLocation = _buttonChooseEventLocation;
@synthesize buttonEventTime = _buttonEventTime;
@synthesize buttonEditEventTitle = _buttonEditEventTitle;
@synthesize labelEventTime = _labelEventTime;
@synthesize locationLabel = _locationLabel;
@synthesize locationIcon = _locationIcon;
@synthesize timeIcon = _timeIcon;
@synthesize inviteIcon = _inviteIcon;
@synthesize textFieldEventTitle = _textFieldEventTitle;
@synthesize labelEventTitleHolder = _labelEventTitleHolder;
@synthesize inviteFriendsLabel = _inviteFriendsLabel;
@synthesize eventType=_eventType;
@synthesize predefinedAnnotation=_predefinedAnnotation;
@synthesize eventLocationName=_eventLocationName;

//from detail View controller
@synthesize detail_event_id=_detail_event_id;
@synthesize detail_shared_event_id=_detail_shared_event_id;
@synthesize detail_event_title=_detail_event_title;
@synthesize detail_event_time=_detail_event_time;
@synthesize detail_location_name=_detail_location_name;
@synthesize detail_address=_detail_address;
@synthesize detail_longitude=_detail_longitude;
@synthesize detail_latitude=_detail_latitude;
@synthesize detail_description=_detail_description;
@synthesize detail_image=_detail_image;
@synthesize detail_creator_id=_detail_creator_id;
@synthesize already_load_detail_event_id=_already_load_detail_event_id;


@synthesize createEvent_image=_createEvent_image;
@synthesize isCreateEvent_imageUsable=_isCreateEvent_imageUsable;

@synthesize createEvent_title=_createEvent_title;
@synthesize createEvent_latitude=_createEvent_latitude;
@synthesize createEvent_longitude=_createEvent_longitude;
@synthesize createEvent_locationName=_createEvent_locationName;
@synthesize createEvent_time=_createEvent_time;
@synthesize createEvent_address=_createEvent_address;
@synthesize createEvent_imageUrlName=_createEvent_imageUrlName;
@synthesize mapViewFeedBackImageView=_mapViewFeedBackImageView;

//the property used to chaneg the UI between edit and create
@synthesize isEditPage=_isEditPage;

//used to invite inner friend(following)
@synthesize invitedFriend=_invitedFriend;
@synthesize invitedAddressBookFriend=_invitedAddressBookFriend;
@synthesize invitedFriendLastReceivedJson=_invitedFriendLastReceivedJson;

//used to set the 1st into set the title part 1st responser
@synthesize isnotFirstTime=_isnotFirstTime;
@synthesize isNeedChoosePhoto=_isNeedChoosePhoto;

//used for server log
@synthesize via=_via;

//used to filter out unecessary words
@synthesize filterDict=_filterDict;

@synthesize isNeedToUseOtherSource=_isNeedToUseOtherSource;

#pragma mark - self defined synthesize
//used to filter out unecessary words
-(NSArray *)filterDict{
    if (!_filterDict) {
        //if it is empty, initialize it
        _filterDict=[NSArray arrayWithObjects:@"I ",@"i ",@"I'm",@" am ",@" going ",@" wanna ",@" want ",@" wants ",@" to ",@" feel ",@" feels ",@" like ",@" would ",@" a ",@" an ",@" grab ",@"Grab ",@" eat ",@"Eat ",@" some ",@" play ",@" get ",@" do ",@" attend ",@" listen ",@" watch ",@" visit ",@" ride ",@" drive ",@"\n",@"?",@",",@"!",@".",nil];
    }
    return _filterDict;
}

//used to invite inner friend(following)
-(NSMutableDictionary *)invitedFriend{
    if (!_invitedFriend) {
        _invitedFriend=[NSMutableDictionary dictionary];
    }
    return _invitedFriend;
}

-(NSMutableDictionary *)invitedAddressBookFriend{
    if (!_invitedAddressBookFriend) {
        _invitedAddressBookFriend=[NSMutableDictionary dictionary];
    }
    return _invitedAddressBookFriend;
}

-(NSArray *)invitedFriendLastReceivedJson{
    if (!_invitedFriendLastReceivedJson) {
        _invitedFriendLastReceivedJson=[NSArray array];
    }
    return _invitedFriendLastReceivedJson;
}

//if user have choosed a new image, then createEvent_image return the image on screen
-(UIImage *)createEvent_image{
    if (_isCreateEvent_imageUsable) {
        _createEvent_image=self.uIImageViewEvent.image;
    }
    else{
        _createEvent_image=nil;
    }
    return _createEvent_image;
}

-(NSString *)createEvent_time{
    _createEvent_time=[self.labelEventTime text];
    return _createEvent_time;
}

-(NSString *)createEvent_title{
    _createEvent_title=self.textFieldEventTitle.text;
    if([_createEvent_title isEqualToString:@""]){
        _createEvent_title=@"some thing";
    }
    return _createEvent_title;
}

//init the image Picker Controller
-(UIImagePickerController *)imgPicker{
    if (_imgPicker==nil) {
        _imgPicker = [[UIImagePickerController alloc] init];
        _imgPicker.allowsEditing = YES;
        [_imgPicker setDelegate:self];
    }
    return _imgPicker;
}

-(void)setImgPicker:(UIImagePickerController *)imgPicker{
    if (![_imgPicker isEqual:imgPicker]) {
        _imgPicker=imgPicker;
    }
}



#pragma mark - self defined
//used for server log
-(void)presetVia:(int)via{
    self.via=via;
    //self.isnotFirstTime=NO;
}

//make the Page for Edit before segue here
-(void)presetIsEditPageToTrue{
    self.isEditPage=YES;
    self.isCreateEvent_imageUsable=NO;//preset the image indicator to false
}
//make the Page for Create before segue here
-(void)presetIsEditPageToFalse{
    self.isEditPage=NO;
    self.isCreateEvent_imageUsable=NO;//preset the image indicator
}

-(void)preSetAlreadyInvitedFriend:(NSArray*)friends{
    for (InviteFriendObject* friend in friends) {
        NSString * key=friend.user_name;
        [self.invitedFriend setObject:(id)friend forKey:key];
    }
}

-(void)preSetAlreadyInvitedAddressBookFriend:(NSArray*)friends{
    for (NSDictionary* friend in friends) {
        
        UserContactObject* contact=[[UserContactObject alloc] init];
        contact.firstName=[friend objectForKey:@"user_name"];
        contact.email=[NSArray arrayWithObject:[friend objectForKey:@"user_email"]];
        [self.invitedAddressBookFriend setObject:contact forKey:[friend objectForKey:@"user_name"]];
    }
}

//filter out the uncessary word for later search use
-(NSString*)searchingWordsFilter:(NSString*) words{
    //filter out the words in the dictionary
    for (NSString *word in self.filterDict) {
        words=[words stringByReplacingOccurrencesOfString:word withString:@" "];
    }
    //eliminate the successive blank
    while (![words isEqualToString:[words stringByReplacingOccurrencesOfString:@"  " withString:@" "]]) {
        words=[words stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    return words;
}

//get the repin infomation before segue here
-(void)repinTheEventWithEventID:(NSString *)event_id sharedEventID:(NSString *)shared_event_id creatorID:(NSString*)creator_id eventTitle:(NSString *)event_title eventTime:(NSString *)event_time eventImage:(UIImage *)event_image locationName:(NSString *)location_name address:(NSString*)address longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude description:(NSString *)description{
    self.detail_event_id=event_id;
    self.detail_shared_event_id=shared_event_id;
    self.detail_event_title=event_title;
    self.detail_event_time=event_time;
    self.detail_location_name=location_name;
    self.detail_creator_id=creator_id;
    //NSLog(@"%@",location_name);
    self.detail_longitude=longitude;
    //NSLog(@"%@",longitude);
    self.detail_latitude=latitude;
    //NSLog(@"%@",latitude);
    self.detail_description=description;
    self.detail_image=[event_image copy];
    self.detail_address=address;
    
    if (![[NSString stringWithFormat:@"%@",longitude] isEqualToString:@"<null>"] && ![[NSString stringWithFormat:@"%@",latitude] isEqualToString:@"<null>"]) {
        MKPointAnnotation *annotation=[[MKPointAnnotation alloc] init];
        [annotation setCoordinate:CLLocationCoordinate2DMake([latitude floatValue], [longitude floatValue])];
        [annotation setTitle:location_name];
        self.predefinedAnnotation = annotation;
    }
}


#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //change the navigationController title
//    if ([self.eventType isEqualToString:@"movie"]) {
//        self.navigationController.navigationBar.topItem.title = @"Movie";
//    }
//    else if ([self.eventType isEqualToString:@"party"]) {
//        self.navigationController.navigationBar.topItem.title = @"Party";
//    }
//    else if ([self.eventType isEqualToString:@"shopping"]) {
//        self.navigationController.navigationBar.topItem.title = @"Shopping";
//    }
//    else if ([self.eventType isEqualToString:@"sports"]) {
//        self.navigationController.navigationBar.topItem.title = @"Sports";
//    }
//    else if ([self.eventType isEqualToString:@"outdoor"]) {
//        self.navigationController.navigationBar.topItem.title = @"Outdoor";
//    }
//    else if ([self.eventType isEqualToString:@"entertain"]) {
//        self.navigationController.navigationBar.topItem.title = @"Entertainment";
//    }
//    else if ([self.eventType isEqualToString:@"event"]) {
//        self.navigationController.navigationBar.topItem.title = @"Event";
//    }
//    else if ([self.eventType isEqualToString:@"food"]) {            
//        self.navigationController.navigationBar.topItem.title = @"Food";
//    }
//    else {
//        self.navigationController.navigationBar.topItem.title = @"Other";
//    }

    //chaneg the Ui for the edit/create event baseon on where user can edit this page
    if (self.isEditPage) {
        [self.deleteButton setHidden:NO];
    }
    else{
        [self.deleteButton setHidden:YES];
    }
        
    //get the photo of the user
    //initial the face book
    FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    if (!delegate.facebook) {
        delegate.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:(id)delegate];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        delegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        NSLog(@"%@",delegate.facebook.accessToken);
        delegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"id,picture" forKey:@"fields"];
    if ([delegate.facebook isSessionValid]) {
        [delegate.facebook requestWithGraphPath:@"me"
                                      andParams:params
                                  andHttpMethod:@"GET"
                                    andDelegate:self];
    }
    else {
        NSLog(@"Face book session invalid~~~");
    }
    //if this view is used to repin a event
    if(self.detail_event_id&&(self.detail_event_id!=self.already_load_detail_event_id)){
        self.already_load_detail_event_id=self.detail_event_id;
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
        //this is for the repin of a featured event
        [self.textFieldEventTitle setText:self.detail_event_title];
        
        [self.labelEventTime setText:self.detail_event_time];
        [self.labelEventTime setFont:[UIFont boldSystemFontOfSize:14]];
        [self.labelEventTime setTextColor:[UIColor darkGrayColor]];
        [self.timeIcon setAlpha:0.8];
        [self.labelEventTitleHolder setHidden:YES];
        
        [self.locationLabel setText:self.detail_location_name];
        [self.locationLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.locationLabel setTextColor:[UIColor darkGrayColor]];
        [self.locationIcon setAlpha:0.8];
        
        [self.uIImageViewEvent setImage:self.detail_image];
        [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
        [self.uIImageViewEvent clipsToBounds];
    }
    
    //used to add the additional keyboard done toobar 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    self.done_Button.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    //update the display label
    if ([self.invitedFriend count]==0) {
        [self.inviteFriendsLabel setText:@"Invite friends"];
        [self.inviteFriendsLabel setFont:[UIFont italicSystemFontOfSize:16]];
        [self.inviteFriendsLabel setTextColor:[UIColor lightGrayColor]];
        [self.inviteIcon setAlpha:0.4];
    }
    else if ([self.invitedFriend count]==1){
        [self.inviteFriendsLabel setText:@"1 friend"];
        [self.inviteFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.inviteFriendsLabel setTextColor:[UIColor darkGrayColor]];
        [self.inviteIcon setAlpha:0.8];
    }
    else{
        [self.inviteFriendsLabel setText:[NSString stringWithFormat:@"%d friends",[self.invitedFriend count]]];
        [self.inviteFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.inviteFriendsLabel setTextColor:[UIColor darkGrayColor]];
        [self.inviteIcon setAlpha:0.8];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //set different flow for different event type
    
    if (!self.isnotFirstTime&&[self.eventType isEqualToString:@"food"]&&!self.isEditPage){
        self.isnotFirstTime=YES;
        [self performSegueWithIdentifier:@"ChooseLocationInMAP" sender:self];
    }
    else if (!self.isnotFirstTime&&[self.eventType isEqualToString:@"movie"]&&!self.isEditPage){
        self.isnotFirstTime=YES;
        [self performSegueWithIdentifier:@"moviewAutoCompletion" sender:self];
    }
    else if (!self.isnotFirstTime&&(![self.eventType isEqualToString:@"movie"])&&!self.isEditPage) {
        self.isnotFirstTime=YES;
        if (self.via == CREATE_EVENT) {
            [self.textFieldEventTitle becomeFirstResponder];
        }
    }
    
    
    //enter the food choose image session
    if ([self.eventType isEqualToString:@"food"]&&self.isNeedChoosePhoto) {
        self.isNeedChoosePhoto=NO;
        [self performSegueWithIdentifier:@"ChooseImageUsingGoogleImage" sender:self];
    }
    
    if (self.via == CREATE_EVENT) {
        [self.navigationController.navigationBar.topItem setTitle:@"Create new event"];
    }
    else{
        [self.navigationController.navigationBar.topItem setTitle:@"Do it myself"];
    }
    
    if (self.isNeedToUseOtherSource) {
        if ([self.isNeedToUseOtherSource isEqualToString:@"need"]) {
                //UIActionSheet *pop =[[UIActionSheet alloc] initWithTitle:@"Choose photo source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Recommended Photos",@"Take Photo",@"Choose from album",nil];
                UIActionSheet *pop =[[UIActionSheet alloc] initWithTitle:@"Choose photo source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from album",nil];
                pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
                [pop showFromTabBar:self.tabBarController.tabBar];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //reset the keyboard addititonal "done" tool bar
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];

    //change the style of the navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    self.done_Button.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    
    
    
    /*
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
     */

}

- (void)viewDidUnload{
    [self setButtonEventTime:nil];
    [self setButtonChooseEventPhoto:nil];
    [self setButtonChooseEventLocation:nil];
    [self setTextFieldEventTitle:nil];
    [self setUIImageViewEvent:nil];
    [self setLabelEventTime:nil];
    [self setLabelEventTitleHolder:nil];
    [self setPersonProfileImage:nil];
        
    [self setMapViewFeedBackImageView:nil];
    [self setButtonEditEventTitle:nil];
    [self setKeyboardToolbar:nil];
    [self setLocationLabel:nil];
    [self setLocationIcon:nil];
    [self setTimeIcon:nil];
    [self setDeleteButton:nil];
    [self setDone_Button:nil];
    [self setInviteFriendsLabel:nil];
    [self setInviteIcon:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - create/delete/edite event to server
-(void)startInviteFriendWithEventID:(NSString*)event_id withSharedEventID:(NSString*)shared_event_id{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/invite?event_id=%@&shared_event_id=%@&auth_token=%@",CONNECT_DOMIAN_NAME,event_id,shared_event_id,[defaults objectForKey:@"login_auth_token"]]];
    NSLog(@"request:%@",url);
    
    //organize registered users
    NSString *user_ids=@"";
    for (NSString* key in [self.invitedFriend allKeys]) {
        InviteFriendObject* person =[self.invitedFriend objectForKey:key];
        if ([user_ids isEqualToString:@""]) {
            user_ids=[user_ids stringByAppendingFormat:@"%@",person.user_id];
        } else {
            user_ids=[user_ids stringByAppendingFormat:@",%@",person.user_id];
        }
    }
    
    //organize addressbook users
    NSString *emails=@"";
    for (NSString* key in [self.invitedAddressBookFriend allKeys]) {
        UserContactObject* person=[self.invitedAddressBookFriend objectForKey:key];
        NSString* name=[key stringByReplacingOccurrencesOfString:@"," withString:@""];
        if ([emails isEqualToString:@""]) {
            emails=[emails stringByAppendingFormat:@"%@ <%@>",name,[person.email objectAtIndex:0]];
        } else {
            emails=[emails stringByAppendingFormat:@", %@ <%@>",name,[person.email objectAtIndex:0]];
        }
    }
    NSLog(@"%@",emails);
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:user_ids forKey:@"user_ids"];
        [request setPostValue:emails forKey:@"emails"];
        [request setRequestMethod:@"POST"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    notsuccess.delegate=self;
                    [notsuccess show];
                }
            }
            
        });
        
    });
    
    //go to my parc
    [self.navigationController popToRootViewControllerAnimated:YES];
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    [funAppdelegate.thisTabBarController setSelectedIndex:3];
}

- (IBAction)deleteEventButton:(id)sender {
    //after delete, need to return to myparc
    //create event
#warning Check this
    //Adding Create Event
//    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:nil message:@"Are you sure to delete this event?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/delete?event_id=%@&shared_event_id=%@&auth_token=%@",CONNECT_DOMIAN_NAME,self.detail_event_id,self.detail_shared_event_id,[defaults objectForKey:@"login_auth_token"]]];
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"POST"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    notsuccess.delegate=self;
                    [notsuccess show];
                }
            }
        });
        
    });
    
    
    
    //go to my parc
    [self.navigationController popToRootViewControllerAnimated:YES];
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    [funAppdelegate.thisTabBarController setSelectedIndex:3];
}


- (IBAction)CreateEventToSever:(id)sender {
    //if the user haven't type in any title, pop out a alert
    if ([self.textFieldEventTitle.text isEqualToString:@""]) {
        UIAlertView *noTitleInput = [[UIAlertView alloc] initWithTitle:@"Empty Title" message:@"What's in your mind?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [noTitleInput show];
        return;
    }
    
    //for user edit his own event
    if (self.isEditPage) {
    //edit event
        //Adding Create Event
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/edit",CONNECT_DOMIAN_NAME]];
        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            //add login auth_token
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setPostValue:self.createEvent_title forKey:@"title"];
            //NSLog(@"%@",self.createEvent_address);
            [request setPostValue:self.createEvent_address forKey:@"address"];
            //NSLog(@"%@",self.createEvent_locationName);
            [request setPostValue:self.createEvent_locationName forKey:@"location"];
            [request setPostValue:self.createEvent_longitude forKey:@"longitude"];
            [request setPostValue:self.createEvent_latitude forKey:@"latitude"];
            [request setPostValue:self.createEvent_time forKey:@"start_time"];
            NSLog(@"%@",self.createEvent_time);

            //used for server log
            [request setPostValue:[NSString stringWithFormat:@"%d",self.via] forKey:@"via"];
            
            //if it is for user repin
            if (self.detail_creator_id) {
                if (![self.createEvent_image isEqual:self.detail_image]) {
                    //add content
                    if (self.createEvent_imageUrlName) {
                        //if has image url, then no need to upload the image
                        [request setPostValue:self.createEvent_imageUrlName forKey:@"image_url"];
                    }
                    else if(self.isCreateEvent_imageUsable){
                        NSString *format=@"png";
                        NSData *data=nil;
                        data=UIImagePNGRepresentation(self.createEvent_image);
                        //data=UIImageJPEGRepresentation(self.createEvent_image, 1);
                        if(data==nil){
                            //data=UIImagePNGRepresentation(self.createEvent_image);
                            data=UIImageJPEGRepresentation(self.createEvent_image, 1);
                            format=@"jpeg";
                        }
                        if (data) {
                            [request setData:data withFileName:[NSString stringWithFormat:@"temp_name.%@",format] andContentType:[NSString stringWithFormat:@"image/%@",format] forKey:@"image"];
                        }
                    }
                }
                [request setPostValue:self.detail_event_id forKey:@"event_id"];
                [request setPostValue:self.detail_shared_event_id forKey:@"shared_event_id"];
                if ([self.detail_latitude floatValue]>0.02||[self.detail_latitude floatValue]<-0.02) {
                    [request setPostValue:self.detail_latitude forKey:@"latitude"];
                }
                if ([self.detail_longitude floatValue]>0.02||[self.detail_longitude floatValue]<-0.02) {
                    [request setPostValue:self.detail_longitude forKey:@"longitude"];
                }
                [request setPostValue:self.detail_address forKey:@"address"];
                [request setPostValue:self.detail_location_name forKey:@"location"];
            }
            
            [request setRequestMethod:@"POST"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload Error" message: [NSString stringWithFormat:@"%@",[json objectForKey:@"message"] ] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        notsuccess.delegate=self;
                        [notsuccess show];
                    }
                    else{
                        //when success, start invite people;
                        if ([self.invitedFriend count]>0) {
                            [self startInviteFriendWithEventID:self.detail_event_id withSharedEventID:self.detail_shared_event_id];
                        }
                    }
                }
                
            });
            
        });
        
        
        
        
        
        //go to the next page
        //[self performSegueWithIdentifier:@"FinshCreateGoToSharePart" sender:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
        FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
        [funAppdelegate.thisTabBarController setSelectedIndex:0];
    }
    //for user create/repin a event
    else {
    //create event
        //Adding Create Event
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/add",CONNECT_DOMIAN_NAME]];
        if (self.detail_event_id) {
            url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/pin",CONNECT_DOMIAN_NAME]];
        }

        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            //add login auth_token
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setPostValue:self.createEvent_title forKey:@"title"];
            NSLog(@"%@",self.createEvent_address);
            [request setPostValue:self.createEvent_address forKey:@"address"];
            NSLog(@"%@",self.createEvent_locationName);
            [request setPostValue:self.createEvent_locationName forKey:@"location"];
            //used for server log
            [request setPostValue:[NSString stringWithFormat:@"%d",self.via] forKey:@"via"];
            if ([self.createEvent_latitude floatValue]>0.02||[self.createEvent_latitude floatValue]<-0.02) {
                [request setPostValue:self.detail_latitude forKey:@"latitude"];
            }
            if ([self.createEvent_longitude floatValue]>0.02||[self.createEvent_longitude floatValue]<-0.02) {
                [request setPostValue:self.createEvent_longitude forKey:@"longitude"];
            }
            
            [request setPostValue:self.createEvent_time forKey:@"start_time"];
            if (self.detail_creator_id) {
                //if it is from repin
                if (![self.createEvent_image isEqual:self.detail_image]) {
                    //add content
                    if (self.createEvent_imageUrlName) {
                        //if has image url, then no need to upload the image
                        [request setPostValue:self.createEvent_imageUrlName forKey:@"image_url"];
                    }
                    else if(self.isCreateEvent_imageUsable){
                        NSString *format=@"png";
                        NSData *data=nil;
                        data=UIImagePNGRepresentation(self.createEvent_image);
                        //data=UIImageJPEGRepresentation(self.createEvent_image, 1);
                        if(data==nil){
                            //data=UIImagePNGRepresentation(self.createEvent_image);
                            data=UIImageJPEGRepresentation(self.createEvent_image, 1);
                            format=@"jpeg";
                        }
                        [request setData:data withFileName:[NSString stringWithFormat:@"temp_name.%@",format] andContentType:[NSString stringWithFormat:@"image/%@",format] forKey:@"image"];
                    }
                }
                [request setPostValue:self.detail_creator_id forKey:@"creator_id"];
                [request setPostValue:self.detail_event_id forKey:@"event_id"];
                [request setPostValue:self.detail_shared_event_id forKey:@"shared_event_id"];
                
                if ([self.detail_latitude floatValue]>0.02||[self.detail_latitude floatValue]<-0.02) {
                    [request setPostValue:self.detail_latitude forKey:@"latitude"];
                }
                if ([self.detail_longitude floatValue]>0.02||[self.detail_longitude floatValue]<-0.02) {
                    [request setPostValue:self.detail_longitude forKey:@"longitude"];
                }
                [request setPostValue:self.detail_address forKey:@"address"];
                [request setPostValue:self.detail_location_name forKey:@"location"];
            }
            else {
                if (self.createEvent_imageUrlName) {
                    //if has image url, then no need to upload the image
                    [request setPostValue:self.createEvent_imageUrlName forKey:@"image_url"];
                }
                else if(self.isCreateEvent_imageUsable){
                    //add content
                    NSString *format=@"png";
                    NSData *data=nil;
                    if (self.createEvent_image) {
                        NSLog(@"198 called!");
                    }
                    else{
                        NSLog(@"%@",self.createEvent_image);
                    }
                    data=UIImagePNGRepresentation(self.createEvent_image);
                    //data=UIImageJPEGRepresentation(self.createEvent_image, 1);
                    if(data==nil){
                        //data=UIImagePNGRepresentation(self.createEvent_image);
                        data=UIImageJPEGRepresentation(self.createEvent_image, 1);
                        format=@"jpeg";
                    }
                    if (data!=nil) {
                        [request setData:data withFileName:[NSString stringWithFormat:@"temp_name.%@",format] andContentType:[NSString stringWithFormat:@"image/%@",format] forKey:@"image"];
                    }
                }
//                else{
//                    //the user haven't choosen a picture
//                    UIAlertView *notChosenAPic = [[UIAlertView alloc] initWithTitle:@"No Picture Choosen" message:@"Please choose a picture first." delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    notChosenAPic.delegate=self;
//                    [notChosenAPic show];
//                    return;
//                }
            }
            //decide the category_id and send to server
            if (!self.detail_creator_id){
                NSString *category_id=self.eventType;
                if ([category_id isEqualToString:@"movie"]) {
                    [request setPostValue:MOVIE forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"party"]) {
                    [request setPostValue:NIGHTLIFE forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"shopping"]) {
                    [request setPostValue:SHOPPING forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"sports"]) {
                    [request setPostValue:SPORTS forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"outdoor"]) {
                    [request setPostValue:OUTDOOR forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"entertain"]) {
                    [request setPostValue:ENTERTAIN forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"event"]) {
                    [request setPostValue:EVENTS forKey:@"category_id"];
                }
                else if ([category_id isEqualToString:@"food"]) {            
                    [request setPostValue:FOOD forKey:@"category_id"];
                }
                else {
                    [request setPostValue:OTHERS forKey:@"category_id"];
                }
                
                
            }
            [request setRequestMethod:@"POST"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    // Use when fetching text data
                    NSString *responseString = [request responseString];
                    NSLog(@"%@",responseString);
                    
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload Error" message: [NSString stringWithFormat:@"%@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        notsuccess.delegate=self;
                        [notsuccess show];
                    }
                    else{
                        //when success, start invite people;
                        if ([self.invitedFriend count]>0) {
                            [self startInviteFriendWithEventID:[json objectForKey:@"event_id"] withSharedEventID:[json objectForKey:@"shared_event_id"]];
                        }
                    }
                }
                
            });
            
        });
        
        
        
        
        
        
        
        //go to the next page
        //[self performSegueWithIdentifier:@"FinshCreateGoToSharePart" sender:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
        FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
        [funAppdelegate.thisTabBarController setSelectedIndex:3];
    }
}


#pragma mark - View AntoRotation Method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Segues related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if ([segue.identifier isEqualToString:@"chooseTime"] &&[segue.destinationViewController isKindOfClass:[TimeChooseViewController class]]){
        TimeChooseViewController *TimeChooseVC=segue.destinationViewController;
        [TimeChooseVC setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"ChooseLocationInMAP"]){
        
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *mapViewC=segue.destinationViewController;
            [mapViewC setDelegate:self];
            //pass in the event type to the destination(8 types)
            [mapViewC setPreDefinedEventType:[NSString stringWithFormat:@"%@",self.eventType]];
            if (![self.textFieldEventTitle.text isEqualToString:@""]) {
                [mapViewC setPredefinedSeachingWords:self.eventType];
            }
            else {
                [mapViewC setPredefinedSeachingWords:@""];
            }
            
            if (self.predefinedAnnotation) {
                mapViewC.predefinedAnnotation=[[MKPointAnnotation alloc] init];
                [mapViewC.predefinedAnnotation setCoordinate:self.predefinedAnnotation.coordinate];
                [mapViewC.predefinedAnnotation setTitle:self.predefinedAnnotation.title];
                NSLog(@"%@",self.predefinedAnnotation.title);
                [mapViewC.predefinedAnnotation setTitle:self.predefinedAnnotation.subtitle];
                NSLog(@"%@",self.predefinedAnnotation.subtitle);
            }

        }
         
    }
    else if ([segue.identifier isEqualToString:@"ChooseImageUsingGoogleImage"]){
        if ([segue.destinationViewController isKindOfClass:[ChooseImageTableViewController class]]) {
            if (![self.textFieldEventTitle.text isEqualToString:@""]) {
                NSLog(@"original:%@",self.textFieldEventTitle.text);
                NSLog(@"after:%@",[self searchingWordsFilter:self.textFieldEventTitle.text]);
                [segue.destinationViewController setPredefinedKeyWord:[self searchingWordsFilter:self.textFieldEventTitle.text]];
            }
            [segue.destinationViewController setDelegate:self];
        }
    }
    else if([segue.identifier isEqualToString:@"moviewAutoCompletion"]){
        [segue.destinationViewController setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"FinshCreateGoToSharePart"]){
        ShareAfterNewEventViewController* nextVC=segue.destinationViewController;
        [nextVC presetEventImage:self.createEvent_image WithTiTle:self.createEvent_title WithLatitude:self.createEvent_latitude WithLongitude:self.createEvent_longitude WithLocationName:self.createEvent_locationName WithTime:self.createEvent_time WithAddress:self.createEvent_locationName WithImageUrlName:self.createEvent_imageUrlName];
    }
    else if([segue.identifier isEqualToString:@"StartInviteFriend"]){
        InviteTableViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        peopleController.alreadySelectedContacts=[self.invitedFriend copy];
        peopleController.addressbook_alreadySelectedContacts=[self.invitedAddressBookFriend copy];
        peopleController.lastReceivedJson=self.invitedFriendLastReceivedJson;
    }
    NSLog(@"%@",segue.identifier);
}

#pragma mark - action sheet
- (IBAction)InviteFriendButtonClicked:(id)sender {
    if ([self.invitedFriend count]==0) {
        [self performSegueWithIdentifier:@"StartInviteFriend" sender:self];
    } else {
        UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Invite Friends" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Remove Friends",@"Add Friends",nil];
        pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [pop showFromTabBar:self.tabBarController.tabBar];
    }
}



//pop the action sheet of the time selection
- (IBAction)SelectTime:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"When do you want to schedule?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Today",@"Tomorrow",@"This Saturday",@"This Sunday",@"Pick a time",@"Any Time", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}



//pop the action sheet of the choose the event title
- (IBAction)ChooseEventTitle:(UIButton *)sender {
    //if it is movie category, need to segue to another view controller
    if([self.eventType isEqualToString:@"movie"]){
        [self performSegueWithIdentifier:@"moviewAutoCompletion" sender:self];
    }
    else {
        [self.buttonEditEventTitle setHidden:YES];
        [self.textFieldEventTitle becomeFirstResponder];
        [self.labelEventTitleHolder setHidden:YES];
    }
}


- (IBAction)ChoosePhoto:(UIButton *)sender {
//    UIActionSheet *pop =[[UIActionSheet alloc] initWithTitle:@"Choose photo source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Recommended Photos",@"Take Photo",@"Choose from album",nil];
//    pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
//    [pop showFromTabBar:self.tabBarController.tabBar];
    [self performSegueWithIdentifier:@"ChooseImageUsingGoogleImage" sender:self];
}

//deal with the popout action sheet
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //for the when to go action sheet
    NSLog(@"%@",actionSheet.title);
    
    if([actionSheet.title isEqualToString:@"When do you want to schedule?"]){
        if(buttonIndex == 0){
            // Get current datetime
            NSDate *currentDateTime = [NSDate date];
            // Instantiate a NSDateFormatter
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // Set the dateFormatter format
            //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
            [self.labelEventTime setText:dateInString];
        }else if(buttonIndex == 1){
            // Get current datetime
            NSDateComponents *comp = [[NSDateComponents alloc] init];
            [comp setDay:1];   // add some days so it will become sunday
            
            NSCalendar *calender=[NSCalendar currentCalendar];
            NSDate *date=[calender dateByAddingComponents:comp toDate:[NSDate date] options:0];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:date];
            [self.labelEventTime setText:dateInString];

        }else if(buttonIndex == 2){
            //next saturday
            NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
            int currentWeekday = [weekdayComponents weekday]; //[1;7] ... 1 is sunday, 7 is saturday in gregorian calendar
            
            NSDateComponents *comp = [[NSDateComponents alloc] init];
            if (7-currentWeekday<0) {
                [comp setDay:7 - currentWeekday+7];
            }
            [comp setDay:7 - currentWeekday];   // add some days so it will become sunday
            
            [comp setWeek:0];   // add weeks
            NSDate *date=[[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:[NSDate date] options:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:date];
            [self.labelEventTime setText:dateInString];
        }else if(buttonIndex == 3){
            //next saturday
            NSDateComponents *weekdayComponents = [[NSCalendar currentCalendar] components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
            int currentWeekday = [weekdayComponents weekday]; //[1;7] ... 1 is sunday, 7 is saturday in gregorian calendar
            
            NSDateComponents *comp = [[NSDateComponents alloc] init];
            if (8-currentWeekday<0) {
                [comp setDay:8 - currentWeekday+7];
            }
            [comp setDay:8 - currentWeekday];   // add some days so it will become sunday
            
            [comp setWeek:0];   // add weeks
            NSDate *date=[[NSCalendar currentCalendar] dateByAddingComponents:comp toDate:[NSDate date] options:0];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            // Get the date time in NSString
            NSString *dateInString = [dateFormatter stringFromDate:date];
            [self.labelEventTime setText:dateInString];
        }else if(buttonIndex == 4){
            [self performSegueWithIdentifier:@"chooseTime" sender:self];
            //self enter the time
        }else if(buttonIndex == 5){
            //self enter the time
            [self.labelEventTime setText:@"Anytime"];
        }
        if (buttonIndex != 6) {
            if (![self.labelEventTime.text isEqualToString:@"Find a time"]) {
                [self.labelEventTime setFont:[UIFont boldSystemFontOfSize:14]];
                [self.labelEventTime setTextColor:[UIColor darkGrayColor]];
                [self.timeIcon setAlpha:0.8];
            }
        } else {
            if (!self.detail_event_id&&![self.labelEventTime.text isEqualToString:@"Find a time"]) {
                [self.labelEventTime setText:@"Find a time"];
                [self.labelEventTime setFont:[UIFont italicSystemFontOfSize:16]];
                [self.labelEventTime setTextColor:[UIColor lightGrayColor]];
                [self.timeIcon setAlpha:0.4];
            }
        }
    }    
    //for the event photo choose action sheet
    else if([actionSheet.title isEqualToString:@"Choose photo source"]){
        if (buttonIndex == 0) {
            //do sth. about take photo part
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:self.imgPicker animated:YES];
            }
            else {
                UIAlertView *cameraNotSupport = [[UIAlertView alloc] initWithTitle:nil message:@"Your device does not support camera." delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                cameraNotSupport.delegate=self;
                [cameraNotSupport show];
            }
        }
        else if(buttonIndex == 1){
            //do sth. about choose photo from the album
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                self.imgPicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentModalViewController:self.imgPicker animated:YES];
            }
            else {
                UIAlertView *cameraNotSupport = [[UIAlertView alloc] initWithTitle:nil message:@"Your device does not support photo album." delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                cameraNotSupport.delegate=self;
                [cameraNotSupport show];
            }
        }
        /*
        else if(buttonIndex == 0){
            //using google image seach(implement by segue)
            [self performSegueWithIdentifier:@"ChooseImageUsingGoogleImage" sender:self];
        }
         */
    }
    else if([actionSheet.title isEqualToString:@"Invite Friends"]){
        if(buttonIndex == 0){
            //remove friend
            //[self.invitedFriend removeAllObjects];
            for (NSString* key in [self.invitedFriend allKeys]) {
                InviteFriendObject* friend=[self.invitedFriend objectForKey:key];
                if (!friend.alreadyInvited) {
                    [self.invitedFriend removeObjectForKey:key];
                }
            }
            
            
            [self.inviteFriendsLabel setText:@"Invite Friends"];
            [self.inviteFriendsLabel setFont:[UIFont italicSystemFontOfSize:16]];
            [self.inviteFriendsLabel setTextColor:[UIColor lightGrayColor]];
            [self.inviteIcon setAlpha:0.4];
        }
        else if(buttonIndex ==1){
            //add friend
            [self performSegueWithIdentifier:@"StartInviteFriend" sender:self];
        }
    }
    
}


#pragma mark - facebook related protocal implement
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
        NSLog(@"%@",result);
        NSString *photo=[result objectForKey:@"picture"];
        //NSString *facebook_user_id=[result objectForKey:@"id"];
        //set the user photo
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
                    UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                    imageData=UIImagePNGRepresentation(image);
                    
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [self.personProfileImage setImage:image];
                        });
                    }
                }
                else {
                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                    //NSLog(@"downloaded %@",url);
                    if(imageData){
                        dispatch_async( dispatch_get_main_queue(),^{
                            [Cache addDataToCache:url withData:imageData];
                            [self.personProfileImage setImage:[UIImage imageWithData:imageData]];
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [self.personProfileImage setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
            });
        }
    self.personProfileImage.layer.cornerRadius = 6;
    self.personProfileImage.layer.masksToBounds = YES;
    self.personProfileImage.layer.shadowOpacity = 0.85f;
    self.personProfileImage.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.personProfileImage.layer.shadowRadius = 2.f;
    [self.personProfileImage.layer setShadowOffset:CGSizeMake(1, 1)];
}




#pragma mark - implement protocals
////////////////////////////////////////////////
//implement the movieInfoReturn protocal, for movie info return
-(void)movieInfoReturn:(rottenTomatoMovieModel *)model from:(id) sender{
    [self.textFieldEventTitle setText:model.title];
    [self.labelEventTitleHolder setHidden:YES];
    [self dismissModalViewControllerAnimated:YES];
    [self performSegueWithIdentifier:@"ChooseImageUsingGoogleImage" sender:self];
}

////////////////////////////////////////////////
//implement the MFMailComposeViewControllerDelegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        NSLog(@"NewEventVC: Sending Email Error Happened!");
    }
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////
//implement the UIImagePickerControllerDelegate Method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSLog(@"NewEventVC: image picker return");
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    [self dismissModalViewControllerAnimated:YES];
    //indicate that now the image is usable to share
    self.isCreateEvent_imageUsable=YES;
}

////////////////////////////////////////////////
//implement the chooseimageFeedBackDelegate method
-(void)ChooseUIImage:(UIImage *)image WithUrlName:(NSString*)URLName From:(ChooseImageTableViewController *)sender{
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    self.createEvent_imageUrlName= URLName;
    [self.navigationController popViewControllerAnimated:YES];
    //indicate that now the image is usable to share
    self.isCreateEvent_imageUsable=YES;
}

-(void)ChooseUIImage:(UIImage *)image WithUrlName:(NSString*)URLName{
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    self.createEvent_imageUrlName= URLName;
    //indicate that now the image is usable to share
    self.isCreateEvent_imageUsable=YES;
}

-(void)ChooseOtherSource{
    [self.navigationController popViewControllerAnimated:YES];
    self.isNeedToUseOtherSource=@"need";
}




////////////////////////////////////////////////
//implement the method for dealing with the textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.textFieldEventTitle]) {
        if ([textField.text length]==0) {
            UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Title Input Empty" message:@"Oops! You didn't input anything. Please try again." delegate:self  cancelButtonTitle:@"Input again" otherButtonTitles:@"Cancel",nil];
            inputEmptyError.delegate=self;
            [inputEmptyError show];
            return YES;
        }
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}

//the next 3 method deal with the keyboard covering with the text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*
    //if edit the add cost textfield, the whole view need to 
    //scroll up, get rid of the keyboard covering
    if ([textField isEqual:self.textFieldEventPrice]) {
        [self animateTextField: textField up: YES];
    }
     */
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
    //if finished editign the add cost textfield, the whole view need to scroll down
    if ([textField isEqual:self.textFieldEventPrice]) {
        [self animateTextField: textField up: NO];
    }
     */
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - textview protocal delegate method
-(void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length]>0) {
        [self.labelEventTitleHolder setHidden:YES];
    }
    else {
        [self.labelEventTitleHolder setHidden:NO];
    }
}


#pragma mark - keyboard additional help bar settings
- (IBAction)leaveEditMode:(UIBarButtonItem *)sender {
    NSString *enteredText=[self.textFieldEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    enteredText=[enteredText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([enteredText length]==0) {
        //[self.labelEventTitleHolder setHidden:NO];
    }
    [self.textFieldEventTitle resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    //[self.labelEventTitleHolder setHidden:YES];
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;
    [self.keyboardToolbar setHidden:FALSE];
    UIBarButtonItem *doneButtonKeyBoard = [self.keyboardToolbar.items objectAtIndex:0];
    doneButtonKeyBoard.target = self;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	
	CGRect frame = self.keyboardToolbar.frame;
	frame.origin.y = self.view.frame.size.height;
	self.keyboardToolbar.frame = frame;
	
	[UIView commitAnimations];
}

////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@",alertView.title);
    //deal with the Input Empty Error for the activity category choose
    if ([alertView.title isEqualToString:@"Title Input Empty"]) {
        //NSLog(@"%d",buttonIndex);
        if (buttonIndex == 0) {
            //Input Again
            [self.textFieldEventTitle becomeFirstResponder];
        }
        else if(buttonIndex == 1){
            //Cancel
            [self.textFieldEventTitle resignFirstResponder];
        }
    }
}


////////////////////////////////////////////////
//implement the method for dealing with the return of the choose location
-(void)UpdateLocation:(MKPointAnnotation *)fromannotation withLocationName:(NSString *)locationName withSnapShot:(UIImage *)image sendFrom:(MapViewController *)sender{
    MKPointAnnotation *annotation=fromannotation;
    self.predefinedAnnotation=annotation;
    
    //show event address name;
    NSString *locationDescription=[NSString stringWithFormat:@"%@",annotation.title];
    
    [self.locationLabel setText:locationDescription];
    [self.locationLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [self.locationLabel setTextColor:[UIColor darkGrayColor]];
    [self.locationIcon setAlpha:0.8];
    //show the map snapshot
    //[self.buttonChooseEventLocation setBackgroundImage:image forState:UIControlStateNormal];
    //add discription
    
    //[self.buttonLocation setTitle:locationDescription forState:UIControlStateNormal];
    //[self.locationLabel setText:[NSString stringWithFormat:@"lati:%f; long%f",annotation.coordinate.latitude,annotation.coordinate.longitude]];
    
    //[self.mapViewFeedBackImageView setImage:image];
    //[self.mapViewFeedBackImageView setContentMode:UIViewContentModeScaleAspectFill];
    //[self.mapViewFeedBackImageView setHidden:NO];
    self.createEvent_latitude=[NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
    self.detail_latitude=[[NSNumber alloc] initWithFloat:[self.createEvent_latitude floatValue]];
    self.createEvent_longitude=[NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
    self.detail_longitude=[[NSNumber alloc] initWithFloat:[self.createEvent_longitude floatValue]];
    self.createEvent_locationName=[locationName copy];
    self.detail_location_name=self.createEvent_locationName;
    NSLog(@"NewEvent Location return:%@",self.createEvent_locationName);
    if (annotation.subtitle) {
        self.createEvent_address=[NSString stringWithFormat:@"%@",annotation.subtitle];
        self.detail_address=self.createEvent_address;
        NSLog(@"%@",self.createEvent_address);
    }
    

    if ([self.eventType isEqualToString:@"food"]) {
        [self.textFieldEventTitle setText:locationName];
        [self.labelEventTitleHolder setHidden:YES];
        [self.textFieldEventTitle becomeFirstResponder];
        if (!self.self.isCreateEvent_imageUsable) {
            [self.navigationController popViewControllerAnimated:NO];
            self.isNeedChoosePhoto=YES;
            //[self performSegueWithIdentifier:@"ChooseImageUsingGoogleImage" sender:self];
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
            self.isNeedChoosePhoto=NO;
        }
    }
    else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

////////////////////////////////////////////////
//implement the method for Chooseing Time part (TimeChooseViewController)
- (void)ChangedTheNSDate:(NSDate *)date SendFrom:(UIButton *)sender{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit | NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:date];
    NSInteger day = [weekdayComponents day];
    NSString *day_string=nil;
    if (day<10){
        day_string=[NSString stringWithFormat:@"0%d",day];
    }
    else{
        day_string=[NSString stringWithFormat:@"%d",day];
    }
    //NSInteger weekday = [weekdayComponents weekday];
    NSInteger year= [weekdayComponents year];
    NSInteger month=[weekdayComponents month];
    NSString *month_string=nil;
    if (month<10){
        month_string=[NSString stringWithFormat:@"0%d",month];
    }
    else{
        month_string=[NSString stringWithFormat:@"%d",month];
    }
    NSInteger hour = [weekdayComponents hour];
    NSString *hour_string=nil;
    if (hour<10){
        hour_string=[NSString stringWithFormat:@"0%d",hour];
    }
    else{
        hour_string=[NSString stringWithFormat:@"%d",hour];
    }
    NSInteger minute = [weekdayComponents minute];
    NSString *minute_string=nil;
    if (minute<10){
        minute_string=[NSString stringWithFormat:@"0%d",minute];
    }
    else{
        minute_string=[NSString stringWithFormat:@"%d",minute];
    }
    NSString* showDateString= [NSString stringWithFormat:@"%d-%@-%@ %@:%@:00",year,month_string,day_string,hour_string,minute_string];
    [self.labelEventTime setText:showDateString];
    self.detail_event_time=showDateString;
    
    /*
     NSCalendar *gregorian = [[NSCalendar alloc]
     initWithCalendarIdentifier:NSGregorianCalendar];
     NSDateComponents *weekdayComponents =
     [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit | NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:date];
     NSInteger day = [weekdayComponents day];
     NSInteger weekday = [weekdayComponents weekday];
     NSInteger year= [weekdayComponents year];
     NSInteger month=[weekdayComponents month];
     NSInteger hour = [weekdayComponents hour];
     NSInteger minute = [weekdayComponents minute];
     NSLog(@"%d:%d:%d weekday%d  =>%d:%d",year,month,day,weekday,hour,minute);
     */
}

#pragma mark - self defined protocal <FeedBackToCreateActivityChange> method implementation
////////////////////////////////////////////////
//implement the method for the adding or delete contacts that will be go out with
-(void)AddContactInformtionToPeopleList:(InviteFriendObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSString * key=person.user_name;
    [self.invitedFriend setObject:(id)person forKey:key];
    //update the display label
    if ([self.invitedFriend count]==0) {
        [self.inviteFriendsLabel setText:@"Invite friends"];
        [self.inviteFriendsLabel setFont:[UIFont italicSystemFontOfSize:16]];
        [self.inviteFriendsLabel setTextColor:[UIColor lightGrayColor]];
        [self.inviteIcon setAlpha:0.4];
    }
    else if ([self.invitedFriend count]==1){
        [self.inviteFriendsLabel setText:@"1 friend"];
        [self.inviteFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.inviteFriendsLabel setTextColor:[UIColor darkGrayColor]];
        [self.inviteIcon setAlpha:0.8];
    }
    else{
        [self.inviteFriendsLabel setText:[NSString stringWithFormat:@"%d friends",[self.invitedFriend count]]];
        [self.inviteFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.inviteFriendsLabel setTextColor:[UIColor darkGrayColor]];
        [self.inviteIcon setAlpha:0.8];
    }
}

-(void)AddAddressBookContactInformtionToPeopleList:(UserContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSString *nameText=@"";
    if (person.firstName) {
        nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
        if (person.lastName) {
            nameText=[nameText stringByAppendingFormat:@", %@",person.lastName];
        }
    }
    else if(person.lastName){
        nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
    }
    NSString * key=nameText;
    [self.invitedAddressBookFriend setObject:(id)person forKey:key];
}

-(void)DeleteContactInformtionToPeopleList:(InviteFriendObject*)person{
    NSString * key=person.user_name;
    [self.invitedFriend removeObjectForKey:key];
    if ([self.invitedFriend count]==0) {
        [self.inviteFriendsLabel setText:@"Invite friends"];
        [self.inviteFriendsLabel setFont:[UIFont italicSystemFontOfSize:16]];
        [self.inviteFriendsLabel setTextColor:[UIColor lightGrayColor]];
        [self.inviteIcon setAlpha:0.4];
    }
    else if ([self.invitedFriend count]==1){
        [self.inviteFriendsLabel setText:@"1 friend"];
        [self.inviteFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.inviteFriendsLabel setTextColor:[UIColor darkGrayColor]];
        [self.inviteIcon setAlpha:0.8];
    }
    else{
        [self.inviteFriendsLabel setText:[NSString stringWithFormat:@"%d friends",[self.invitedFriend count]]];
        [self.inviteFriendsLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [self.inviteFriendsLabel setTextColor:[UIColor darkGrayColor]];
        [self.inviteIcon setAlpha:0.8];
    }
}

-(void)DeleteAddressBookContactInformtionToPeopleList:(UserContactObject *)person{
    NSString *nameText=@"";
    if (person.firstName) {
        nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
        if (person.lastName) {
            nameText=[nameText stringByAppendingFormat:@", %@",person.lastName];
        }
    }
    else if(person.lastName){
        nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
    }
    NSString * key=nameText;
    [self.invitedAddressBookFriend removeObjectForKey:key];
}

-(void)UpdateLastReceivedInviteFriendJson:(NSArray *)lastReceivedJson{
    self.invitedFriendLastReceivedJson=[lastReceivedJson copy];
}

-(void)startInviteFriendWithEventID{
    //
}

@end
