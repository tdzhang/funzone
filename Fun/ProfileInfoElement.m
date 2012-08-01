//
//  ProfileInfoElement.m
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//
//

#import "ProfileInfoElement.h"

@implementation ProfileInfoElement
@synthesize user_id=_user_id;
@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize facebook_id=_facebook_id;
@synthesize followed=_followed;

+(NSArray*)generateProfileInfoElementArrayFromJson:(NSArray*)json{
    NSMutableArray *profileArray=[NSMutableArray array];
    for (NSDictionary *user in json) {
        ProfileInfoElement* element=[[ProfileInfoElement alloc] init];
        element.user_id=[NSString stringWithFormat:@"%@",[user objectForKey:@"user_id"]];
        element.user_name=[NSString stringWithFormat:@"%@",[user objectForKey:@"user_name"]];
        element.user_pic=[NSString stringWithFormat:@"%@",[user objectForKey:@"user_pic"]];
        element.facebook_id=[NSString stringWithFormat:@"%@",[user objectForKey:@"facebook_id"]];
        if ([[NSString stringWithFormat:@"%@",[user objectForKey:@"followed"]] isEqualToString:@"0"] ) {
            //not followed
            element.followed=NO;
        } else {
            element.followed=YES;
        }
        [profileArray addObject:element];
    }
    return profileArray;
}
@end

