//
//  IntroductionVCPage3.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/24/12.
//
//

#import "IntroductionVCPage3.h"

@interface IntroductionVCPage3 ()

@end

@implementation IntroductionVCPage3

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
    
    //config the navigation bar button
    self.navigationItem.hidesBackButton=YES;
    
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined function
-(void)returnAction{
    NSMutableArray * viewControllers = [[self.navigationController viewControllers] mutableCopy];
    UIViewController * rootViewController = [viewControllers objectAtIndex:0];
    [viewControllers removeObjectAtIndex:0]; // try using with and without this line?
    [viewControllers addObject:rootViewController];
    [self.navigationController setViewControllers:viewControllers animated:NO];

}

- (IBAction)finishedTheIntroductionPart:(id)sender {
//    [UIView beginAnimations:@"animation" context:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
//    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
//    [UIView setAnimationDuration:0.5];
//    [UIView commitAnimations];
    
   
    
//    ExploreViewController *magicVC = [[ExploreViewController alloc] init];
//    magicVC.modalTransitionStyle  = UIModalTransitionStyleFlipHorizontal;
//    [self presentModalViewController:magicVC animated:true];
    [self performSegueWithIdentifier:@"Magic" sender:self];
    
    [self performSelector:@selector(returnAction) withObject:sender afterDelay:0.6];

}

@end
