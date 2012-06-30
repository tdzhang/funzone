//
//  TimeChooseViewController.m
//  TimeAndDatePicker
//
//  Created by Tongda Zhang on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TimeChooseViewController.h"

@implementation TimeChooseViewController
@synthesize buttonChoose = _buttonChoose;
@synthesize datePicker=_datePicker;
@synthesize delegate=_delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark -action of the datepicker
- (IBAction)ValueChanged:(UIDatePicker*)sender {
    //NSLog(@"cool");
    //NSDate *date=sender.date;
    //NSLog(@"%@",date);
    [self.buttonChoose setEnabled:YES];
    [self.buttonChoose setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    /*
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit | NSHourCalendarUnit|NSMinuteCalendarUnit) fromDate:date];
    NSInteger day = [weekdayComponents day];
    NSInteger weekday = [weekdayComponents weekday];
    NSInteger year= [weekdayComponents year];
    NSInteger month=[weekdayComponents month];
    NSInteger hour = [weekdayComponents hour];
    NSInteger minute = [weekdayComponents minute];
    NSLog(@"%d:%d:%d weekday%d  =>%d:%d",year,month,day,weekday,hour,minute);
     */

}
	
#pragma mark - action of the button
- (IBAction)DecideToChoose:(UIButton*)sender {
    [self.delegate ChangedTheNSDate:self.datePicker.date SendFrom:sender];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)DecideToCancel:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    NSDate *now=[NSDate date];
    self.datePicker.minimumDate=now;
}
/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setButtonChoose:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
