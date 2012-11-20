//
//  activityElementObject.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import "activityElementObject.h"

@implementation activityElementObject
@synthesize type=_type;
@synthesize user_id=_user_id;
@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize event_id=_event_id;
@synthesize event_pic=_event_pic;
@synthesize shared_event_id=_shared_event_id;
@synthesize isViewed=_isViewed;
@synthesize unread_msg_num=_unread_msg_num;

@synthesize event_name=_event_name;
@synthesize message=_message;

+(NSMutableArray*)getActivityElementsArrayByJson:(NSArray*)json{
    NSMutableArray* temp_array=[NSMutableArray array];
    for (NSDictionary *element in json) {
        activityElementObject *activity=[activityElementObject new];
        NSString* type=[element objectForKey:@"type"];
        NSString* user_id=[NSString stringWithFormat:@"%@",[element objectForKey:@"user_id"]];
        NSString* user_name=[element objectForKey:@"user_name"];
        NSString* user_pic=[element objectForKey:@"user_pic"];
        NSString* event_id=[element objectForKey:@"event_id"];
        NSString* photo_url=[element objectForKey:@"photo_url"];
        NSString* shared_event_id=[NSString stringWithFormat:@"%@",[element objectForKey:@"shared_event_id"]];
        activity.type=type;
        activity.user_id=user_id;
        activity.user_name=user_name;
        activity.user_pic=user_pic;
        activity.event_id=event_id;
        activity.shared_event_id=shared_event_id;
        activity.event_pic=photo_url;
        
        [temp_array addObject:activity];
    }
    return temp_array;
}

+(NSMutableArray*)getConversationActivityElementsArrayByJson:(NSArray*)json{
    NSMutableArray* temp_array=[NSMutableArray array];
    for (NSDictionary *element in json) {
        activityElementObject *activity=[activityElementObject new];
        NSString* type=@"conversation";
        NSString* event_name=[NSString stringWithFormat:@"%@",[element objectForKey:@"title"]];
        NSString* user_name=[element objectForKey:@"user_name"];
        NSString* message=[element objectForKey:@"message_content"];
        NSString* event_id=[element objectForKey:@"event_id"];
        NSString* photo_url=[element objectForKey:@"photo_url"];
        NSString* shared_event_id=[NSString stringWithFormat:@"%@",[element objectForKey:@"shared_event_id"]];
        
        activity.type=type;
        activity.user_name=user_name;
        activity.event_name=event_name;
        activity.message=message;
        activity.event_id=event_id;
        activity.event_pic=photo_url;
        activity.shared_event_id=shared_event_id;
        activity.isViewed=[[element objectForKey:@"viewed"] integerValue];
        activity.unread_msg_num=[element objectForKey:@"num_unread"];
        NSLog(@"%@",activity.unread_msg_num);
        
        [temp_array addObject:activity];
    }
    return temp_array;
}
@end


