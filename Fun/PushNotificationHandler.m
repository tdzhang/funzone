//
//  PushNotificationHandler.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "PushNotificationHandler.h"

@implementation PushNotificationHandler

+(void)ProcessNotificationUserInfo:(NSDictionary *)userInfo{
    NSLog(@"did receive push notification %@",userInfo);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

+(void)SendeAPNStokenToServer:(NSString*) newToken{
    NSLog(@"send the apns token to the sever");
    //handle the new token
}

@end
