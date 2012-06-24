//
//  NewEventVC.m
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewEventVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Event.h"

@interface NewEventVC () <UIActionSheetDelegate>

#define TOP_RIGHT_VIEW_WIDTH 72
#define TOP_RIGHT_VIEW_HEIGHT 79

@property (weak, nonatomic) IBOutlet UITextField *eventTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *eventDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *eventImageView;
@property (weak, nonatomic) IBOutlet UIImageView *eventLocationImageView;
@property (weak, nonatomic) IBOutlet UIButton *eventTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *eventPriceButton;
@property (weak, nonatomic) IBOutlet UIButton *eventFriendsButton;

@property (nonatomic) UIActionSheet *timeActionSheet;


@end


@implementation NewEventVC
@synthesize eventTitleTextField = _eventTitleTextField;
@synthesize eventDescriptionTextView = _eventDescriptionTextView;
@synthesize eventImageView = _eventImageView;
@synthesize eventLocationImageView = _eventLocationImageView;
@synthesize eventTimeButton = _eventTimeButton;
@synthesize eventPriceButton = _eventPriceButton;
@synthesize eventFriendsButton = _eventFriendsButton;

@synthesize timeActionSheet = _timeActionSheet;


- (IBAction)eventTimeButtonPressed:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select time for the activity" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Today",@"Tomorrow",nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    _timeActionSheet = actionSheet;
}

- (IBAction)eventPriceButtonPressed:(UIButton *)sender {
    
}

- (IBAction)eventFriendsButtonPressed:(UIButton *)sender {
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet == _timeActionSheet) {
        switch (buttonIndex) {
            case 0:
                _eventTimeButton.titleLabel.text = @"Today";
                break;
            case 1:
                _eventTimeButton.titleLabel.text = @"Tomorrow";
                break;
            default:
                break;
        }
    }
}

- (void)tapImage: (UITapGestureRecognizer *)gesture {
    
}

- (void)tapLocation: (UITapGestureRecognizer *)gesture {
    
}


- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];
    
    UITapGestureRecognizer *imageTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)];
    [_eventImageView addGestureRecognizer:imageTapGR];
    
    UITapGestureRecognizer *locationTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLocation:)];
    [_eventLocationImageView addGestureRecognizer:locationTapGR];
}
- (void)viewDidUnload
{
    [self setEventTitleTextField:nil];
    [self setEventDescriptionTextView:nil];
    [self setEventImageView:nil];
    [self setEventLocationImageView:nil];
    [self setEventTimeButton:nil];
    [self setEventPriceButton:nil];
    [self setEventFriendsButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
