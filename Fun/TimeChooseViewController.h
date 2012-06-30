//
//  TimeChooseViewController.h
//  TimeAndDatePicker
//
//  Created by Tongda Zhang on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimeChooseViewController;

@protocol TimeChooseProtocal
        
-(void)ChangedTheNSDate:(NSDate*)date SendFrom:(UIButton*)sender;

@end

@interface TimeChooseViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *buttonChoose;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id<TimeChooseProtocal>delegate;
@end
