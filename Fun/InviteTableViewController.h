//
//  InviteTableViewController.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/5/12.
//
//

#import <UIKit/UIKit.h>
#import "InviteFriendObject.h"
#import "GlobalConstant.h"
#import "ASIFormDataRequest.h"
#import "InviteFriendTableViewCell.h"

@interface InviteTableViewController : UITableViewController

@property(nonatomic,strong) NSDictionary *alreadySelectedContacts;

@end
