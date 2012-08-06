//
//  InviteFriendObject.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/5/12.
//
//

#import <Foundation/Foundation.h>

@interface InviteFriendObject : NSObject
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *user_pic;
@property (nonatomic,strong) NSString *facebook_id;
@property (nonatomic) BOOL followed;

+(NSArray*)generateProfileInfoElementArrayFromJson:(NSArray*)json;
@end
