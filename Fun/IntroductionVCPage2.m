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
//- (IBAction)NextButtonClicked:(id)sender {
//    [self GoToNextPage];
//}
//
//
//-(void)GoToNextPage{
//    [self performSegueWithIdentifier:@"GotoNextPage" sender:self];
//}

@end
