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
@interface FunAppDelegate : UIResponder  

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Facebook *facebook;
@end
