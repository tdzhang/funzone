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


#pragma mark - Constant Value Declarition

#define ANIMATION_TIME_DURATION 0.5
#define SHOW_OPTION_BUTTON_LOCATION_X 280
#define SHOW_OPTION_BUTTON_LOCATION_Y 360
#define SHOW_OPTION_BUTTON_LOCATION_WIDTH 40
#define SHOW_OPTION_BUTTON_LOCATION_HEIGHT 40
#define SHARE_BY_EMAIL_X 270
#define SHARE_BY_EMAIL_Y 285
#define SHARE_BY_FACEBOOK_X 220
#define SHARE_BY_FACEBOOK_Y 285
#define SHARE_BY_TWITTER_X 170
#define SHARE_BY_TWITTER_Y 285

#pragma mark - NewEventVC Private Declarition 
@interface NewEventVC () <UIActionSheetDelegate>
@property (nonatomic, retain) UIImagePickerController *imgPicker; //using to start a image pick(from camera or album)
@property (nonatomic,strong) UIButton* buttonEmailShare;
@property (nonatomic,strong) UIButton* buttonTwitterShare;
@property (nonatomic,strong) UIButton* buttonFacebookShare;
@property (nonatomic) BOOL showNewButtonFlag;
@property (weak, nonatomic) IBOutlet UIImageView *uIImageViewEvent;
@property (weak, nonatomic) IBOutlet UITextField *textViewEventDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTime;
//@property (weak, nonatomic) IBOutlet UIButton *buttonEventPrice;//---not using
@property (weak, nonatomic) IBOutlet UIButton *buttonEventFriends;
@property (weak, nonatomic) IBOutlet UIButton *buttonEditEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTitle;
@property (weak, nonatomic) IBOutlet UITextView *textFieldEventTitle;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldEventPrice;
//@property (weak, nonatomic) IBOutlet UILabel *labelChoosePhoto;
@property (weak, nonatomic) IBOutlet UITextView *uITextViewPersonalMsg;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTitleHolder;

@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSDictionary *facebookFriendsGoOutWith; //the infomation of the facebook firends that user choose to go with
@property (nonatomic,strong) NSString *currentFacebookConnect;
@property (weak, nonatomic) IBOutlet UILabel *eventPeopleInfo;
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
@property (nonatomic,strong) NSString *createEvent_title;
@property (nonatomic,strong) NSString *createEvent_latitude;
@property (nonatomic,strong) NSString *createEvent_longitude;
@property (nonatomic,strong) NSString *createEvent_locationName;
@property (nonatomic,strong) NSString *createEvent_time;
@property (nonatomic,strong) NSString *createEvent_address;
@property (nonatomic,strong) NSString *createEvent_imageUrlName;

@property (nonatomic,strong) NSString *facebookCurrentProcess;//use this to diff the facebook request intention

//Email Share Button handler
-(void)useEmailToShare:(id)sender;
//Twitter Share Button handler
-(void)useTwitterToShare:(id)sender;
//Facebook Share Button handler
-(void)useFacebookToShare:(id)sender;

@end

//////////////////////////////////////

@implementation NewEventVC
@synthesize eventPeopleInfo = _eventPeopleInfo;
@synthesize personProfileImage = _personProfileImage;
@synthesize imgPicker=_imgPicker;
@synthesize buttonEmailShare=_buttonEmailShare;
@synthesize buttonTwitterShare=_buttonTwitterShare;
@synthesize showNewButtonFlag=_showNewButtonFlag;
@synthesize uIImageViewEvent = _uIImageViewEvent;
@synthesize buttonFacebookShare=_buttonFacebookShare;
@synthesize textViewEventDescription = _eventDescriptionTextView;
@synthesize buttonChooseEventPhoto = _buttonChooseEventPhoto;
@synthesize buttonChooseEventLocation = _buttonChooseEventLocation;
@synthesize buttonEventTime = _eventTimeButton;
//@synthesize buttonEventPrice = _eventPriceButton;
@synthesize buttonEventFriends = _eventFriendsButton;
@synthesize buttonEditEventTitle = _buttonEditEventTitle;
@synthesize locationLabel = _locationLabel;
@synthesize labelEventTime = _labelEventTime;
@synthesize buttonEventTitle = _buttonEventTitle;
@synthesize textFieldEventTitle = _textFieldEventTitle;
//@synthesize textFieldEventPrice = _textFieldEventPrice;
//@synthesize labelChoosePhoto = _labelChoosePhoto;
@synthesize uITextViewPersonalMsg = _uITextViewPersonalMsg;
@synthesize labelEventTitleHolder = _labelEventTitleHolder;
@synthesize peopleGoOutWith=_peopleGoOutWith;
@synthesize facebookFriendsGoOutWith=_facebookFriendsGoOutWith;
@synthesize currentFacebookConnect=_currentFacebookConnect;
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
@synthesize createEvent_title=_createEvent_title;
@synthesize createEvent_latitude=_createEvent_latitude;
@synthesize createEvent_longitude=_createEvent_longitude;
@synthesize createEvent_locationName=_createEvent_locationName;
@synthesize createEvent_time=_createEvent_time;
@synthesize createEvent_address=_createEvent_address;
@synthesize createEvent_imageUrlName=_createEvent_imageUrlName;
@synthesize mapViewFeedBackImageView=_mapViewFeedBackImageView;

