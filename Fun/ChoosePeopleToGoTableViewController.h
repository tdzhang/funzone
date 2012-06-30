//
//  ChoosePeopleToGoTableViewController.h
//  SimpleChoosePage
//
//  Created by Tongda Zhang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "UserContactObject.h"
#import "MyContactsTableViewCell.h"
#import "ChoosePeopleToGoDelegate.h"




@interface ChoosePeopleToGoTableViewController : UITableViewController
//this delegate is used to add contact info to activity
@property(nonatomic, weak) id<ChoosePeopleToGoDelegate> delegate;
@property(nonatomic,strong) NSDictionary *alreadySelectedContacts;
@end
