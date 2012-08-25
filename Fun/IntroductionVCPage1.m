//
//  IntroductionVCPage1.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/24/12.
//
//

#import "IntroductionVCPage1.h"

@interface IntroductionVCPage1 ()

@end

@implementation IntroductionVCPage1

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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //config the navigation bar button
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(GoToNextPage)];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
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


-(void)GoToNextPage{
    [self performSegueWithIdentifier:@"GotoNextPage" sender:self];
}
@end
