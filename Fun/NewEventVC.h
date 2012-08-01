//
//  NewEventVC.h
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MapViewController.h"
#include "TimeChooseViewController.h"
#include "FeedBackToCreateActivityChange.h"
#import "ChooseImageTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "FunAppDelegate.h"
#import "MovieAotoCompletionVC.h"
#import "ASIFormDataRequest.h"
#import "Cache.h"
#import <Twitter/Twitter.h>
#import "LoginPageViewController.h"
#import "GlobalConstant.h"
#import "ShareAfterNewEventViewController.h"

<<<<<<< HEAD
@interface NewEventVC : UIViewController<SelfChooseLocation,UIActionSheetDelegate,TimeChooseProtocal,UITextFieldDelegate,ChooseImageFeedBackDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,movieInfoReturn,FBRequestDelegate>
=======
@interface NewEventVC : UIViewController<SelfChooseLocation,UIActionSheetDelegate,TimeChooseProtocal,UITextFieldDelegate,ChooseImageFeedBackDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,movieInfoReturn>{
    UITextView *textView;
	UIToolbar *keyboardToolbar;
}
>>>>>>> add keyboard toolbar

@property (nonatomic,strong) NSString *eventType;//used to differentiate the different style for different event category.
@property (nonatomic,strong) MKPointAnnotation *predefinedAnnotation; //used to store the location infomation that need to show when the location part is segued
-(void)repinTheEventWithEventID:(NSString *)event_id sharedEventID:(NSString *)shared_event_id creatorID:(NSString*)creator_id eventTitle:(NSString *)event_title eventTime:(NSString *)event_time eventImage:(UIImage *)event_image locationName:(NSString *)location_name address:(NSString*)address longitude:(NSNumber *)longitude  latitude:(NSNumber *)latitude description:(NSString *)description;
@end
