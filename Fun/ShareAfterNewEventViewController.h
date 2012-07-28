//
//  ShareAfterNewEventViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/28/12.
//
//

#import <UIKit/UIKit.h>
#include "ChoosePeopleToGoTableViewController.h"
#include "FeedBackToCreateActivityChange.h"
#import "ChooseImageTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "FunAppDelegate.h"
#import "ChooseFacebookFriendsToGoTableViewControllerViewController.h"
#import "ASIFormDataRequest.h"
#import "Cache.h"
#import <Twitter/Twitter.h>
#import "LoginPageViewController.h"
#import "GlobalConstant.h"
@interface ShareAfterNewEventViewController : UIViewController<FBRequestDelegate,FeedBackToCreateActivityChange,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>

-(void)presetEventImage:(UIImage*)createEvent_image WithTiTle:(NSString*)createEvent_title WithLatitude:(NSString*)createEvent_latitude WithLongitude:(NSString*)createEvent_longitude WithLocationName:(NSString*)createEvent_locationName WithTime:(NSString*)createEvent_time WithAddress:(NSString*)createEvent_address WithImageUrlName:(NSString*)createEvent_imageUrlName;
@end
