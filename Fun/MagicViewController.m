//
//  MagicViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/24/12.
//
//

#import "MagicViewController.h"

@interface MagicViewController ()
@property (weak, nonatomic) IBOutlet UIButton *refreshButton;

@end

@implementation MagicViewController
@synthesize refreshButton;

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.refreshButton.tintColor=[UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.presentingViewController dismissModalViewControllerAnimated:NO];
}

- (void)viewDidUnload
{
    [self setRefreshButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
