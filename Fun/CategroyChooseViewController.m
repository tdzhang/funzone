//
//  CategroyChooseViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#define FLASH_TRANSITION_DURATION 0.5
#define GOTO_FOOD_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_EVENT_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_ENTERTAIN_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_OUTDOOR_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_SPORTS_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_MOVIE_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_SHOPPING_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_PARTY_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"
#define GOTO_SELFDEFINE_VIEWCONTROLLER_SNAPSHOT @"AddEventControllerSnapShot.png"

#import "CategroyChooseViewController.h"

@interface CategroyChooseViewController ()
@property (nonatomic,strong) UIView *flash;
@property (nonatomic,strong) UIImageView *flashBackImageView;
@property (nonatomic,strong) NSString *eventPrepareCategory;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSelfDefine;
@end

@implementation CategroyChooseViewController
@synthesize flash=_flash;
@synthesize flashBackImageView=_flashBackImageView;
@synthesize eventPrepareCategory=_eventPrepareCategory;
@synthesize textFieldSelfDefine = _textFieldSelfDefine;


#pragma mark - Controller Life circle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.flash) {
        [self.flash removeFromSuperview];
    }
    if (self.flashBackImageView) {
        [self.flashBackImageView removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTextFieldSelfDefine:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - segue related
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"NewEvent"]) {
        //do some preparation for the next Controller
        //the category information is in the self.eventPrepareCategory
    }
}

#pragma mark - annimation related
//these two function is used to create a flash in and out before segue effect
-(void)FlashTransition2:(id)sender{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:FLASH_TRANSITION_DURATION];
    [self.flash setAlpha:0.0];
    [self.flashBackImageView setAlpha:1.0];
    [UIView commitAnimations];
}

//the imageName is the snapshot for the next loading view
-(void)FlashTransition1:(NSString *)imageName{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 367)];
    self.flashBackImageView=imageView;
    [imageView setImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:imageView];
    [self.flashBackImageView setAlpha:0.05];
    
    
    UIView *flash=[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 367)];
    self.flash=flash;
    [flash setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [self.view addSubview:flash];
    
    [self.flash setAlpha:0.1];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:FLASH_TRANSITION_DURATION];
    [self.flash setAlpha:1.0];
    [self.flashBackImageView setAlpha:0.5];
    [UIView commitAnimations];
    [self performSelector:@selector(FlashTransition2:) withObject:self afterDelay:FLASH_TRANSITION_DURATION];
}

#pragma mark - button action
-(void)GoToNextViewEvent:(id)sender{
    [self performSegueWithIdentifier:@"NewEvent" sender:sender];
}
//food
- (IBAction)FoodButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"food";
    [self FlashTransition1:GOTO_FOOD_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//events
- (IBAction)EventButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"event";
    [self FlashTransition1:GOTO_EVENT_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Entertain
- (IBAction)EntertainButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"entertain";
    [self FlashTransition1:GOTO_ENTERTAIN_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Outdoor
- (IBAction)OutdoorButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"outdoor";
    [self FlashTransition1:GOTO_OUTDOOR_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Sports
- (IBAction)SportsButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"sports";
    [self FlashTransition1:GOTO_SPORTS_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
    
}
//Movie
- (IBAction)MovieButtonClicked:(id)sender {
    self.eventPrepareCategory=@"movie";
    [self FlashTransition1:GOTO_MOVIE_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//shopping
- (IBAction)ShoppingButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"shopping";
    [self FlashTransition1:GOTO_SHOPPING_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Party
- (IBAction)PartyButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"party";
    [self FlashTransition1:GOTO_PARTY_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//hit the self define button "Go"
- (IBAction)SelfDefineButtonClicked:(id)sender {
    UITextField *textField=self.textFieldSelfDefine;
    //if input is empty, pop out the alert
    if ([textField.text length]==0) {
        UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Self Define Input Empty" message:@"You did not input anything" delegate:self  cancelButtonTitle:@"Input Again" otherButtonTitles:@"Cancel",nil];
        inputEmptyError.delegate=self;
        [inputEmptyError show];
    }
    //otherwise, do the segue
    [self.textFieldSelfDefine resignFirstResponder];
    [self FlashTransition1:GOTO_SELFDEFINE_VIEWCONTROLLER_SNAPSHOT];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}

#pragma mark - testfield delegate method
////////////////////////////////////////////////
//implement the method for dealing with the textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.textFieldSelfDefine]) {
        [textField resignFirstResponder];
        return YES;
    }
    return YES;
}

//the next 3 method deal with the keyboard covering with the text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
     //if edit the add cost textfield, the whole view need to 
     //scroll up, get rid of the keyboard covering
     if ([textField isEqual:self.textFieldSelfDefine]) {
     [self animateTextField: textField up: YES];
     }
     
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
     //if finished editign the add cost textfield, the whole view need to scroll down
     if ([textField isEqual:self.textFieldSelfDefine]) {
     [self animateTextField: textField up: NO];
     }
     
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 40; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - deal with alert view
////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@",alertView.title);
    //deal with the Input Empty Error for the activity category choose
    if ([alertView.title isEqualToString:@"Self Define Input Empty"]) {
        //NSLog(@"%d",buttonIndex);
        if (buttonIndex == 0) {
            //Input Again
            [self.textFieldSelfDefine becomeFirstResponder];
        }
        else if(buttonIndex == 1){
            //Cancel
            [self.textFieldSelfDefine resignFirstResponder];
        }
    }
}

@end
