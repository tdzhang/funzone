//
//  LoginPageViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FunAppDelegate.h"
#import "CategroyChooseViewController.h"

@interface LoginPageViewController : UIViewController<UIAlertViewDelegate>
@property (weak,nonatomic) UIViewController* parentVC; //the parent view controller
@end
