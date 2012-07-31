//
//  PushNotificationHandler.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "PushNotificationHandler.h"

@implementation PushNotificationHandler

+(void)ProcessNotificationUserInfo:(NSDictionary *)userInfo ChangeTabBarController:(UITabBarController*)myTabBarController{
    NSLog(@"did receive push notification %@",userInfo);
    NSDictionary *aps=[userInfo objectForKey:@"aps"];
    
    [[myTabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@",[aps objectForKey:@"badge"]]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

+(void)SendeAPNStokenToServer:(NSString*) newToken{
    NSLog(@"send the apns token to the sever");
    //handle the new token
}

@end
