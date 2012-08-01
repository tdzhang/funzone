//
//  OtherProfilePageViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"
#import "ProfileEventElement.h"
#import "MyFollowingTableViewController.h"

@interface OtherProfilePageViewController : UIViewController<UIScrollViewDelegate>

@property(nonatomic,strong)NSString *creator_id;

@end
