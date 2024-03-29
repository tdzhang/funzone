//
//  InviteTableViewController.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/5/12.
//
//

#import <UIKit/UIKit.h>
#import "InviteFriendObject.h"
#import "GlobalConstant.h"
#import "ASIFormDataRequest.h"
#import <AddressBook/AddressBook.h>
#import "UserContactObject.h"
#import "MyContactsTableViewCell.h"
#import "InviteFriendTableViewCell.h"
#import "Cache.h"
#import "QuartzCore/QuartzCore.h"

@protocol FeedBackInviteFriendChange <NSObject>
@optional
//the method for choosing activity
-(void)UserSetupOnePropertyFrom:(UIButton*)sender
           WithPropertyCategory:(NSString*)kind
                    WithContent:(NSString*)content;

-(void)UserSetupUserDefinedPropertyFrom:(UIButton*)sender
                   WithPropertyCategory:(NSString*)kind
                            WithContent:(NSString*)content;
//the methods for choosing people to go out with
-(void)AddAddressBookContactInformtionToPeopleList:(UserContactObject*)person;
-(void)AddContactInformtionToPeopleList:(InviteFriendObject*)person;
-(void)DeleteAddressBookContactInformtionToPeopleList:(UserContactObject*)person;
-(void)DeleteContactInformtionToPeopleList:(InviteFriendObject*)person;
-(void)UpdateLastReceivedInviteFriendJson:(NSArray*)lastReceivedJson;

//method to invite friend to the sever
-(void)startInviteFriendWithEventID;
@end

@interface InviteTableViewController : UITableViewController

@property(nonatomic,strong) NSDictionary *alreadySelectedContacts;
@property(nonatomic,strong) NSDictionary *addressbook_alreadySelectedContacts;
@property(nonatomic,strong) id<FeedBackInviteFriendChange>delegate;
@property(nonatomic,strong)NSArray *lastReceivedJson;
@end
