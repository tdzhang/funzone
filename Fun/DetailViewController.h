//
//  DetailViewController.h
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewEventVC.h"
#import "eventComment.h"
#import "AddCommentVC.h"
#import "ProfileInfoElement.h"
#import "Cache.h"
#import "GlobalConstant.h"

@interface DetailViewController : UIViewController
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id;
@end
