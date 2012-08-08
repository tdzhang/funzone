//
//  SearchedFriend.m
//  Fun
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "SearchedFriend.h"

@implementation SearchedFriend

@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize fb_id=_fb_id;
@synthesize registerd=_registerd;
@synthesize user_id=_user_id;
@synthesize followed=_followed;

+(NSArray *)SearchedFriendsWithJson:(NSArray *)json{
    NSMutableArray *friends=[NSMutableArray array];
    for (NSDictionary* element in json) {
        SearchedFriend *friend=[SearchedFriend new];
        friend.user_name=[element objectForKey:@"user_name"];
        friend.user_pic=[element objectForKey:@"user_pic"];
        friend.fb_id=[element objectForKey:@"fb_id"];
        NSLog(@"%@",[element objectForKey:@"registered"]);
        if ([[NSString stringWithFormat:@"%@",[element objectForKey:@"registered"]] isEqualToString:@"0"]) {
            friend.registerd=NO;
        }
        else{
            friend.registerd=YES;
            friend.user_id=[element objectForKey:@"user_id"];
            if ([[NSString stringWithFormat:@"%@",[element objectForKey:@"followed"]] isEqualToString:@"0"]) {
                friend.followed = NO;
            } else {
                friend.followed=YES;
            }
        }
        [friends addObject:friend];
    }
    return [friends copy];
}

+(NSArray *)TopFriendsWithJson:(NSArray *)json{
    NSMutableArray *friends=[NSMutableArray array];
    for (NSDictionary* element in json) {
        SearchedFriend *friend=[SearchedFriend new];
        friend.user_name=[element objectForKey:@"user_name"];
        friend.user_pic=[element objectForKey:@"user_pic"];
        friend.fb_id=[element objectForKey:@"fb_id"];
 
        friend.registerd=YES;
        friend.user_id=[element objectForKey:@"user_id"];
        if ([[NSString stringWithFormat:@"%@",[element objectForKey:@"followed"]] isEqualToString:@"0"]) {
            friend.followed = NO;
        } else {
            friend.followed=YES;
        }
            
        [friends addObject:friend];
    }
    return [friends copy];
}

@end
