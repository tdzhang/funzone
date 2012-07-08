//
//  CategroyChooseViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategroyChooseViewController.h"

@interface CategroyChooseViewController ()
@property (nonatomic,strong) UIView *flash;

@end

@implementation CategroyChooseViewController
@synthesize flash=_flash;

#pragma mark - Controller Life circle

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

#define FLASH_TRANSITION_DURATION 0.7

#pragma mark - annimation related
-(void)FlashTransition2:(id)sender{
    [self.flash removeFromSuperview];
}

-(void)FlashTransition1{
    UIView *flash=[[UIView alloc] initWithFrame:CGRectMake(0,0, 320, 367)];
    self.flash=flash;
    [flash setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    [self.view addSubview:flash];
    
    [self.flash setAlpha:0.1];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.0];
    [UIView setAnimationDuration:FLASH_TRANSITION_DURATION];
    [self.flash setAlpha:1.0];
    [UIView commitAnimations];
    [self performSelector:@selector(FlashTransition2:) withObject:self afterDelay:FLASH_TRANSITION_DURATION];
}

#pragma mark - button action
-(void)GoToNextViewEvent:(id)sender{
    [self performSegueWithIdentifier:@"NewEvent" sender:self];
}
- (IBAction)EventButtonClicked:(UIButton *)sender {
    [self FlashTransition1];
    [self performSelector:@selector(GoToNextViewEvent:) withObject:sender afterDelay:FLASH_TRANSITION_DURATION];
}


@end
