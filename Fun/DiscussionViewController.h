//
//  DiscussionViewController.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/17/12.
//
//

#import <UIKit/UIKit.h>
#import "ProfileInfoElement.h"
#import "Cache.h"
#import "GlobalConstant.h"

@interface DiscussionViewController : UIViewController
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id withEventTitle:(NSString *)event_title withEventTime:(NSString*)event_time withLocationName:(NSString*)location_name withInvitees:(NSMutableArray*)invitee andSetIsOwner:(BOOL)isOwner;
@end
