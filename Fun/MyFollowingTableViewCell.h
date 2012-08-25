//
//  MyFollowingTableViewCell.h
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//
//

#import <UIKit/UIKit.h>
#import "MyFollowingTableViewController.h"
#import "FollowingOrErLookProfileDelegate.h"

@interface MyFollowingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *unfollowButton;

@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *user_pic;
@property (nonatomic,strong) NSString *facebook_id;

@property(nonatomic,weak) id<FollowingOrErLookProfileDelegate>delegate;

@end
