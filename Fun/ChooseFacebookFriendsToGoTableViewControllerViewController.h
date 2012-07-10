//
//  ChooseFacebookFriendsToGoTableViewControllerViewController.h
//  Fun
//
//  Created by Tongda Zhang on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookContactObject.h"
#import "FBConnect.h"
#import "FunAppDelegate.h"

@protocol FeedBackToFaceBookFriendToGoChange 
-(void)AddFacebookContactTogoInformtionToPeopleList:(FacebookContactObject*)person;
-(void)DeleteFacebookContactTogoInformtionToPeopleList:(FacebookContactObject*)person;

@end

@interface ChooseFacebookFriendsToGoTableViewControllerViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate,FBRequestDelegate>
@property(nonatomic, weak) id<FeedBackToFaceBookFriendToGoChange> delegate;
@property(nonatomic,strong) NSDictionary *alreadySelectedContacts;
@end
