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

- (IBAction)finishedTheIntroductionPart:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
