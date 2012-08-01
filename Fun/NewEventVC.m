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
@property (weak, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (nonatomic) BOOL showNewButtonFlag;
@property (weak, nonatomic) IBOutlet UIImageView *uIImageViewEvent;
//@property (weak, nonatomic) IBOutlet UITextField *textViewEventDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTime;
//@property (weak, nonatomic) IBOutlet UIButton *buttonEventPrice;//---not using
//@property (weak, nonatomic) IBOutlet UIButton *buttonEventFriends;
@property (weak, nonatomic) IBOutlet UIButton *buttonEditEventTitle;
//@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTime;
//@property (weak, nonatomic) IBOutlet UIButton *buttonEventTitle;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UITextView *textFieldEventTitle;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldEventPrice;
//@property (weak, nonatomic) IBOutlet UILabel *labelChoosePhoto;
//@property (weak, nonatomic) IBOutlet UITextView *uITextViewPersonalMsg;
@property (weak, nonatomic) IBOutlet UILabel *labelEventTitleHolder;


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
@property (weak, nonatomic) IBOutlet UIButton *doneButton;


@end

//////////////////////////////////////

@implementation NewEventVC
//@synthesize eventPeopleInfo = _eventPeopleInfo;
@synthesize deleteButton = _deleteButton;
@synthesize doneButton = _doneButton;
@synthesize showNewButtonFlag=_showNewButtonFlag;
@synthesize personProfileImage = _personProfileImage;
@synthesize imgPicker=_imgPicker;
@synthesize buttonEmailShare=_buttonEmailShare;
@synthesize buttonTwitterShare=_buttonTwitterShare;
@synthesize uIImageViewEvent = _uIImageViewEvent;
@synthesize buttonFacebookShare=_buttonFacebookShare;
@synthesize keyboardToolbar = _keyboardToolbar;
//@synthesize textViewEventDescription = _eventDescriptionTextView;
@synthesize buttonChooseEventPhoto = _buttonChooseEventPhoto;
@synthesize buttonChooseEventLocation = _buttonChooseEventLocation;
@synthesize buttonEventTime = _buttonEventTime;
//@synthesize buttonEventPrice = _eventPriceButton;
//@synthesize buttonEventFriends = _eventFriendsButton;
@synthesize buttonEditEventTitle = _buttonEditEventTitle;
//@synthesize locationLabel = _locationLabel;
@synthesize labelEventTime = _labelEventTime;
//@synthesize buttonEventTitle = _buttonEventTitle;
@synthesize locationLabel = _locationLabel;
@synthesize locationIcon = _locationIcon;
@synthesize timeIcon = _timeIcon;
@synthesize textFieldEventTitle = _textFieldEventTitle;
//@synthesize textFieldEventPrice = _textFieldEventPrice;
//@synthesize labelChoosePhoto = _labelChoosePhoto;
//@synthesize uITextViewPersonalMsg = _uITextViewPersonalMsg;
@synthesize labelEventTitleHolder = _labelEventTitleHolder;
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

//the property used to chaneg the UI between edit and create
@synthesize isEditPage=_isEditPage;


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



#pragma mark - self defined
//make the Page for Edit
-(void)presetIsEditPageToTrue{
    self.isEditPage=YES;
}
//make the Page for Create
-(void)presetIsEditPageToFalse{
    self.isEditPage=NO;
}
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
    
    //chaneg the Ui for the edit/create event
    if (self.isEditPage) {
        [self.deleteButton setHidden:NO];
        [self.doneButton setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else{
        [self.deleteButton setHidden:YES];
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
    }
    
    //get the photo of the user
    //initial the face book
    FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    if (!delegate.facebook) {
        delegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)delegate];
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
        [self.labelEventTitleHolder setHidden:YES];
        [self.locationLabel setText:self.detail_location_name];
        [self.uIImageViewEvent setImage:self.detail_image];
        [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
        [self.uIImageViewEvent clipsToBounds];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    //[self setTextViewEventDescription:nil];
    [self setButtonEventTime:nil];
//    [self setButtonEventPrice:nil];
    //[self setButtonEventFriends:nil];
    [self setButtonChooseEventPhoto:nil];
    [self setButtonChooseEventLocation:nil];
    //[self setLocationLabel:nil];
    //[self setButtonEventTitle:nil];
    [self setTextFieldEventTitle:nil];
//    [self setTextFieldEventPrice:nil];
//    [self setLabelChoosePhoto:nil];
    [self setUIImageViewEvent:nil];
    [self setLabelEventTime:nil];
    //[self setEventPeopleInfo:nil];
    //[self setUITextViewPersonalMsg:nil];
    [self setLabelEventTitleHolder:nil];
    [self setPersonProfileImage:nil];
    [self setMapViewFeedBackImageView:nil];
    [self setButtonEditEventTitle:nil];
    [self setKeyboardToolbar:nil];
    [self setLocationLabel:nil];
    [self setLocationIcon:nil];
    [self setTimeIcon:nil];
    [self setDeleteButton:nil];
    [self setDoneButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - create/delete/edite event to server
- (IBAction)deleteEventButton:(id)sender {
    //after delete, need to return to myparc
    //create event
    //Adding Create Event
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/delete?event_id=%@&shared_event_id=%@&auth_token=%@",CONNECT_DOMIAN_NAME,self.detail_event_id,self.detail_shared_event_id,[defaults objectForKey:@"login_auth_token"]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        //NSString *responseString = [block_request responseString];
        //NSLog(@"%@",responseString);
        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
        if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Delete error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            notsuccess.delegate=self;
            [notsuccess show];
        }
        /*
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"The event has been successfully deleted." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            success.delegate=self;
        [success show];
         */
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        notsuccess.delegate=self;
        [notsuccess show];
    }];


    
    
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
    
    //go to the next page
    [self performSegueWithIdentifier:@"FinshCreateGoToSharePart" sender:self];
}


- (IBAction)CreateEventToSever:(id)sender {
    if (self.isEditPage) {
    //edit event
        //Adding Create Event
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/edit",CONNECT_DOMIAN_NAME]];

        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        __block ASIFormDataRequest *block_request=request;
        [request setCompletionBlock:^{
            // Use when fetching text data
            //NSString *responseString = [block_request responseString];
            //NSLog(@"%@",responseString);
            
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
            if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                notsuccess.delegate=self;
                [notsuccess show];
            }
            //        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"The event has been successfully uploaded to our server." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            //        success.delegate=self;
            //[success show];
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
                    if (data) {
                        [request setData:data withFileName:[NSString stringWithFormat:@"temp_name.%@",format] andContentType:[NSString stringWithFormat:@"image/%@",format] forKey:@"image"];
                    }
                }
            }
            [request setPostValue:self.detail_event_id forKey:@"event_id"];
            [request setPostValue:self.detail_shared_event_id forKey:@"shared_event_id"];
            [request setPostValue:self.detail_longitude forKey:@"longitude"];
            [request setPostValue:self.detail_latitude forKey:@"latitude"];
            [request setPostValue:self.detail_address forKey:@"address"];
            [request setPostValue:self.detail_location_name forKey:@"location"];
        }
        
        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
        
        //go to the next page
        [self performSegueWithIdentifier:@"FinshCreateGoToSharePart" sender:self];
    }
    else {
    //create event
        //Adding Create Event
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/add",CONNECT_DOMIAN_NAME]];
        if (self.detail_event_id) {
            url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/pin",CONNECT_DOMIAN_NAME]];
        }
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        __block ASIFormDataRequest *block_request=request;
        [request setCompletionBlock:^{
            // Use when fetching text data
            //NSString *responseString = [block_request responseString];
            //NSLog(@"%@",responseString);
            
            NSError *error;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
            if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                notsuccess.delegate=self;
                [notsuccess show];
            }
            //        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Congratulations!" message:@"The event has been successfully uploaded to our server." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            //        success.delegate=self;
            //[success show];
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
        }
        //decide the category_id
        NSString *category_id=nil;
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
        else if ([category_id isEqualToString:@"food"]) {            [request setPostValue:FOOD forKey:@"category_id"];
        }
        else {
            [request setPostValue:OTHERS forKey:@"category_id"];
        }

        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
        
        //go to the next page
        [self performSegueWithIdentifier:@"FinshCreateGoToSharePart" sender:self];
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
    else if ([segue.identifier isEqualToString:@"FinshCreateGoToSharePart"]){
        ShareAfterNewEventViewController* nextVC=segue.destinationViewController;
        [nextVC presetEventImage:self.createEvent_image WithTiTle:self.createEvent_title WithLatitude:self.createEvent_latitude WithLongitude:self.createEvent_longitude WithLocationName:self.createEvent_locationName WithTime:self.createEvent_time WithAddress:self.createEvent_time WithImageUrlName:self.createEvent_imageUrlName];
    }
}

