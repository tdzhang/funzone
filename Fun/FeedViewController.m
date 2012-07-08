//
//  FeedViewController.m
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FeedViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"

@interface FeedViewController ()
@property CGFloat currentY;
@property (nonatomic,retain) DetailViewController *detailViewController;
@property (nonatomic,retain) NSMutableArray *blockViews;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation FeedViewController
@synthesize detailViewController = _detailViewController;
@synthesize blockViews = _blockViews;
@synthesize mainScrollView = _mainScrollView;
@synthesize currentY = _currentY;

#define VIEW_WIDTH 320
#define VIEW_HEIGHT 158 

#define THUMB_X 10
#define THUMB_Y 4
#define THUMB_SIZE 50

#define BACKGROUND_Y 25
#define BACKGROUND_HEIGHT 137

#define TITLE_Y 4
#define TITLE_WIDTH 311

#define USERNAME_X 58
#define USERNAME_Y 3
#define USERNAME_WIDTH 42
#define USERNAME_HEIGHT 21

#define ACTION_X 98
#define ACTION_WIDTH 100

#define TITLENAME_X 58
#define TITLENAME_Y 18
#define TITLENAME_WIDTH 237
#define TITLENAME_HEIGHT 21


#define ICON_SIZE 20
#define JOIN_X 13
#define FAVOR_X 263
#define ICON_Y 130

#define LABEL_WIDTH 24
#define JOIN_LABEL_X 40
#define FAVOR_LABEL_X 289


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)blockViews {
    if (_blockViews == nil) {
        _blockViews = [[NSMutableArray alloc] init];
    }
    return _blockViews;
}

#pragma mark - View Life Circle

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //........towards right Gesture recogniser for swiping.....// usded to change view
    UISwipeGestureRecognizer* rightRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction =UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightRecognizer];
    //........towards left Gesture recogniser for swiping.....// used to change view
    UISwipeGestureRecognizer* leftRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;[leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer]; 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	_detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailPageNavigationController"];
    
    _currentY = 5;/*****TODO*****/
    
    //Block View
    UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(0, _currentY, VIEW_WIDTH, VIEW_HEIGHT)];
    [_mainScrollView addSubview:blockView];
    [self.blockViews addObject:blockView];
    
    //Gesture Recognizer
    blockView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlock:)];
    [blockView addGestureRecognizer:tapGR];
    
    
    //Background Image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BACKGROUND_Y + _currentY, VIEW_WIDTH, BACKGROUND_HEIGHT)];
    backgroundImageView.image = [UIImage imageNamed:@"monterey.jpg"]; /*****TODO*****/
    [blockView addSubview:backgroundImageView];
    
        
    //Title View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(THUMB_X, THUMB_Y+_currentY, TITLE_WIDTH, THUMB_SIZE)];
    titleView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.72];
    [blockView addSubview:titleView];
    
    //Thumbnail Image
    UIImageView *thumbNailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, THUMB_SIZE, THUMB_SIZE)];
    thumbNailImageView.image = [UIImage imageNamed:@"profile1.jpg"]; /*****TODO*****/
    [self setShadow:thumbNailImageView.layer];    
    //thumbNailImageView.layer.borderWidth = 3.f;
    //thumbNailImageView.layer.borderColor = [[UIColor grayColor] CGColor];    
    [titleView addSubview:thumbNailImageView];

    //User name
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(USERNAME_X, USERNAME_Y+_currentY, USERNAME_WIDTH, USERNAME_HEIGHT)];
    usernameLabel.text = @"Cindy";
    usernameLabel.font = [UIFont boldSystemFontOfSize:13.0];
    usernameLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    usernameLabel.textColor = [UIColor blackColor];
    [titleView addSubview:usernameLabel];
    
    //Action name
    UILabel *actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(ACTION_X, USERNAME_Y+_currentY, ACTION_WIDTH, USERNAME_HEIGHT)];
    actionLabel.text = @"wants to go to";
    actionLabel.font = [UIFont systemFontOfSize:13.0];
    actionLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    actionLabel.textColor = [UIColor blackColor];
    [titleView addSubview:actionLabel];

    //Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLENAME_X, TITLENAME_Y+_currentY, TITLENAME_WIDTH, TITLENAME_HEIGHT)];
    titleLabel.text = @"World Ocean's Day Celebration"; /*****TODO*****/
    titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    titleLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    [titleView addSubview:titleLabel];
    
    //Joined Image
    UIImageView *joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(JOIN_X, ICON_Y + _currentY, ICON_SIZE, ICON_SIZE)];
    joinImageView.image = [UIImage imageNamed:@"join.png"];
    [self setShadow:joinImageView.layer];
    [blockView addSubview:joinImageView];
    
    //Joined number label
    UILabel *joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(JOIN_LABEL_X, ICON_Y + _currentY, LABEL_WIDTH, ICON_SIZE)];
    joinLabel.text = @"25"; /*****TODO*****/
    joinLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    joinLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    joinLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [self setShadow:joinLabel.layer];
    [blockView addSubview:joinLabel];
    
    //Favored Image
    UIImageView *favorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(FAVOR_X, ICON_Y + _currentY, ICON_SIZE, ICON_SIZE)];
    favorImageView.image = [UIImage imageNamed:@"heart-white.png"];
    [self setShadow:favorImageView.layer];
    [blockView addSubview:favorImageView];
    
    //Favored Label
    UILabel *favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(FAVOR_LABEL_X, ICON_Y + _currentY, LABEL_WIDTH, ICON_SIZE)];
    favorLabel.text = @"25"; /*****TODO*****/
    favorLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    favorLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    favorLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [self setShadow:favorLabel.layer];
    [blockView addSubview:favorLabel];
    
    [self.view reloadInputViews];
	// Do any additional setup after loading the view.
}

- (void)setShadow:(CALayer *)layer {
    layer.shadowRadius = 2.f;
    layer.shadowOpacity = .50f;
    layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shouldRasterize = YES;
    layer.masksToBounds = NO;
}

- (void)tapBlock:(UITapGestureRecognizer *)tapGR {
    //int index = [_blockViews indexOfObject:tapGR.view];
    self.detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.detailViewController animated:YES completion:^{}];
}


- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Aotorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Gesture handler
-(void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer{
    //right swipe need to change to the left view
    // Get the views.
    int controllerIndex=0;
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    // Position it off screen.
    toView.frame = CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
    [UIView animateWithDuration:0.4 
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.tabBarController.selectedIndex = controllerIndex;                
                         }
                     }];
}

-(void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer{
    //left swipe need to change to the right view
    // Get the views.
    int controllerIndex=2;
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    // Position it off screen.
    toView.frame = CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
    [UIView animateWithDuration:0.4 
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.tabBarController.selectedIndex = controllerIndex;                
                         }
                     }];
}

@end
