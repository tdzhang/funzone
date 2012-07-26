//
//  ProfileInfoElement.h
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//
//

#import <UIKit/UIKit.h>

@interface ProfileInfoElement : NSObject
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *user_pic;
@property (nonatomic,strong) NSString *facebook_id;

+(NSArray*)generateProfileInfoElementArrayFromJson:(NSArray*)json;
@end
