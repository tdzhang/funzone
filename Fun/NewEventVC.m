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
#define TOP_RIGHT_VIEW_WIDTH 72
#define TOP_RIGHT_VIEW_HEIGHT 79

#define ANIMATION_TIME_DURATION 0.7


#pragma mark - NewEventVC Private Declarition 
@interface NewEventVC () <UIActionSheetDelegate>
@property (nonatomic, retain) UIImagePickerController *imgPicker; //using to start a image pick(from camera or album)
@property (nonatomic,strong) UIButton* buttonEmailShare;
@property (nonatomic,strong) UIButton* buttonTwitterShare;
@property (nonatomic,strong) UIButton* buttonFacebookShare;
@property (nonatomic) BOOL showNewButtonFlag;
@property (weak, nonatomic) IBOutlet UITextView *textViewEventDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventPrice;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventFriends;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEventTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEventPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelChoosePhoto;

@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with

//Email Share Button handler
-(void)useEmailToShare:(id)sender;
//Twitter Share Button handler
-(void)useTwitterToShare:(id)sender;
//Facebook Share Button handler
-(void)useFacebookToShare:(id)sender;

@end

//////////////////////////////////////

@implementation NewEventVC
@synthesize imgPicker=_imgPicker;
@synthesize buttonEmailShare=_buttonEmailShare;
@synthesize buttonTwitterShare=_buttonTwitterShare;
@synthesize showNewButtonFlag=_showNewButtonFlag;
@synthesize buttonFacebookShare=_buttonFacebookShare;
@synthesize textViewEventDescription = _eventDescriptionTextView;
@synthesize buttonChooseEventPhoto = _buttonChooseEventPhoto;
@synthesize buttonChooseEventLocation = _buttonChooseEventLocation;
@synthesize buttonEventTime = _eventTimeButton;
@synthesize buttonEventPrice = _eventPriceButton;
@synthesize buttonEventFriends = _eventFriendsButton;
@synthesize locationLabel = _locationLabel;
@synthesize buttonEventTitle = _buttonEventTitle;
@synthesize textFieldEventTitle = _textFieldEventTitle;
@synthesize textFieldEventPrice = _textFieldEventPrice;
@synthesize labelChoosePhoto = _labelChoosePhoto;
@synthesize peopleGoOutWith=_peopleGoOutWith;

#pragma mark - self defined synthesize
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
    if (i>0) {
        [self.buttonEventFriends setTitle:[NSString stringWithFormat:@"%d friends",i] forState:UIControlStateNormal];
    }
    else{
        [self.buttonEventFriends setTitle:@"Invite Friends" forState:UIControlStateNormal];
    }
}

-(NSDictionary*)peopleGoOutWith{
    if (_peopleGoOutWith == nil){
        _peopleGoOutWith = [[NSDictionary alloc	] init];
    }
    return _peopleGoOutWith;	
}


#pragma mark - View lifecycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //initiate the config of the EventShare To Friends Function part
    //set the show flag to NO;
    self.showNewButtonFlag=NO;
    //set up all the potential button(email,twitter,facebook)
    self.buttonEmailShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonEmailShare addTarget:self 
                     action:@selector(useEmailToShare:)
           forControlEvents:UIControlEventTouchUpInside];
    [self.buttonEmailShare setImage:[UIImage imageNamed:@"email.png"] forState:UIControlStateNormal];
    self.buttonEmailShare.frame = CGRectMake(265.0, 320.0, 35.0, 35.0);
    [self.buttonEmailShare setHidden:YES];
    [self.view addSubview:self.buttonEmailShare];
    
    self.buttonTwitterShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonTwitterShare addTarget:self 
                              action:@selector(useTwitterToShare:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.buttonTwitterShare setImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
    self.buttonTwitterShare.frame = CGRectMake(265.0, 320.0, 35.0, 35.0);
    [self.buttonTwitterShare setHidden:YES];
    [self.view addSubview:self.buttonTwitterShare];
    
    self.buttonFacebookShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonFacebookShare addTarget:self 
                                action:@selector(useFacebookToShare:)
                      forControlEvents:UIControlEventTouchUpInside];
    [self.buttonFacebookShare setImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
    self.buttonFacebookShare.frame = CGRectMake(265.0, 320.0, 35.0, 35.0);
    [self.buttonFacebookShare setHidden:YES];
    [self.view addSubview:self.buttonFacebookShare];
}

- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setTextViewEventDescription:nil];
    [self setButtonEventTime:nil];
    [self setButtonEventPrice:nil];
    [self setButtonEventFriends:nil];
    [self setButtonChooseEventPhoto:nil];
    [self setButtonChooseEventLocation:nil];
    [self setLocationLabel:nil];
    [self setButtonEventTitle:nil];
    [self setTextFieldEventTitle:nil];
    [self setTextFieldEventPrice:nil];
    [self setLabelChoosePhoto:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
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
    else if ([segue.identifier isEqualToString:@"chooseTime"] &&[segue.destinationViewController isKindOfClass:[TimeChooseViewController class]]){
        TimeChooseViewController *TimeChooseVC=segue.destinationViewController;
        [TimeChooseVC setDelegate:self];
    }
    else if ([segue.identifier isEqualToString:@"ChooseLocationInMAP"]){
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *mapViewC=segue.destinationViewController;
            [mapViewC setDelegate:self];
            if (![self.buttonEventTitle.titleLabel.text isEqualToString:@"Event Title"]) {
                [mapViewC setPredefinedSeachingWords:self.buttonEventTitle.titleLabel.text];
            }
            else {
                [mapViewC setPredefinedSeachingWords:@""];
            }
            
        }
    }
    else if ([segue.identifier isEqualToString:@"ChooseImageUsingGoogleImage"]){
        if ([segue.destinationViewController isKindOfClass:[ChooseImageTableViewController class]]) {
            if (![self.buttonEventTitle.titleLabel.text isEqualToString:@"Event Title"]) {
                [segue.destinationViewController setPredefinedKeyWord:self.buttonEventTitle.titleLabel.text];
            }
            [segue.destinationViewController setDelegate:self];
        }
    }
}

