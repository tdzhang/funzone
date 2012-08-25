//
//  MyFollowingTableViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//
//

#import <UIKit/UIKit.h>
#import "MyFollowingTableViewCell.h"
#import "ProfileInfoElement.h"
#import "ASIFormDataRequest.h"
#import "GlobalConstant.h"
#import "Cache.h"
#import "FollowingOrErLookProfileDelegate.h"
#import "ProfilePageViewController.h"
#import "OtherProfilePageViewController.h"


@interface MyFollowingTableViewController : UITableViewController<FollowingOrErLookProfileDelegate>
@property(nonatomic,strong)NSString* other_user_id; //if the request is to check other user's following, this would be the indicator
@end
