//
//  SearchedFriend.h
//  Fun
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import <Foundation/Foundation.h>

@interface SearchedFriend : NSObject

@property(nonatomic,strong) NSString* user_name;
@property(nonatomic,strong) NSString* user_pic;
@property(nonatomic,strong) NSString* fb_id;
@property(nonatomic) BOOL registerd;
@property(nonatomic,strong) NSString* user_id; //if the user is not registered, there will be no user_id
@property(nonatomic) BOOL followed; //the bool indicate the follow status

+(NSArray *)SearchedFriendsWithJson:(NSArray *)json;

@end
