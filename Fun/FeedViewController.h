//
//  FeedViewController.h
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExploreBlockElement.h"
#import "Cache.h"
#import "OtherProfilePageViewController.h"
#import "GlobalConstant.h"
#import "ProfilePageViewController.h"

@interface FeedViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *instructionView;

@end