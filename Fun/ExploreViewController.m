//
//  ExploreViewController.m
//  Fun
//
//  Created by He Yang on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "ExploreViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface ExploreViewController ()
@property CGFloat currentY;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

@end

@implementation ExploreViewController
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Block View
    UIView *blockView = [[UIView alloc] initWithFrame:CGRectMake(0, _currentY, VIEW_WIDTH, VIEW_HEIGHT)];
    [_mainScrollView addSubview:blockView];
    
    //Background Image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, BACKGROUND_Y + _currentY, VIEW_WIDTH, BACKGROUND_HEIGHT)];
    backgroundImageView.image = [UIImage imageNamed:@"monterey.jpg"];
    [blockView addSubview:backgroundImageView];
    
    //Thumbnail Image
    UIImageView *thumbNailImageView = [[UIImageView alloc] initWithFrame:CGRectMake(THUMB_X, THUMB_Y + _currentY, THUMB_SIZE, THUMB_SIZE)];
    thumbNailImageView.image = [UIImage imageNamed:@"monterey.jpg"];
    thumbNailImageView.layer.shadowRadius = 2.f;
    thumbNailImageView.layer.shadowOpacity = .85f;
    thumbNailImageView.layer.shadowOffset = CGSizeMake(1.f, 1.f);
    thumbNailImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    thumbNailImageView.layer.shouldRasterize = YES;
    thumbNailImageView.layer.masksToBounds = NO;
    thumbNailImageView.layer.borderWidth = 3.f;
    thumbNailImageView.layer.borderColor = [[UIColor grayColor] CGColor];    
    [blockView addSubview:thumbNailImageView];
    
    //Title View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(TITLE_X, TITLE_Y, TITLE_WIDTH, TITLE_HEIGHT)];
    titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.56];
    [blockView addSubview:titleView];
    
    //Title Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_TEXT_OFFSET, 0, TITLE_WIDTH-2*TITLE_TEXT_OFFSET, TITLE_HEIGHT)];
    titleLabel.text = @"World Ocean's Day Celebration";
    titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Gurmukhi MN" size:14.0];
    //titleLabel.font = 
    [titleView addSubview:titleLabel];
    
    [self.view reloadInputViews];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
