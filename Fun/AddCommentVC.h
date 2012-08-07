//
//  AddCommentVC.h
//  Fun
//
//  Created by Tongda Zhang on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "addAndViewCommentTVC.h"
#import "ASIFormDataRequest.h"
#import "LoginPageViewController.h"
#import "GlobalConstant.h"

@interface AddCommentVC : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) NSArray *comments;

//used for server log
@property (nonatomic)int via;
@end
