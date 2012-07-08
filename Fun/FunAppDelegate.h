//
//  FunAppDelegate.h
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"

@class FunFirstViewController;

@interface FunAppDelegate : UIResponder <UIApplicationDelegate, FBSessionDelegate> {
    Facebook *facebook;
}

@property (strong, nonatomic) UIWindow *window;
@property (retain, nonatomic) IBOutlet FunFirstViewController *viewController;
@property (strong, nonatomic) Facebook *facebook;

@end
