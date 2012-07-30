//
//  FindFriendTableViewCell.h
//  Fun
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import <UIKit/UIKit.h>
#import "SearchedFriend.h"
#import "Cache.h"
#import "GlobalConstant.h"

@interface FindFriendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
-(void)resetWithSearchedFriend:(SearchedFriend *)friend;
@end