#pragma mark - action sheet
//pop the action sheet of the time selection
- (IBAction)SelectTime:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"When do you want to schedule?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Anytime",@"Today",@"Tomorrow",@"This weekend",@"Self enter", nil];
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
    NSLog(@"%@",actionSheet.title);
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
        [self.labelEventTime setFont:[UIFont boldSystemFontOfSize:16]];
        [self.labelEventTime setTextColor:[UIColor darkGrayColor]];
        [self.timeIcon setAlpha:0.8];
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
                    UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
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
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////
//implement the chooseimageFeedBackDelegate method
-(void)ChooseUIImage:(UIImage *)image WithUrlName:(NSString*)URLName From:(ChooseImageTableViewController *)sender{
    [self.uIImageViewEvent setContentMode:UIViewContentModeScaleAspectFill];
    [self.uIImageViewEvent clipsToBounds];
    [self.uIImageViewEvent setImage:image];
    self.createEvent_imageUrlName= URLName;
    [self.navigationController popViewControllerAnimated:YES];
}




////////////////////////////////////////////////
//implement the Protocal UITextViewDelegate
//- (void)textViewDidBeginEditing:(UITextView *)textView {      
//    UIBarButtonItem *done =    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];  
//    [done setStyle:UIBarButtonItemStyleBordered];
//    self.navigationItem.rightBarButtonItem = done;      
//    //[self animateTextView:textView up:YES];
//}  
//
//- (void)textViewDidEndEditing:(UITextView *)textView {  
//    self.navigationItem.rightBarButtonItem = nil; 
//    //[self animateTextView:textView up:NO];
//    [self.buttonEditEventTitle setHidden:NO];
//}  
//
////deal with when user pressed the "done" button
//- (void)leaveEditMode {  
//    NSString *enteredText=[self.textFieldEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
//    enteredText=[enteredText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    if ([enteredText length]==0) {
//        [self.labelEventTitleHolder setHidden:NO];
//    }
//    [self.textFieldEventTitle resignFirstResponder];  
//}
//
////To compensate for the showing up keyboard
//- (void) animateTextView: (UITextView*) textView up: (BOOL) up
//{
//    const int movementDistance = 20; // tweak as needed
//    const float movementDuration = 0.3f; // tweak as needed
//    
//    int movement = (up ? -movementDistance : movementDistance);
//    
//    [UIView beginAnimations: @"anim" context: nil];
//    [UIView setAnimationBeginsFromCurrentState: YES];
//    [UIView setAnimationDuration: movementDuration];
//    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
//    [UIView commitAnimations];
//}

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

#pragma mark -
#pragma mark Notifications
- (IBAction)leaveEditMode:(UIBarButtonItem *)sender {
    NSString *enteredText=[self.textFieldEventTitle.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    enteredText=[enteredText stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if ([enteredText length]==0) {
        [self.labelEventTitleHolder setHidden:NO];
    }
    [self.textFieldEventTitle resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    
    [self.labelEventTitleHolder setHidden:YES];
    CGRect frame = self.keyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0;
    self.keyboardToolbar.frame = frame;
    [self.keyboardToolbar setHidden:FALSE];
    UIBarButtonItem *doneButton = [self.keyboardToolbar.items objectAtIndex:0];
    doneButton.target = self;
    doneButton.action = @selector(leaveEditMode);
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
//implement the method for dealing with the return of the alertView
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