@synthesize facebookCurrentProcess=_facebookCurrentProcess;

#pragma mark - self defined synthesize
-(UIImage *)createEvent_image{
    _createEvent_image=self.uIImageViewEvent.image;
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

-(void)setPeopleGoOutWith:(NSDictionary *)peopleGoOutWith{
    _peopleGoOutWith=peopleGoOutWith;
    int i= [peopleGoOutWith count];
    int j= [self.facebookFriendsGoOutWith count];
    if (i>0||j>0) {
        [self.eventPeopleInfo setText:[NSString stringWithFormat:@"%d add ; %d facebook",i,j]];
    }
    else{
        [self.eventPeopleInfo setText:[NSString stringWithFormat:@"invite your friends"]];
    }
}

-(NSDictionary*)peopleGoOutWith{
    if (_peopleGoOutWith == nil){
        _peopleGoOutWith = [[NSDictionary alloc	] init];
    }
    return _peopleGoOutWith;	
}

-(void)setFacebookFriendsGoOutWith:(NSDictionary *)facebookFriendsGoOutWith{
    _facebookFriendsGoOutWith=facebookFriendsGoOutWith;
    int i= [self.peopleGoOutWith count];
    int j= [facebookFriendsGoOutWith count];
    if (i>0||j>0) {
        [self.eventPeopleInfo setText:[NSString stringWithFormat:@"%d add ; %d facebook",i,j]];
    }
    else{
        [self.eventPeopleInfo setText:[NSString stringWithFormat:@"Don't forget to invite your friends"]];
    }
}

-(NSDictionary*)facebookFriendsGoOutWith{
    if (_facebookFriendsGoOutWith == nil){
        _facebookFriendsGoOutWith = [[NSDictionary alloc] init];
    }
    return _facebookFriendsGoOutWith;	
}

#pragma mark - self defined
-(void)repinTheEventWithEventID:(NSString *)event_id sharedEventID:(NSString *)shared_event_id creatorID:(NSString*)creator_id eventTitle:(NSString *)event_title eventTime:(NSString *)event_time eventImage:(UIImage *)event_image locationName:(NSString *)location_name address:(NSString*)address longitude:(NSNumber *)longitude latitude:(NSNumber *)latitude description:(NSString *)description{
    self.detail_event_id=event_id;
    self.detail_shared_event_id=shared_event_id;
    self.detail_event_title=event_title;
    self.detail_event_time=event_time;
    self.detail_location_name=location_name;
    self.detail_creator_id=creator_id;
    NSLog(@"%@",location_name);
    self.detail_longitude=longitude;
    NSLog(@"%@",longitude);
    self.detail_latitude=latitude;
    NSLog(@"%@",latitude);
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

    //initiate the config of the EventShare To Friends Function part
    //clean the possible remain button (when went back from segue)
    if(self.buttonEmailShare){
        [self.buttonEmailShare removeFromSuperview];
    }
    if(self.buttonTwitterShare){
        [self.buttonTwitterShare removeFromSuperview];
    }
    if(self.buttonFacebookShare){
        [self.buttonFacebookShare removeFromSuperview];
    }
    

    //set up all the potential button(email,twitter,facebook)
    self.buttonEmailShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonEmailShare addTarget:self 
                     action:@selector(useEmailToShare:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.buttonEmailShare setImage:[UIImage imageNamed:@"weixin_icon.JPEG"] forState:UIControlStateNormal];
    self.buttonEmailShare.frame = CGRectMake(SHARE_BY_EMAIL_X,SHARE_BY_EMAIL_Y,SHOW_OPTION_BUTTON_LOCATION_WIDTH,SHOW_OPTION_BUTTON_LOCATION_HEIGHT);
    [self.buttonEmailShare setHidden:NO];
    [self.view addSubview:self.buttonEmailShare];
    
    self.buttonTwitterShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonTwitterShare addTarget:self 
                              action:@selector(useTwitterToShare:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTwitterShare setImage:[UIImage imageNamed:@"twitter-bird-white-on-blue.png"] forState:UIControlStateNormal];
    self.buttonTwitterShare.frame = CGRectMake(SHARE_BY_TWITTER_X,SHARE_BY_TWITTER_Y,SHOW_OPTION_BUTTON_LOCATION_WIDTH,SHOW_OPTION_BUTTON_LOCATION_HEIGHT);
    [self.buttonTwitterShare setHidden:NO];
    [self.view addSubview:self.buttonTwitterShare];
    
    self.buttonFacebookShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonFacebookShare addTarget:self 
                                action:@selector(useFacebookToShare:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.buttonFacebookShare setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
    self.buttonFacebookShare.frame = CGRectMake(SHARE_BY_FACEBOOK_X,SHARE_BY_FACEBOOK_Y,SHOW_OPTION_BUTTON_LOCATION_WIDTH,SHOW_OPTION_BUTTON_LOCATION_HEIGHT);
    [self.buttonFacebookShare setHidden:NO];
    [self.view addSubview:self.buttonFacebookShare];
    

    
    //initial the face book
    FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    if (!delegate.facebook) {
        delegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)delegate];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
            delegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
            NSLog(@"%@",delegate.facebook.accessToken);
            delegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        }
    }

    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"id,picture" forKey:@"fields"];
    if ([delegate.facebook isSessionValid]) {
        self.currentFacebookConnect=@"get user photo and id";
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
        [self.labelEventTitleHolder setHidden:YES];
        [self.locationLabel setText:self.detail_location_name];
        [self.uIImageViewEvent setImage:self.detail_image];
        [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
        [self.uIImageViewEvent clipsToBounds];
    }
}

- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [self setTextViewEventDescription:nil];
    [self setButtonEventTime:nil];
//    [self setButtonEventPrice:nil];
    [self setButtonEventFriends:nil];
    [self setButtonChooseEventPhoto:nil];
    [self setButtonChooseEventLocation:nil];
    [self setLocationLabel:nil];
    [self setButtonEventTitle:nil];
    [self setTextFieldEventTitle:nil];
//    [self setTextFieldEventPrice:nil];
//    [self setLabelChoosePhoto:nil];
    [self setUIImageViewEvent:nil];
    [self setLabelEventTime:nil];
    [self setEventPeopleInfo:nil];
    [self setUITextViewPersonalMsg:nil];
    [self setLabelEventTitleHolder:nil];
    [self setPersonProfileImage:nil];
    [self setMapViewFeedBackImageView:nil];
    [self setButtonEditEventTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - create event to server
- (IBAction)CreateEventToSever:(id)sender {
     NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/add",CONNECT_DOMIAN_NAME]];
    if (self.detail_event_id) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/pin",CONNECT_DOMIAN_NAME]];
    }
   
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"The event has been successfully uploaded posted." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        success.delegate=self;
        [success show];
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        notsuccess.delegate=self;
        [notsuccess show];
    }];
    //add login auth_token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
    [request setPostValue:self.createEvent_title forKey:@"title"];
    NSLog(@"%@",self.createEvent_address);
    [request setPostValue:self.createEvent_address forKey:@"address"];
    NSLog(@"%@",self.createEvent_locationName);
    [request setPostValue:self.createEvent_locationName forKey:@"location"];
    [request setPostValue:self.createEvent_longitude forKey:@"longitude"];
    [request setPostValue:self.createEvent_latitude forKey:@"latitude"];
    [request setPostValue:self.createEvent_time forKey:@"start_time"];
    if (self.detail_creator_id) {
        //if it is from repin
        if (![self.createEvent_image isEqual:self.detail_image]) {
            //add content
            if (self.createEvent_imageUrlName) {
                //if has image url, then no need to upload the image
                [request setPostValue:self.createEvent_imageUrlName forKey:@"image_url"];
            }
            else{
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
        [request setPostValue:self.detail_longitude forKey:@"longitude"];
        [request setPostValue:self.detail_latitude forKey:@"latitude"];
        [request setPostValue:self.detail_address forKey:@"address"];
        [request setPostValue:self.detail_location_name forKey:@"location"];
    }
    else {
        if (self.createEvent_imageUrlName) {
            //if has image url, then no need to upload the image
            [request setPostValue:self.createEvent_imageUrlName forKey:@"image_url"];
        }
        else{
            //add content
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
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}


#pragma mark - View AntoRotation Method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Segues related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if([segue.identifier isEqualToString:@"ChooseFriends"] && [segue.destinationViewController isKindOfClass:[ChoosePeopleToGoTableViewController class]]){
        ChoosePeopleToGoTableViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        peopleController.alreadySelectedContacts=[self.peopleGoOutWith copy];
    }
    else if([segue.identifier isEqualToString:@"ChooseFacebookFriends"] && [segue.destinationViewController isKindOfClass:[ChooseFacebookFriendsToGoTableViewControllerViewController class]]){
        ChooseFacebookFriendsToGoTableViewControllerViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        peopleController.alreadySelectedContacts=[self.facebookFriendsGoOutWith copy];
    }
    else if ([segue.identifier isEqualToString:@"chooseTime"] &&[segue.destinationViewController isKindOfClass:[TimeChooseViewController class]]){
        TimeChooseViewController *TimeChooseVC=segue.destinationViewController;
        [TimeChooseVC setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"ChooseLocationInMAP"]){
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *mapViewC=segue.destinationViewController;
            [mapViewC setDelegate:self];
            //pass in the event type to the destination(8 types)
            [mapViewC setPreDefinedEventType:self.eventType];
            if (![self.textFieldEventTitle.text isEqualToString:@""]) {
                [mapViewC setPredefinedSeachingWords:self.textFieldEventTitle.text];
            }
            else {
                [mapViewC setPredefinedSeachingWords:@""];
            }
            mapViewC.predefinedAnnotation=self.predefinedAnnotation;
        }
    }
    else if ([segue.identifier isEqualToString:@"ChooseImageUsingGoogleImage"]){
        if ([segue.destinationViewController isKindOfClass:[ChooseImageTableViewController class]]) {
            if (![self.textFieldEventTitle.text isEqualToString:@""]) {
                [segue.destinationViewController setPredefinedKeyWord:self.textFieldEventTitle.text];
            }
            [segue.destinationViewController setDelegate:self];
        }
    }
    else if([segue.identifier isEqualToString:@"moviewAutoCompletion"]){
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - action sheet
//pop the action sheet of the time selection
- (IBAction)SelectTime:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"When do you want to schedule?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Anytime",@"Today",@"Tomorrow",@"This weekend",@"Self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)ChoosePeopleToGo:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose a friend source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"via Email",@"via Facebook Message",@"via WeChat", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

//pop the action sheet of the choose the event title
- (IBAction)ChooseEventTitle:(UIButton *)sender {
    /*
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"getting together",@"eatting",@"movie",@"coffee",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
    */
    if([self.eventType isEqualToString:@"movie"]){
        [self performSegueWithIdentifier:@"moviewAutoCompletion" sender:self];
    }
    else {
        [self.buttonEditEventTitle setHidden:YES];
        [self.textFieldEventTitle becomeFirstResponder];
        [self.labelEventTitleHolder setHidden:YES];
    }
}
/*
- (IBAction)ChooseEventCost:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Estimate the event cost:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Free",@"less than $10",@"less than $100",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [pop showFromTabBar:self.tabBarController.tabBar];
}
*/
- (IBAction)ChoosePhoto:(UIButton *)sender {
    UIActionSheet *pop =[[UIActionSheet alloc] initWithTitle:@"Choose photo source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose from album",@"via Google Image", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //for the when to go action sheet
    if([actionSheet.title isEqualToString:@"When do you want to schedule?"]){
        if(buttonIndex == 0){
            [self.labelEventTime setText:@"Anytime"];
        }else if(buttonIndex == 1){
            [self.labelEventTime setText:@"Today"];
        }else if(buttonIndex == 2){
            [self.labelEventTime setText:@"Tomorrow"];
        }else if(buttonIndex == 3){
            [self.labelEventTime setText:@"This Weekend"];
        }else if(buttonIndex == 4){
            //self enter the time
            [self performSegueWithIdentifier:@"chooseTime" sender:self];
        }
        
    }
    //for choose people to go action sheet
    else if([actionSheet.title isEqualToString:@"Choose a friend source"]){
        if(buttonIndex == 0){//choose friends from address book
            [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
        }else if(buttonIndex == 1){//choose friends from facebook
            FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
            if (!funAppdelegate.facebook) funAppdelegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)funAppdelegate];
                
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
                //if already login : start choose friends
                funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
                [self performSegueWithIdentifier:@"ChooseFacebookFriends" sender:self];
            }
            if (![funAppdelegate.facebook isSessionValid]) {
                    //if not login, do it
                self.facebookCurrentProcess=@"chooseFriends";
                NSArray *permissions = [[NSArray alloc] initWithObjects:
                                            @"publish_stream", 
                                            @"read_stream",@"create_event",@"email",
                                            nil];
                [funAppdelegate.facebook authorize:permissions];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
            }
        }
    }
    
    else if([actionSheet.title isEqualToString:@"Select Share:"]){
        if (buttonIndex == 0) {
            //post on the wall
            NSLog(@"need to do sth about post on wall");
            FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            
            NSString *eventName=(![self.textFieldEventTitle.text isEqualToString:@""])?self.textFieldEventTitle.text:@"Some Stuff";
            NSString *eventTime=(![self.labelEventTime.text isEqualToString:@"time"])?self.labelEventTime.text:@"Some Time";
            NSString *eventLocation=(![self.locationLabel.text isEqualToString:@"location"])?self.locationLabel.text:@"some where";
            if ([eventTime length]<10) {
                NSDate *now = [NSDate date];
                eventTime=[now description];
            }  

            [params setObject:@"funnect event" forKey:@"name"];
            [params setObject:@"new funnect event" forKey:@"description"];
            [params setObject:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~",eventName,eventTime,eventLocation] forKey:@"message"];
            
            if ([delegate.facebook isSessionValid]) {
                self.currentFacebookConnect=@"create event";
                [delegate.facebook requestWithGraphPath:@"me/feed" 
                                              andParams:params 
                                          andHttpMethod:@"POST" 
                                            andDelegate:self];
            }
            else {
                NSLog(@"Face book session invalid~~~");
            }
        }
     
        else if(buttonIndex == 1){
            //share event
            FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            
            //get the event information from all the selection
            NSString *eventName=(![self.textFieldEventTitle.text isEqualToString:@""])?self.textFieldEventTitle.text:@"Some Stuff";
            NSString *eventTime=(![self.labelEventTime.text isEqualToString:@"time"])?self.labelEventTime.text:@"Some Time";
            
            NSLog(@"%@",self.locationLabel.text);
            NSString *eventLocation=(![self.locationLabel.text isEqualToString:@"location"])?self.locationLabel.text:@"some where";
            if ([eventTime length]<10) {
                NSDate *now = [NSDate date];
                eventTime=[now description];
            }  
            
            [params setObject:eventName forKey:@"name"];
            [params setObject:eventTime forKey:@"start_time"];
            [params setObject:[NSString stringWithFormat:@"%@",eventLocation] forKey:@"location"];
            [params setObject:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",eventName,eventTime,eventLocation] forKey:@"description"];
            
            if ([delegate.facebook isSessionValid]) {
                self.currentFacebookConnect=@"create event";
                [delegate.facebook requestWithGraphPath:@"me/events" 
                                              andParams:params 
                                          andHttpMethod:@"POST" 
                                            andDelegate:self];
            }
            else {
                NSLog(@"Face book session invalid~~~");
            }
        }
    }
    
    //for the event photo choose action sheet
    else if([actionSheet.title isEqualToString:@"Choose Photo Source"]){
        if (buttonIndex == 0) {
            //do sth. about take photo part
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imgPicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
                [self presentModalViewController:self.imgPicker animated:YES];
            }
            else {
                UIAlertView *cameraNotSupport = [[UIAlertView alloc] initWithTitle:@"Camera Not Exist" message:@"Your device does not support camera." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
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
                UIAlertView *cameraNotSupport = [[UIAlertView alloc] initWithTitle:@"Album doesn't exist" message:@"Your device does not support photo album." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                cameraNotSupport.delegate=self;
                [cameraNotSupport show];
            }
        }
        else if(buttonIndex ==2){
            //using google image seach(implement by segue)
            [self performSegueWithIdentifier:@"ChooseImageUsingGoogleImage" sender:self];
        }
    }
}


//Email Share Button handler
-(void)emailSelector:(id)sender{
    //reset the email share button
    [self.buttonEmailShare removeFromSuperview];
    self.buttonEmailShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonEmailShare addTarget:self 
                              action:@selector(useEmailToShare:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.buttonEmailShare setImage:[UIImage imageNamed:@"weixin_icon.JPEG"] forState:UIControlStateNormal];
    self.buttonEmailShare.frame = CGRectMake(SHARE_BY_EMAIL_X,SHARE_BY_EMAIL_Y,SHOW_OPTION_BUTTON_LOCATION_WIDTH,SHOW_OPTION_BUTTON_LOCATION_HEIGHT);
    [self.buttonEmailShare setHidden:NO];
    [self.view addSubview:self.buttonEmailShare];
    
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
                
                //get the event information from all the selection
                
                //get the event information from all the selection
                NSString *eventName=(![self.textFieldEventTitle.text isEqualToString:@""])?self.textFieldEventTitle.text:@"Some Stuff";
                NSString *eventTime=(![self.labelEventTime.text isEqualToString:@"time"])?self.labelEventTime.text:@"Some Time";
                NSString *eventLocation=(![self.locationLabel.text isEqualToString:@"location"])?self.locationLabel.text:@"some where";
                
                //email subject
                [mailCont setSubject:[NSString stringWithFormat:@"Event Invitation! Yeah, Let's %@",eventName]];
                //email list
                [mailCont setToRecipients:emailList];
                //email body
                [mailCont setMessageBody:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",eventName,eventTime,eventLocation,self.uITextViewPersonalMsg.text] isHTML:NO];
                //go!
                [self presentModalViewController:mailCont animated:YES];
            }
            
            
        }
    }
}

-(void)useEmailToShare:(id)sender{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:ANIMATION_TIME_DURATION];
    //sender.frame = CGRectMake(100.0, 210.0, 160.0, 40.0);
    [self.buttonEmailShare setTransform:CGAffineTransformMakeScale(40, 40)];
    [sender setAlpha:0];
    [UIView commitAnimations];

    [self performSelector:@selector(emailSelector:) withObject:sender afterDelay:ANIMATION_TIME_DURATION];
}

-(void)twitterSelector:(id)sender{
    //reset the button
    [self.buttonTwitterShare removeFromSuperview];
    self.buttonTwitterShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonTwitterShare addTarget:self 
                                action:@selector(useTwitterToShare:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTwitterShare setImage:[UIImage imageNamed:@"twitter-bird-white-on-blue.png"] forState:UIControlStateNormal];
    self.buttonTwitterShare.frame = CGRectMake(SHARE_BY_TWITTER_X,SHARE_BY_TWITTER_Y,SHOW_OPTION_BUTTON_LOCATION_WIDTH,SHOW_OPTION_BUTTON_LOCATION_HEIGHT);
    [self.buttonTwitterShare setHidden:NO];
    [self.view addSubview:self.buttonTwitterShare];
    
    //compose the twitter
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = 
        [[TWTweetComposeViewController alloc] init];
        
        //get the event information from all the selection
        NSString *eventName=(![self.textFieldEventTitle.text isEqualToString:@""])?self.textFieldEventTitle.text:@"Some fun stuff";
        NSString *eventTime=(![self.labelEventTime.text isEqualToString:@"time"])?self.labelEventTime.text:@"To be decided";
        NSString *eventLocation=(![self.locationLabel.text isEqualToString:@"location"])?self.locationLabel.text:@"To be announced";
        
        NSString *sendMsg=[NSString stringWithFormat:@"Hi All, I want to %@ time: %@ location %@ ",eventName,eventTime,eventLocation];
        NSLog(@"%@",sendMsg);
        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@",sendMsg]];
        if (self.uIImageViewEvent.image) {
            [tweetSheet addImage:self.uIImageViewEvent.image];
        }
	    [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] 
                                  initWithTitle:@"Sorry"                                                             
                                  message:@"You can't send a tweet right now, make sure your device has an Internet connection and you have at least one Twitter account setup"                                                          
                                  delegate:self                                              
                                  cancelButtonTitle:@"OK"                                                   
                                  otherButtonTitles:nil];
        [alertView show];
    }      
}

