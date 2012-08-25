//
//  ProfilePicViewController.m
//  OrangeParc
//
//  Created by Yizhou Zhu on 8/24/12.
//
//

#import "ProfilePicViewController.h"

@interface ProfilePicViewController ()
@property (nonatomic,strong) NSURL *imgUrl;
@end

@implementation ProfilePicViewController
@synthesize imgUrl=_imgUrl;

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
    NSLog(@"%@",self.imgUrl);
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
    self.imgUrl = imgUrl;
    return;
}
@end
