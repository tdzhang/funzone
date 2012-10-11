//
//  ShareAfterNewEventViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/28/12.
//
//

#import "ShareAfterNewEventViewController.h"

@interface ShareAfterNewEventViewController ()
@property (nonatomic,strong) UIImage *createEvent_image;
@property (nonatomic,strong) NSString *createEvent_title;
@property (nonatomic,strong) NSString *createEvent_latitude;
@property (nonatomic,strong) NSString *createEvent_longitude;
@property (nonatomic,strong) NSString *createEvent_locationName;
@property (nonatomic,strong) NSString *createEvent_time;
@property (nonatomic,strong) NSString *createEvent_address;
@property (nonatomic,strong) NSString *createEvent_imageUrlName;
@property (nonatomic,strong) NSString *preDefinedMode;
@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSDictionary *peopleGoOutWithMessage; //the infomation of the firend that user choose to go with
//@property (weak, nonatomic) IBOutlet UIButton *WeixinButton;
//@property (weak, nonatomic) IBOutlet UIButton *EmailButton;
@property (weak, nonatomic) IBOutlet UITextView *textview_shareinfo;

@property (weak, nonatomic) IBOutlet UIToolbar *myKeyboardToolbar;
@property (weak, nonatomic) IBOutlet UILabel *statuse_text;
@property (weak, nonatomic) IBOutlet UIButton *button_finish;

@end

@implementation ShareAfterNewEventViewController
//@synthesize WeixinButton = _WeixinButton;
//@synthesize EmailButton = _EmailButton;
@synthesize delegate=_delegate;
@synthesize createEvent_image=_createEvent_image;
@synthesize createEvent_title=_createEvent_title;
@synthesize createEvent_latitude=_createEvent_latitude;
@synthesize createEvent_longitude=_createEvent_longitude;
@synthesize createEvent_locationName=_createEvent_locationName;
@synthesize createEvent_time=_createEvent_time;
@synthesize createEvent_address=_createEvent_address;
@synthesize createEvent_imageUrlName=_createEvent_imageUrlName;
@synthesize preDefinedMode=_preDefinedMode;

@synthesize peopleGoOutWith=_peopleGoOutWith;
@synthesize peopleGoOutWithMessage=_peopleGoOutWithMessage;


#pragma mark - self defined setter and getter
-(void)setPeopleGoOutWith:(NSDictionary *)peopleGoOutWith{
    _peopleGoOutWith=peopleGoOutWith;
}

-(NSDictionary*)peopleGoOutWith{
    if (_peopleGoOutWith == nil){
        _peopleGoOutWith = [[NSDictionary alloc	] init];
    }
    return _peopleGoOutWith;
}

-(void)peopleGoOutWithMessage:(NSDictionary *)peopleGoOutWithMessage{
    _peopleGoOutWithMessage=peopleGoOutWithMessage;
}

-(NSDictionary*)peopleGoOutWithMessage{
    if (_peopleGoOutWithMessage == nil){
        _peopleGoOutWithMessage = [[NSDictionary alloc] init];
    }
    return _peopleGoOutWithMessage;
}

#pragma mark - View Life Cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //set up the weixin delegate
    FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.delegate=(id)appDelegate;
    
    //set the button to be a circle
//    self.WeixinButton.layer.cornerRadius = 20;
//    self.WeixinButton.clipsToBounds=YES;
//    self.EmailButton.layer.cornerRadius = 20;
//    self.EmailButton.clipsToBounds=YES;
    
    //add notification listener
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(EventCreateFinished) name:@"EventCreateFinished" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //set the preset content of the sharing
    [self.textview_shareinfo setText:[self inviteMessagetoSend]];
    [self.button_finish setEnabled:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EventCreateFinished" object:nil];
    //reset the keyboard addititonal "done" tool bar
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined method
//deal when event is already created
-(void)EventCreateFinished{
    [self.statuse_text setText:@"Ready To Finish."];
    [self.button_finish setTitle:@"Finish Creation and Invitation" forState:UIControlStateNormal];
    [self.button_finish setEnabled:YES];
}
- (IBAction)FinishedThisPage:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* event_id=[defaults objectForKey:@"temp_event_id"];
    NSString* shared_event_id=[defaults objectForKey:@"temp_shared_event_id"];
    
    NSLog(@"%@",event_id);
    NSLog(@"%@",shared_event_id);
    ///////
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/messages/send_invitation?",CONNECT_DOMIAN_NAME]];
    NSLog(@"request:%@",url);
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
        [request setPostValue:event_id forKey:@"event_id"];
        [request setPostValue:shared_event_id forKey:@"shared_event_id"];
        [request setPostValue:self.textview_shareinfo.text forKey:@"content"];
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
    
    //make the my collection page refresh
    FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.myCollection_needrefresh=YES;
    //return to the my collection page
    [self.navigationController popToRootViewControllerAnimated:YES];
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    [funAppdelegate.thisTabBarController setSelectedIndex:3];
}

