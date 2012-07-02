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


#pragma mark - NewEventVC Private Declarition 
@interface NewEventVC () <UIActionSheetDelegate>


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
@end

//////////////////////////////////////

@implementation NewEventVC

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
        }
    }
    else if ([segue.identifier isEqualToString:@"ChooseImagveSegue"]){
        if ([segue.destinationViewController isKindOfClass:[ChooseImageTableViewController class]]) {
            if (![self.buttonEventTitle.titleLabel.text isEqualToString:@"Event Title"]) {
                [segue.destinationViewController setPredefinedKeyWord:self.buttonEventTitle.titleLabel.text];
                [segue.destinationViewController setDelegate:self];
            }
            
        }
    }
}

#pragma mark - action sheet
//pop the action sheet of the time selection
- (IBAction)SelectTime:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"When do you want to schedule?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"now",@"today",@"tonight",@"tomorrow",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showInView:self.view];
}
//pop the action sheet of the choose the event title
- (IBAction)ChooseEventTitle:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"What do you want to do?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"getting together",@"eatting",@"movie",@"coffee",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showInView:self.view];

}
- (IBAction)ChooseEventCost:(UIButton *)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Estimate the event cost:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Free",@"less than $10",@"less than $100",@"self enter", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackOpaque;
    [pop showInView:self.view];
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
}



#pragma mark - implement protocals
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
