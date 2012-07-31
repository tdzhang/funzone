//
//  MoreTableViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/27/12.
//
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FunAppDelegate.h"
#import "GlobalConstant.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface MoreTableViewController : UITableViewController<UIAlertViewDelegate,FBRequestDelegate>
-(void)likeUsOnFaceBook;
@end
