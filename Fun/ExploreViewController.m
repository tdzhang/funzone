//
//  ExploreViewController.m
//  Fun
//
//  Created by He Yang on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ExploreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"


@interface ExploreViewController ()
@property CGFloat currentY;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) DetailViewController *detailViewController;
@property (nonatomic,retain) NSMutableArray *blockViews;
@end

@implementation ExploreViewController
@synthesize detailViewController = _detailViewController;
@synthesize blockViews = _blockViews;
@synthesize currentY = _currentY;
@synthesize mainScrollView = _mainScrollView;

#define VIEW_WIDTH 320
#define VIEW_HEIGHT 158 

#define THUMB_X 10
#define THUMB_Y 4
#define THUMB_SIZE 50

#define BACKGROUND_Y 25
#define BACKGROUND_HEIGHT 137

#define TITLE_X 60
#define TITLE_Y 16
#define TITLE_WIDTH 260
#define TITLE_HEIGHT 36
#define TITLE_TEXT_OFFSET 8

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
        
        
    }
    return self;
}

- (NSMutableArray *)blockViews {
    if (_blockViews == nil) {
        _blockViews = [[NSMutableArray alloc] init];
    }
    return _blockViews;
}

- (DetailViewController *)detailViewController {
    if (_detailViewController == nil) {
        _detailViewController = [[DetailViewController alloc] init];
    }
    return _detailViewController;
}


#pragma mark - View Life circle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    //........towards left Gesture recogniser for swiping.....// used to change view
    UISwipeGestureRecognizer* leftRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;[leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer]; 
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    //Thumbnail Image
    UIImageView *thumbNailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(THUMB_X, THUMB_Y + _currentY, THUMB_SIZE, THUMB_SIZE)];
    thumbNailImageView.image = [UIImage imageNamed:@"monterey.jpg"]; /*****TODO*****/
    [self setShadow:thumbNailImageView.layer];    
    thumbNailImageView.layer.borderWidth = 3.f;
    thumbNailImageView.layer.borderColor = [[UIColor grayColor] CGColor];    
    [blockView addSubview:thumbNailImageView];
    
    //Title View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(TITLE_X, TITLE_Y+_currentY, TITLE_WIDTH, TITLE_HEIGHT)];
    titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.56];
    [blockView addSubview:titleView];
    
    //Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_TEXT_OFFSET, 0, TITLE_WIDTH-2*TITLE_TEXT_OFFSET, TITLE_HEIGHT)];
    titleLabel.text = @"World Ocean's Day Celebration"; /*****TODO*****/
    titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Gurmukhi MN" size:14.0];
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
    /*layer.shadowRadius = 2.f;
    layer.shadowOpacity = .50f;
    layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shouldRasterize = YES;
    layer.masksToBounds = NO;
     */
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


#pragma mark - autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Gesture handler
-(void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer{
    //left swipe need to change to the right view
    // Get the views.
    int controllerIndex=1;
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