//Twitter Share Button handler
-(void)useTwitterToShare:(id)sender{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:ANIMATION_TIME_DURATION];
    [self.buttonTwitterShare setTransform:CGAffineTransformMakeScale(40, 40)];
    [sender setAlpha:0];
    [UIView commitAnimations];
    [self performSelector:@selector(twitterSelector:) withObject:sender afterDelay:ANIMATION_TIME_DURATION];
}

//Facebook Share Button handler
-(void)facebookSelector:(id)sender{
    //reset button
    [self.buttonFacebookShare removeFromSuperview];
    self.buttonFacebookShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonFacebookShare addTarget:self 
                                 action:@selector(useFacebookToShare:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.buttonFacebookShare setImage:[UIImage imageNamed:@"facebook_icon.png"] forState:UIControlStateNormal];
    self.buttonFacebookShare.frame = CGRectMake(SHARE_BY_FACEBOOK_X,SHARE_BY_FACEBOOK_Y,SHOW_OPTION_BUTTON_LOCATION_WIDTH,SHOW_OPTION_BUTTON_LOCATION_HEIGHT);
    [self.buttonFacebookShare setHidden:NO];
    [self.view addSubview:self.buttonFacebookShare];
    
    //initial the face book
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    if (!funAppdelegate.facebook) funAppdelegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)funAppdelegate];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        //if already login : start the action sheet
        funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        
        UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Select Share:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post on wall",@"Create Facebook event", nil];
        pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [pop showFromTabBar:self.tabBarController.tabBar];
         /*
        //post on the wall
        NSLog(@"need to do sth about post on wall");
        FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        
        NSString *eventName=(![self.textFieldEventTitle.text isEqualToString:@""])?self.textFieldEventTitle.text:@"Some Stuff";
        NSString *eventTime=(![self.labelEventTime.text isEqualToString:@"time"])?self.labelEventTime.text:@"Some Time";
        NSString *eventLocation=(![self.locationLabel.text isEqualToString:@"location"])?self.locationLabel.text:@"some where";
        if ([eventTime length]<10) {
            NSDate *now = [NSDate date];
            eventTime=[now description];
        }  
        [params setObject:@"funnect event" forKey:@"name"];
        [params setObject:@"new funnect event" forKey:@"description"];
        [params setObject:[NSString stringWithFormat:@"Hi All,\n\nI feels good, want to inivite you to do %@ . The time I think %@ is good. Dose that sounds good? Shall we meet at %@?\n\nYeah~\n\nCheers~",eventName,eventTime,eventLocation] forKey:@"message"];
        
        if ([delegate.facebook isSessionValid]) {
            self.currentFacebookConnect=@"post on wall";
            [delegate.facebook requestWithGraphPath:@"me/feed" 
                                          andParams:params 
                                      andHttpMethod:@"POST" 
                                        andDelegate:self];
        }
        else {
            NSLog(@"Face book session invalid~~~");
        }
          */

    }
    if (![funAppdelegate.facebook isSessionValid]) {
        //if not login, do it
        self.facebookCurrentProcess=@"Share";
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream", 
                                @"read_stream",@"create_event",@"email",
                                nil];
        [funAppdelegate.facebook authorize:permissions];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
    }
    //[[delegate facebook] requestWithGraphPath:@"me/friends" andDelegate:self];
}


