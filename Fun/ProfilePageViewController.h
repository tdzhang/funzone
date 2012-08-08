//
//  ProfilePageViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "ProfileEventElement.h"
#import "GlobalConstant.h"
#import "MyFollowerTableViewController.h"

@interface ProfilePageViewController : UIViewController<UIScrollViewDelegate>

//used to keep server log
@property(nonatomic)int via;
@end
