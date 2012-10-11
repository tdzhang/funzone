//
//  FunAppDelegate.h
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Cache.h"
#import "MyPermenentCachePart.h"
#import "WXApi.h"
#import "ShareAfterNewEventViewController.h"
#import "PushNotificationHandler.h"
#import <QuartzCore/QuartzCore.h>
#import "CategroyChooseViewController.h"
#import "GlobalConstant.h"
#import "PushNotificationHandler.h"

@class FunFirstViewController;

@interface FunAppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Facebook *facebook;
@property (strong, nonatomic) UITabBarController *thisTabBarController;
@property (nonatomic,strong) CLLocationManager *myLocationManager;
@property (nonatomic)BOOL myCollection_needrefresh;

@end
