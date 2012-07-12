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
#import "ChooseImageTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "FBConnect.h"
#import "FunAppDelegate.h"
#import "ChooseFacebookFriendsToGoTableViewControllerViewController.h"
#import "MovieAotoCompletionVC.h"

@interface NewEventVC : UIViewController<SelfChooseLocation,UIActionSheetDelegate,TimeChooseProtocal,FeedBackToCreateActivityChange,FeedBackToFaceBookFriendToGoChange,UITextFieldDelegate,ChooseImageFeedBackDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MFMailComposeViewControllerDelegate,UITextViewDelegate,FBRequestDelegate,movieInfoReturn>

@property (nonatomic,strong) NSString *eventType;//used to differentiate the different style for different event category.
@end
