//
//  ProfilePicViewController.m
//  OrangeParc
//
//  Created by Yizhou Zhu on 8/24/12.
//
//

#import "ProfilePicViewController.h"

@interface ProfilePicViewController ()

@end

@implementation ProfilePicViewController

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)preSetImgUrl:(NSURL *)imgUrl {
    
}
@end
