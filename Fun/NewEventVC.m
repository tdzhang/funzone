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


#pragma mark - Constant Value Declarition
#define TOP_RIGHT_VIEW_WIDTH 72
#define TOP_RIGHT_VIEW_HEIGHT 79


#pragma mark - NewEventVC Private Declarition 
@interface NewEventVC () <UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldEventTitle;
@property (weak, nonatomic) IBOutlet UITextView *textViewEventDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventPhoto;
@property (weak, nonatomic) IBOutlet UIButton *buttonChooseEventLocation;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventPrice;
@property (weak, nonatomic) IBOutlet UIButton *buttonEventFriends;

@end

//////////////////////////////////////

@implementation NewEventVC
@synthesize textFieldEventTitle = _eventTitleTextField;
@synthesize textViewEventDescription = _eventDescriptionTextView;
@synthesize buttonChooseEventPhoto = _buttonChooseEventPhoto;
@synthesize buttonChooseEventLocation = _buttonChooseEventLocation;
@synthesize buttonEventTime = _eventTimeButton;
@synthesize buttonEventPrice = _eventPriceButton;
@synthesize buttonEventFriends = _eventFriendsButton;

#pragma mark - View lifecycle
- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setTextFieldEventTitle:nil];
    [self setTextViewEventDescription:nil];
    [self setButtonEventTime:nil];
    [self setButtonEventPrice:nil];
    [self setButtonEventFriends:nil];
    [self setButtonChooseEventPhoto:nil];
    [self setButtonChooseEventLocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - View AntoRotation Method

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Segues related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender 
{
    if([segue.identifier isEqualToString:@"ChooseFriends"]){
        
    }
    else if ([segue.identifier isEqualToString:@"chooseTime"]){
    }
    else if ([segue.identifier isEqualToString:@"ChooseLocationInMAP"]){
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            MapViewController *mapViewC=segue.destinationViewController;
            [mapViewC setDelegate:self];
        }
    }
}

#pragma mark - implement protocals
////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
-(void)UpdateLocation:(MKAnnotationView *)aView sendFrom:(MapViewController *)sender{
    MKPointAnnotation *annotation=aView.annotation;
    NSString *locationDescription=[NSString stringWithFormat:@"%@",annotation.title];
    //[self.buttonLocation setTitle:locationDescription forState:UIControlStateNormal];
    //[self.locationLabel setText:[NSString stringWithFormat:@"lati:%f; long%f",annotation.coordinate.latitude,annotation.coordinate.longitude]];
}


@end
