//
//  activityElementObject.h
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import <Foundation/Foundation.h>

@interface activityElementObject : NSObject
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSString* user_id;
@property (nonatomic,strong) NSString* user_name;
@property (nonatomic,strong) NSString* user_pic;
@property (nonatomic,strong) NSString* event_id;
@property (nonatomic,strong) NSString* shared_event_id;
@property (nonatomic,strong) NSString* event_name;
@property (nonatomic,strong) NSString *event_pic;
@property (nonatomic,strong) NSString* message;
@property (nonatomic,strong) NSNumber* unread_msg_num;
@property int isViewed;

+(NSMutableArray*)getActivityElementsArrayByJson:(NSArray*)json;
+(NSMutableArray*)getConversationActivityElementsArrayByJson:(NSArray*)json;
@end
