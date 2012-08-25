//
//  MyFollowerTableViewController.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/6/12.
//
//

#import <UIKit/UIKit.h>
#import "MyFollowingTableViewCell.h"
#import "ProfileInfoElement.h"
#import "ASIFormDataRequest.h"
#import "GlobalConstant.h"
#import "Cache.h"
#import "ProfilePageViewController.h"
#import "OtherProfilePageViewController.h"

@interface MyFollowerTableViewController : UITableViewController<FollowingOrErLookProfileDelegate>
@property(nonatomic,strong)NSString* other_user_id; //if the request is to check other user's following, this would be the indicator
@end
