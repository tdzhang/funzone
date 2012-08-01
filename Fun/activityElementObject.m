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
@synthesize shared_event_id=_shared_event_id;

+(NSMutableArray*)getActivityElementsArrayByJson:(NSArray*)json{
    NSMutableArray* temp_array=[NSMutableArray array];
    for (NSDictionary *element in json) {
        activityElementObject *activity=[activityElementObject new];
        NSString* type=[element objectForKey:@"type"];
        NSString* user_id=[NSString stringWithFormat:@"%@",[element objectForKey:@"user_id"]];
        NSString* user_name=[element objectForKey:@"user_name"];
        NSString* user_pic=[element objectForKey:@"user_pic"];
        NSString* event_id=[element objectForKey:@"event_id"];
        NSString* shared_event_id=[NSString stringWithFormat:@"%@",[element objectForKey:@"shared_event_id"]];
        activity.type=type;
        activity.user_id=user_id;
        activity.user_name=user_name;
        activity.user_pic=user_pic;
        activity.event_id=event_id;
        activity.shared_event_id=shared_event_id;
        [temp_array addObject:activity];
    }
    return temp_array;
}
@end