#pragma mark - action sheet
//pop the action sheet of the time selection
- (IBAction)SelectTime:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"When do you want to schedule?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"now",@"today",@"tonight",@"tomorrow",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}
//pop the action sheet of the choose the event title
- (IBAction)ChooseEventTitle:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"getting together",@"eatting",@"movie",@"coffee",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];

}
- (IBAction)ChooseEventCost:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Estimate the event cost:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Free",@"less than $10",@"less than $100",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [pop showFromTabBar:self.tabBarController.tabBar];
}
- (IBAction)ChoosePhoto:(UIButton *)sender {
    UIActionSheet *pop =[[UIActionSheet alloc] initWithTitle:@"Choose Photo Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"In Album",@"Google Image", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //for the what to do action sheet
    if([actionSheet.title isEqualToString:@"What do you want to do?"]){
        if(buttonIndex == 0){
            [self.buttonEventTitle setTitle:@"getting together" forState:UIControlStateNormal];
        }else if(buttonIndex == 1){
            [self.buttonEventTitle setTitle:@"eatting" forState:UIControlStateNormal];
        }else if(buttonIndex == 2){
            [self.buttonEventTitle setTitle:@"movie" forState:UIControlStateNormal];
        }else if(buttonIndex == 3){
            [self.buttonEventTitle setTitle:@"coffee" forState:UIControlStateNormal];
        }else if(buttonIndex == 4){
            [self.textFieldEventTitle setHidden:NO];
            [self.textFieldEventTitle becomeFirstResponder];
            [self.buttonEventTitle setTitle:@"" forState:UIControlStateNormal];
        }
    }
    //for the when to go action sheet
    else if([actionSheet.title isEqualToString:@"When do you want to schedule?"]){
        if(buttonIndex == 0){
            [self.buttonEventTime setTitle:@"now" forState:UIControlStateNormal];
        }else if(buttonIndex == 1){
            [self.buttonEventTime setTitle:@"today" forState:UIControlStateNormal];
        }else if(buttonIndex == 2){
            [self.buttonEventTime setTitle:@"tonight" forState:UIControlStateNormal];
        }else if(buttonIndex == 3){
            [self.buttonEventTime setTitle:@"tomorrow" forState:UIControlStateNormal];
        }else if(buttonIndex == 4){
            //self enter the time
            [self performSegueWithIdentifier:@"chooseTime" sender:self];
        }
        
    }
    //for the event cost action sheet
    else if ([actionSheet.title isEqualToString:@"Estimate the event cost:"]) {
        if (buttonIndex==0) {
            [self.buttonEventPrice setTitle:@"Free" forState:UIControlStateNormal];
        }else if (buttonIndex==1) {
            [self.buttonEventPrice setTitle:@"less than $10" forState:UIControlStateNormal];
        }else if (buttonIndex == 2){
            [self.buttonEventPrice setTitle:@"less than $100" forState:UIControlStateNormal];
        }else if(buttonIndex == 3){
            [self.textFieldEventPrice setHidden:NO];
            [self.textFieldEventPrice becomeFirstResponder];
            [self.buttonEventPrice setTitle:@"" forState:UIControlStateNormal];
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
                UIAlertView *cameraNotSupport = [[UIAlertView alloc] initWithTitle:@"Camera Not Exist" message:@"Your device do not support Camera." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
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
                UIAlertView *cameraNotSupport = [[UIAlertView alloc] initWithTitle:@"Album Not Exist" message:@"Your device do not support Photo Album." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
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


#pragma mark - Share the event to Friends
//show all the option button
- (IBAction)showAllOptionButtons:(id)sender {
    if (self.showNewButtonFlag==NO) {
        [self.buttonEmailShare setHidden:NO];
        [self.buttonEmailShare setAlpha:0];
        [self.buttonTwitterShare setHidden:NO];
        [self.buttonTwitterShare setAlpha:0];
        [self.buttonFacebookShare setHidden:NO];
        [self.buttonFacebookShare setAlpha:0];
        
        CABasicAnimation *fullRotation;
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:((10*M_PI))];
        fullRotation.duration = ANIMATION_TIME_DURATION;
        fullRotation.repeatCount = 1;
        [self.buttonEmailShare.layer addAnimation:fullRotation forKey:@"360"];
        [self.buttonTwitterShare.layer addAnimation:fullRotation forKey:@"360"];
        [self.buttonFacebookShare.layer addAnimation:fullRotation forKey:@"360"];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationDuration:ANIMATION_TIME_DURATION];
        self.buttonEmailShare.frame = CGRectMake(205.0,320.0,35.0,35.0);
        self.buttonTwitterShare.frame = CGRectMake(145.0,320.0,35.0,35.0);
        self.buttonFacebookShare.frame = CGRectMake(85.0,320.0,35.0,35.0);
        [self.buttonEmailShare setAlpha:1];
        [self.buttonTwitterShare setAlpha:1];
        [self.buttonFacebookShare setAlpha:1];
        [UIView commitAnimations];
        self.showNewButtonFlag=YES;
    }
    else{
        CABasicAnimation *fullRotation;
        fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        fullRotation.fromValue = [NSNumber numberWithFloat:0];
        fullRotation.toValue = [NSNumber numberWithFloat:((10*M_PI))];
        fullRotation.duration = ANIMATION_TIME_DURATION;
        fullRotation.repeatCount = 1;
        [self.buttonEmailShare.layer addAnimation:fullRotation forKey:@"360"];
        [self.buttonTwitterShare.layer addAnimation:fullRotation forKey:@"360"];
        [self.buttonFacebookShare.layer addAnimation:fullRotation forKey:@"360"];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDelay:0.0];
        [UIView setAnimationDuration:ANIMATION_TIME_DURATION];
        self.buttonEmailShare.frame = CGRectMake(265.0, 320.0, 35.0, 35.0);
        self.buttonTwitterShare.frame = CGRectMake(265.0, 320.0, 35.0, 35.0);
        self.buttonFacebookShare.frame = CGRectMake(265.0, 320.0, 35.0, 35.0);        
        [self.buttonEmailShare setAlpha:0];
        [self.buttonTwitterShare setAlpha:0];
        [self.buttonFacebookShare setAlpha:0];
        [UIView commitAnimations];
        self.showNewButtonFlag=NO;
    }

}

//Email Share Button handler
-(void)emailSelector:(id)sender{
    //clean the screen of all the potential option buttons
    [self.buttonEmailShare.layer removeAllAnimations];
    [self.buttonTwitterShare.layer removeAllAnimations];
    [self.buttonFacebookShare.layer removeAllAnimations];
    [self.buttonEmailShare setHidden:YES];
    [self.buttonTwitterShare setHidden:YES];
    [self.buttonFacebookShare setHidden:YES];
    
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
                NSString *eventName=(self.buttonEventTitle.titleLabel.text!=@"Event Title")?self.buttonEventTitle.titleLabel.text:@"Some Stuff";
                NSString *eventTime=(self.buttonEventTime.titleLabel.text!=@"Select time")?self.buttonEventTime.titleLabel.text:@"Some Time";
                NSString *eventCost=(self.buttonEventPrice.titleLabel.text!=@"Add cost")?self.buttonEventPrice.titleLabel.text:@"maybe not much";
                NSString *eventLocation=self.locationLabel.text;
                
                //email subject
                [mailCont setSubject:[NSString stringWithFormat:@"Event Invitation! Yeah, Let's %@",eventName]];
                //email list
                [mailCont setToRecipients:emailList];
                //email body
                [mailCont setMessageBody:[NSString stringWithFormat:@"Hi All,\n\nI feels good, want to inivite you to do %@ . The cost is %@, and the time I think %@ is good. Dose that sounds good? Shall we meet at %@?\n\nYeah~ Cheers~",eventName,eventCost,eventTime,eventLocation] isHTML:NO];
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

//Twitter Share Button handler
-(void)useTwitterToShare:(id)sender{
    //to do sth here
}

//Facebook Share Button handler
-(void)useFacebookToShare:(id)sender{
    //to do sth here

}


//the button activite the email sending event
- (void)SendInvitationByEmail {
            
}





#pragma mark - implement protocals
////////////////////////////////////////////////
//implement the MFMailComposeViewControllerDelegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        NSLog(@"Sending Email Error Happended!");
    }
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////
//implement the UIImagePickerControllerDelegate Method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    [self.buttonChooseEventPhoto setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissModalViewControllerAnimated:YES];
}


////////////////////////////////////////////////
//implement the chooseimageFeedBackDelegate method
-(void)ChooseUIImage:(UIImage *)image From:(ChooseImageTableViewController *)sender{
    [self.buttonChooseEventPhoto setBackgroundImage:image forState:UIControlStateNormal];
    [self.labelChoosePhoto setHidden:YES];
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
//implement the method for dealing with the textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.textFieldEventTitle]) {
        if ([textField.text length]==0) {
            UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Title Input Empty" message:@"You did not input anything" delegate:self  cancelButtonTitle:@"Input Again" otherButtonTitles:@"Cancel",nil];
            inputEmptyError.delegate=self;
            [inputEmptyError show];
            return YES;
        }
        [textField resignFirstResponder];
        [self.buttonEventTitle setTitle:textField.text forState:UIControlStateNormal];
        [self.textFieldEventTitle setHidden:YES];
        return YES;
    }
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
    return YES;
}

//the next 3 method deal with the keyboard covering with the text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //if edit the add cost textfield, the whole view need to 
    //scroll up, get rid of the keyboard covering
    if ([textField isEqual:self.textFieldEventPrice]) {
        [self animateTextField: textField up: YES];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //if finished editign the add cost textfield, the whole view need to scroll down
    if ([textField isEqual:self.textFieldEventPrice]) {
        [self animateTextField: textField up: NO];
    }
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
            [self.buttonEventTitle setTitle:@"getting together" forState:UIControlStateNormal];
            [self.textFieldEventTitle setHidden:YES];
        }
    }
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
}

////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
-(void)UpdateLocation:(MKAnnotationView *)aView withSnapShot:(UIImage *)image sendFrom:(MapViewController *)sender{
    MKPointAnnotation *annotation=aView.annotation;
    NSString *locationDescription=[NSString stringWithFormat:@"%@",annotation.title];
    //show the map snapshot
    [self.buttonChooseEventLocation setBackgroundImage:image forState:UIControlStateNormal];
    //add discription
    [self.locationLabel setText:locationDescription];
    //[self.buttonLocation setTitle:locationDescription forState:UIControlStateNormal];
    //[self.locationLabel setText:[NSString stringWithFormat:@"lati:%f; long%f",annotation.coordinate.latitude,annotation.coordinate.longitude]];
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
    NSString* showDateString= [NSString stringWithFormat:@"%d/%d/%d @%d:%d",month,day,year,hour,minute];
    [self.buttonEventTime setTitle:showDateString forState:UIControlStateNormal];
    
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
