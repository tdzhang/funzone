//
//  IntroductionVCPage2.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/24/12.
//
//

#import "IntroductionVCPage2.h"

@interface IntroductionVCPage2 ()

@end

@implementation IntroductionVCPage2

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
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(GoToNextPage)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
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

#pragma mark - self defined button
-(void)returnAction{
    NSMutableArray * viewControllers = [[self.navigationController viewControllers] mutableCopy];
    UIViewController * rootViewController = [viewControllers objectAtIndex:0];
    [viewControllers removeObjectAtIndex:0]; // try using with and without this line?
    [viewControllers addObject:rootViewController];
    [self.navigationController setViewControllers:viewControllers animated:NO];
    
}

-(void)GoToNextPage{
    [self performSegueWithIdentifier:@"Magic" sender:self];
    
    [self performSelector:@selector(returnAction) withObject:self afterDelay:0.6];
}

@end
