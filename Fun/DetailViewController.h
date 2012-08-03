//
//  DetailViewController.h
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareAfterNewEventViewController.h"
#include "FeedBackToCreateActivityChange.h"
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "FunAppDelegate.h"
#import "NewEventVC.h"
#import "eventComment.h"
#import "AddCommentVC.h"
#import "ProfileInfoElement.h"
#import "Cache.h"
#import "GlobalConstant.h"
#import "OtherProfilePageViewController.h"

@interface DetailViewController : UIViewController<UIActionSheetDelegate,FeedBackToCreateActivityChange,MFMessageComposeViewControllerDelegate,FBRequestDelegate>

@property(nonatomic,weak)id<WEICHATprotocal>delegate;
@property (weak, nonatomic) IBOutlet UIButton *interestOrInviteButton;
@property (weak, nonatomic) IBOutlet UIButton *pickOrEditButton;
//@property (weak, nonatomic) IBOutlet UIButton *shareButton;

//(this method is called by the explorer page before loading to set the event id and shared event id)
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id andSetIsOwner:(BOOL)isOwner;
//server log need method
-(void)preSetServerLogViaParameter:(int)via;
@end
