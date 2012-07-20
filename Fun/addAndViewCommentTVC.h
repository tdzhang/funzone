//
//  addAndViewCommentTVC.h
//  Fun
//
//  Created by Tongda Zhang on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "commentTableViewCell.h"
#import "eventComment.h"

@interface addAndViewCommentTVC : UITableViewController
@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) NSArray *comments;
@end
