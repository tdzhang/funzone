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
#define CATEGORY_FOOD @"Category-Food.png"
#define CATEGORY_EVENTS @"Category-Events.png"
#define CATEGORY_ENTERTAIN @"Category-Entertainment.png"
#define CATEGORY_MOVIE @"Category-Movie.jpeg"
#define CATEGORY_OUTDOOR @"Category-Outdoor.png"
#define CATEGORY_PARTY @"Category-Party.png"
#define CATEGORY_SHOPPTING @"Category-Shopping.png"
#define CATEGORY_SPORTS @"Category-Sports.png"


#import "CategroyChooseViewController.h"

@interface CategroyChooseViewController ()
@property (nonatomic,strong) UIView *flash;
@property (nonatomic,strong) UIImageView *flashBackImageView;
@property (nonatomic,strong) UIImageView *flashZoomOutImageView;
@property (nonatomic,strong) NSString *eventPrepareCategory;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSelfDefine;
@property (nonatomic) BOOL uIViewUpFlag; //using to say whether the view is puting up to avoid keyboard shadowing
@end

@implementation CategroyChooseViewController
@synthesize flash=_flash;
@synthesize uIViewUpFlag=_uIViewUpFlag;
@synthesize flashZoomOutImageView=_flashZoomOutImageView;
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
    
    /*
    //judge whether the user is login? if not, do the login
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"login_auth_token"]) {
        //if not login, do it
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        LoginPageViewController* loginVC=[storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
        loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginVC animated:YES completion:^{}];
    }
    */
     
    //clean the possible undeleted view
    if (self.flash) {
        [self.flash removeFromSuperview];
    }
    if (self.flashBackImageView) {
        [self.flashBackImageView removeFromSuperview];
    }
    
    //........towards right Gesture recogniser for swiping.....// usded to change view
    UISwipeGestureRecognizer* rightRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction =UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
    //........towards left Gesture recogniser for swiping.....// used to change view
    UISwipeGestureRecognizer* leftRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;[leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer]; 

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
        if ([self.eventPrepareCategory isEqualToString:@"movie"]) {
            [(NewEventVC *)segue.destinationViewController setEventType:@"movie"];
        }
        else {
            [(NewEventVC *)segue.destinationViewController setEventType:@"other"];
        }
    }
    //clean up the unprocess UIView up rolling stuff(shadowing keyboard related stuff)
    if (self.uIViewUpFlag) {
        [self animateTextField:self.textFieldSelfDefine up:NO];
        self.uIViewUpFlag=NO;
        [self.textFieldSelfDefine resignFirstResponder];
    }
}

#pragma mark - annimation related
//these two function is used to create a flash in and out before segue effect
-(void)FlashTransition2:(id)sender{
    //if has the flashZoomOUtImageView, clean it
    if (self.flashZoomOutImageView){
        [self.flashZoomOutImageView removeFromSuperview];
        self.flashZoomOutImageView = nil;
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:FLASH_TRANSITION_DURATION];
    [self.flash setAlpha:0.0];
    [self.flashBackImageView setAlpha:1.0];
    [UIView commitAnimations];
}

//the imageName is the snapshot for the next loading view
-(void)FlashTransition1:(NSString *)imageName withCategoryImage:(NSString *)categoryImageName{
    //set up the flashOut image
    if ([categoryImageName isEqualToString:CATEGORY_FOOD])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_EVENTS])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 0, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_ENTERTAIN])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 0, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_OUTDOOR])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 0, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_SPORTS])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 183, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_MOVIE])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(80, 183, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_SHOPPTING])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(160, 183, 80, 184)];
    if ([categoryImageName isEqualToString:CATEGORY_PARTY])
        self.flashZoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(240, 183, 80, 184)];

    if (self.flashZoomOutImageView) {
        [self.flashZoomOutImageView setImage:[UIImage imageNamed:categoryImageName]];
        [self.view addSubview:self.flashZoomOutImageView];
    }
    
    
    //set up the background snap image
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0,0, 320, 367)];
    self.flashBackImageView=imageView;
    [imageView setImage:[UIImage imageNamed:imageName]];
    [self.view addSubview:imageView];
    [self.flashBackImageView setAlpha:0.05];
    
    
    //set up the flash transition
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
    if (self.flashZoomOutImageView){
        [self.flashZoomOutImageView setTransform:CGAffineTransformMakeScale(10, 10)];
        [self.flashZoomOutImageView setAlpha:0.2];
    }
    [UIView commitAnimations];
    [self performSelector:@selector(FlashTransition2:) withObject:self afterDelay:FLASH_TRANSITION_DURATION];
}

#pragma mark - button action
-(void)GoToNextViewEvent:(id)sender{
    [self.flashBackImageView removeFromSuperview];
    self.flashBackImageView=nil;
    [self performSegueWithIdentifier:@"NewEvent" sender:sender];
}
//food
- (IBAction)FoodButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"food";
    [self FlashTransition1:GOTO_FOOD_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_FOOD];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//events
- (IBAction)EventButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"event";
    [self FlashTransition1:GOTO_EVENT_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_EVENTS];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Entertain
- (IBAction)EntertainButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"entertain";
    [self FlashTransition1:GOTO_ENTERTAIN_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_ENTERTAIN];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Outdoor
- (IBAction)OutdoorButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"outdoor";
    [self FlashTransition1:GOTO_OUTDOOR_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_OUTDOOR];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Sports
- (IBAction)SportsButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"sports";
    [self FlashTransition1:GOTO_SPORTS_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_SPORTS];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
    
}
//Movie
- (IBAction)MovieButtonClicked:(id)sender {
    self.eventPrepareCategory=@"movie";
    [self FlashTransition1:GOTO_MOVIE_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_MOVIE];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//shopping
- (IBAction)ShoppingButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"shopping";
    [self FlashTransition1:GOTO_SHOPPING_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_SHOPPTING];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
}
//Party
- (IBAction)PartyButtonClicked:(UIButton *)sender {
    self.eventPrepareCategory=@"party";
    [self FlashTransition1:GOTO_PARTY_VIEWCONTROLLER_SNAPSHOT withCategoryImage:CATEGORY_PARTY];
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
    else {
        //otherwise, do the segue
        [self.textFieldSelfDefine resignFirstResponder];
        [self FlashTransition1:GOTO_SELFDEFINE_VIEWCONTROLLER_SNAPSHOT withCategoryImage:@"NO"];
        [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION*2];
    }
    
}

#pragma mark - Gesture handler
-(void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer{
    //right swipe need to change to the left view
    // Get the views.
    int controllerIndex=1;
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    // Position it off screen.
    toView.frame = CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
    [UIView animateWithDuration:0.4 
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.tabBarController.selectedIndex = controllerIndex;                
                         }
                     }];
}

-(void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer{
    //left swipe need to change to the right view
    // Get the views.
    int controllerIndex=3;
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    // Position it off screen.
    toView.frame = CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
    [UIView animateWithDuration:0.4 
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.tabBarController.selectedIndex = controllerIndex;                
                         }
                     }];
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
     self.uIViewUpFlag=YES;
     }
     
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
     //if finished editign the add cost textfield, the whole view need to scroll down
     if ([textField isEqual:self.textFieldSelfDefine]) {
     [self animateTextField: textField up: NO];
     self.uIViewUpFlag=NO;
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
