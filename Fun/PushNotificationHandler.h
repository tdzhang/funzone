//
//  PushNotificationHandler.h
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import <Foundation/Foundation.h>

@interface PushNotificationHandler : NSObject
//fetching notification from server
+(void)StartFetchingNotificationsFromServer;

//make the badeg number of activity adn application same
+(void)synTheBadgeNumberOfActivityAndAllpication:(UITabBarController*)myTabBarController;

//handle the received push notification userInfo
+(void)ProcessNotificationUserInfo:(NSDictionary*)userInfo ChangeTabBarController:(UITabBarController*)myTabBarController;

//After update the token, send to the server
+(void)SendeAPNStokenToServer:(NSString*) newToken;

//clear the pushnotification numbver
+(void)clearApplicationPushNotifNumber;
@end
