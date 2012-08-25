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
#import "ASIFormDataRequest.h"
#import "FunAppDelegate.h"

@interface FindFriendTableViewCell : UITableViewCell<FBRequestDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *friendImageView;
@property (weak, nonatomic) IBOutlet UILabel *friendName;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property(weak,nonatomic)SearchedFriend *relatedFriend;

@property(nonatomic,strong) NSString * actionCategory;

@property(nonatomic,strong) NSString* user_name;
@property(nonatomic,strong) NSString* user_pic;
@property(nonatomic,strong) NSString* fb_id;
@property(nonatomic) BOOL registerd;
@property(nonatomic,strong) NSString* user_id; //if the user is not registered, there will be no user_id
@property(nonatomic) BOOL followed; //the bool indicate the follow status
@property(nonatomic) int via;

-(void)resetWithSearchedFriend:(SearchedFriend *)friend;
-(void)resetWithTopFriend:(SearchedFriend *)friend;
@end
