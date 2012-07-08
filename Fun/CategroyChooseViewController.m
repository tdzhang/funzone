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

#import "CategroyChooseViewController.h"

@interface CategroyChooseViewController ()
@property (nonatomic,strong) UIView *flash;
@property (nonatomic,strong) UIImageView *flashBackImageView;
@property (nonatomic,strong) NSString *eventPrepareCategory;
@end

@implementation CategroyChooseViewController
@synthesize flash=_flash;
@synthesize flashBackImageView=_flashBackImageView;
@synthesize eventPrepareCategory=_eventPrepareCategory;


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


@end