//return the share message
-(NSString*)shareMessagetoSend{
    return [NSString stringWithFormat:@"I am using OrangeParc,just find an insteresting event \"%@\" at %@?\nCheck out the detail at http://www.orangeparc.com",self.createEvent_title,self.createEvent_locationName];
}

//return the share message
-(NSString*)inviteMessagetoSend{
    return [NSString stringWithFormat:@"I just found an insteresting event \"%@\" at %@, it will start \"%@\", I want to invite you to join me.\nCheck out the detail at http://www.orangeparc.com",self.createEvent_title,self.createEvent_locationName,self.createEvent_time];
}


-(void)presetEventImage:(UIImage*)createEvent_image WithTiTle:(NSString*)createEvent_title WithLatitude:(NSString*)createEvent_latitude WithLongitude:(NSString*)createEvent_longitude WithLocationName:(NSString*)createEvent_locationName WithTime:(NSString*)createEvent_time WithAddress:(NSString*)createEvent_address WithImageUrlName:(NSString*)createEvent_imageUrlName{
    self.createEvent_image=createEvent_image;
    self.createEvent_title=createEvent_title;
    self.createEvent_latitude=createEvent_latitude;
    self.createEvent_longitude=createEvent_longitude;
    self.createEvent_locationName=createEvent_locationName;
    self.createEvent_time=createEvent_time;
    self.createEvent_address=createEvent_address;
    self.createEvent_imageUrlName=createEvent_imageUrlName;
}

#pragma mark - edit textview related thing


- (IBAction)closeKeyboard:(id)sender {
    [self.textview_shareinfo resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    [self animateTextFieldup:true];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.25];
    //[self.labelEventTitleHolder setHidden:YES];
    [self.myKeyboardToolbar setHidden:NO];
    CGRect frame = self.myKeyboardToolbar.frame;
    frame.origin.y = self.view.frame.size.height - 260.0+160;
    self.myKeyboardToolbar.frame = frame;
    [self.myKeyboardToolbar setHidden:FALSE];
    UIBarButtonItem *doneButtonKeyBoard = [self.myKeyboardToolbar.items objectAtIndex:0];
    doneButtonKeyBoard.target = self;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    [self animateTextFieldup:FALSE];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.25];
	[self.myKeyboardToolbar setHidden:YES];
	CGRect frame = self.myKeyboardToolbar.frame;
	frame.origin.y = self.view.frame.size.height;
	self.myKeyboardToolbar.frame = frame;
	
	[UIView commitAnimations];
    
}

- (void) animateTextFieldup: (BOOL) up
{
    const int movementDistance = 160; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ChooseFriends"] && [segue.destinationViewController isKindOfClass:[ChoosePeopleToGoTableViewController class]]){
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


#pragma mark - Button Action
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
                [mailCont setSubject:[NSString stringWithFormat:@"I want to invite you to %@",self.createEvent_title]];
                //email list
                [mailCont setToRecipients:emailList];
                //email body
                [mailCont setMessageBody:[self inviteMessagetoSend] isHTML:NO];
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
                //messageSender.messageComposeDelegate = self;
                //phone list
                [messageSender setRecipients:phoneList];
                //phone body
                [messageSender setBody:[self inviteMessagetoSend]];
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

#pragma mark - self defined protocal method implementation
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

#pragma mark - implement protocals


- (void)viewDidUnload {
    [self setTextview_shareinfo:nil];
    [self setMyKeyboardToolbar:nil];
    [self setStatuse_text:nil];
    [self setButton_finish:nil];
    [super viewDidUnload];
}
@end
