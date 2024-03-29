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
@property (nonatomic,strong) NSString *email;
@property (nonatomic) BOOL followed;

+(NSArray*)generateProfileInfoElementArrayFromJson:(NSArray*)json;
+(NSArray*)generateProfileInfoElementArrayFromAddressBookInfo:(NSArray*)json;
@end