-(void)useFacebookToShare:(id)sender{
    //to do sth here
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:ANIMATION_TIME_DURATION];
    [self.buttonFacebookShare setTransform:CGAffineTransformMakeScale(40, 40)];
    [sender setAlpha:0];
    [UIView commitAnimations];
    [self performSelector:@selector(facebookSelector:) withObject:sender afterDelay:ANIMATION_TIME_DURATION];
}

#pragma mark - facebook related protocal implement
-(void)faceBookLoginFinished{
    if ([self.facebookCurrentProcess isEqualToString:@"chooseFriends"]) {
        self.facebookCurrentProcess=nil;
        [self performSegueWithIdentifier:@"ChooseFacebookFriends" sender:self];
    }
    else if([self.facebookCurrentProcess isEqualToString:@"Share"]){
        self.facebookCurrentProcess=nil;
        UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Select Share:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Post on wall",@"Create facebook event", nil];
        pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
        [pop showFromTabBar:self.tabBarController.tabBar];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([self.currentFacebookConnect isEqualToString:@"create event"]) {
        //NSLog(@"%@",result);
        //get the event id
        NSString *event_id = [result objectForKey:@"id"];
        NSLog(@"start to invite people");
        //start to invite people
        if ([self.facebookFriendsGoOutWith count]>0) {
            FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            NSString* user_ids=[NSString stringWithFormat:@""];
            BOOL temp_flag=NO;
            for (NSString *key in self.facebookFriendsGoOutWith) {
                FacebookContactObject *contact=[self.facebookFriendsGoOutWith objectForKey:key];
                if (temp_flag==NO) {
                    user_ids=[user_ids stringByAppendingString:[NSString stringWithFormat:@"%@",contact.facebook_id]];
                    temp_flag=YES;
                }
                else {
                    user_ids=[user_ids stringByAppendingString:[NSString stringWithFormat:@",%@",contact.facebook_id]];
                }
            }
            [params setObject:user_ids forKey:@"users"];
            
            if ([delegate.facebook isSessionValid]) {
                self.currentFacebookConnect=@"add invite";
                NSLog(@"%@",event_id);
                [delegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/invited",event_id] andParams:params andHttpMethod:@"POST" andDelegate:self];
            }
            else {
                NSLog(@"Face book session invalid~~~");
            }
        }
    }
    else if ([self.currentFacebookConnect isEqualToString:@"add invite"]) {
        NSLog(@"%@",result);
        self.currentFacebookConnect=nil;
    }
    else if([self.currentFacebookConnect isEqualToString:@"get user photo and id"]){
        NSLog(@"%@",result);
        NSString *photo=[result objectForKey:@"picture"];
        //NSString *facebook_user_id=[result objectForKey:@"id"];
       // NSLog(@"%@",facebook_user_id);
        self.currentFacebookConnect = nil;
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
                    UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
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
                            [self.personProfileImage setImage:[UIImage imageWithData:imageData ]];
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

    }
    else if([self.currentFacebookConnect isEqualToString:@"post on wall"]){
         self.currentFacebookConnect = nil;
        //NSLog(@"%@",result);
    }
    else {
        //NSLog(@"%@",result);
    }
}



#pragma mark - implement protocals
////////////////////////////////////////////////
//implement the movieInfoReturn protocal, for movie info return
-(void)movieInfoReturn:(rottenTomatoMovieModel *)model from:(id) sender{
    [self.textFieldEventTitle setText:model.title];
    [self.navigationController popViewControllerAnimated:YES];
}

////////////////////////////////////////////////
//implement the MFMailComposeViewControllerDelegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        NSLog(@"Sending Email Error Happened!");
    }
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////
//implement the UIImagePickerControllerDelegate Method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleToFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////
//implement the chooseimageFeedBackDelegate method
-(void)ChooseUIImage:(UIImage *)image WithUrlName:(NSString*)URLName From:(ChooseImageTableViewController *)sender{
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleToFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    self.createEvent_imageUrlName= URLName;
    [self.navigationController popViewControllerAnimated:YES];
}



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
//implement the Protocal UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {  
    
    UIBarButtonItem *done =    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];  
    
    self.navigationItem.rightBarButtonItem = done;      
    [self animateTextView:textView up:YES];
}  

