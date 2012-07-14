//
//  DetailViewController.m
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contributorProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *contributorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventLocationDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventIntroLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@end

@implementation DetailViewController
@synthesize contributorProfileImageView;
@synthesize contributorNameLabel;
@synthesize timestampLabel;
@synthesize eventTitleLabel;
@synthesize eventLocationLabel;
@synthesize eventLocationDistanceLabel;
@synthesize eventTimeLabel;
@synthesize eventPriceLabel;
@synthesize eventIntroLabel;
@synthesize myScrollView;

#pragma mark - View Life Circle
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
    [self setContributorProfileImageView:nil];
    [self setContributorNameLabel:nil];
    [self setTimestampLabel:nil];
    [self setEventTitleLabel:nil];
    [self setEventLocationLabel:nil];
    [self setEventLocationDistanceLabel:nil];
    [self setEventTimeLabel:nil];
    [self setEventPriceLabel:nil];
    [self setEventIntroLabel:nil];
    [self setMyScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.myScrollView setContentSize:CGSizeMake(320, 1000)];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
