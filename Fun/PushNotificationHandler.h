//
//  PushNotificationHandler.h
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"
#import "GlobalConstant.h"

@interface PushNotificationHandler : NSObject

//make the badeg number of activity adn application same
+(void)synTheBadgeNumberOfActivityAndAllpication:(UITabBarController*)myTabBarController;

//make the badeg number equal to the userinfo
+(void)synTheBadgeNumberOfActivityAndAllpication:(UITabBarController*)myTabBarController withUserInfo:(NSDictionary *)userInfo;


//handle the received push notification userInfo
+(void)ProcessNotificationUserInfo:(NSDictionary*)userInfo ChangeTabBarController:(UITabBarController*)myTabBarController;

//After update the token, send to the server
+(void)SendeAPNStokenToServer:(NSString*) newToken;

//clear the pushnotification numbver
+(void)clearApplicationPushNotifNumber;

//send the last token to the server with token
+(void)SendAPNStokenToServer;
@end