- (void)textViewDidEndEditing:(UITextView *)textView {  
    self.navigationItem.rightBarButtonItem = nil; 
    [self animateTextView:textView up:NO];
    [self.buttonEditEventTitle setHidden:NO];
}  

//deal with when user pressed the "done" button
- (void)leaveEditMode {  
    NSString *enteredText=[self.textFieldEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    enteredText=[enteredText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([enteredText length]==0) {
        [self.labelEventTitleHolder setHidden:NO];
    }
    [self.textFieldEventTitle resignFirstResponder];  
}
//To compensate for the showing up keyboard
- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    const int movementDistance = 20; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
    /*
    else if ([textField isEqual:self.textFieldEventPrice]){
        if ([textField.text length]==0) {
            UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Cost Input Empty" message:@"You did not input anything" delegate:self  cancelButtonTitle:@"Input Again" otherButtonTitles:@"Cancel",nil];
            inputEmptyError.delegate=self;
            [inputEmptyError show];
            return YES;
        }
        [textField resignFirstResponder];
        [self.buttonEventPrice setTitle:textField.text forState:UIControlStateNormal];
        [self.textFieldEventPrice setHidden:YES];
        return YES;
    }
     */
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
    /*
    //deal with the input empty for the add cost part
    else if ([alertView.title isEqualToString:@"Cost Input Empty"]){
        if (buttonIndex == 0) {
            //Input Again
            [self.textFieldEventPrice becomeFirstResponder];
        }
        else if(buttonIndex == 1){
            //Cancel
            [self.textFieldEventPrice resignFirstResponder];
            [self.buttonEventPrice setTitle:@"Add cost" forState:UIControlStateNormal];
            [self.textFieldEventPrice setHidden:YES];
        }

    }
     */
}

////////////////////////////////////////////////
//implement the method for the adding or delete Facebook contacts that will be go out with (FeedBackToFaceBookFriendToGoChange)
-(void)AddFacebookContactTogoInformtionToPeopleList:(FacebookContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSMutableDictionary *people=[self.facebookFriendsGoOutWith mutableCopy];
    NSString * key=person.facebook_name;
    [people setObject:(id)person forKey:key];
    self.facebookFriendsGoOutWith = [people copy];
}

-(void)DeleteFacebookContactTogoInformtionToPeopleList:(FacebookContactObject*)person{
    NSMutableDictionary *people=[self.facebookFriendsGoOutWith mutableCopy];
    NSString *key=person.facebook_name;
    [people removeObjectForKey:key];
    self.facebookFriendsGoOutWith = [people copy];
}

////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
-(void)UpdateLocation:(MKAnnotationView *)aView withLocationName:(NSString *)locationName withSnapShot:(UIImage *)image sendFrom:(MapViewController *)sender{
    MKPointAnnotation *annotation=aView.annotation;
    self.predefinedAnnotation=annotation;
    NSString *locationDescription=[NSString stringWithFormat:@"%@",annotation.title];
    //show the map snapshot
    //[self.buttonChooseEventLocation setBackgroundImage:image forState:UIControlStateNormal];
    //add discription
    [self.locationLabel setText:locationDescription];
    //[self.buttonLocation setTitle:locationDescription forState:UIControlStateNormal];
    //[self.locationLabel setText:[NSString stringWithFormat:@"lati:%f; long%f",annotation.coordinate.latitude,annotation.coordinate.longitude]];
    
    [self.mapViewFeedBackImageView setImage:image];
    [self.mapViewFeedBackImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.mapViewFeedBackImageView setHidden:NO];
    self.createEvent_latitude=[NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
    self.createEvent_longitude=[NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
    
    self.createEvent_locationName=[locationName copy];
    NSLog(@"%@",self.createEvent_locationName);
    if (annotation.subtitle) {
        self.createEvent_address=[NSString stringWithFormat:@"%@",annotation.subtitle];
        NSLog(@"%@",self.createEvent_address);
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
    //NSInteger weekday = [weekdayComponents weekday];
    NSInteger year= [weekdayComponents year];
    NSInteger month=[weekdayComponents month];
    NSInteger hour = [weekdayComponents hour];
    NSInteger minute = [weekdayComponents minute];
    NSString* showDateString= [NSString stringWithFormat:@"%d/%d/%d %d:%d",month,day,year,hour,minute];
    [self.labelEventTime setText:showDateString];
    
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


@end
