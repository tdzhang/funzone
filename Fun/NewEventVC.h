//
//  NewEventVC.h
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "MapViewController.h"
#include "ChoosePeopleToGoTableViewController.h"
#include "TimeChooseViewController.h"
#include "FeedBackToCreateActivityChange.h"

@interface NewEventVC : UIViewController<SelfChooseLocation,UIActionSheetDelegate,TimeChooseProtocal,FeedBackToCreateActivityChange>

@end
