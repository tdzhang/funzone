//
//  PushNotificationHandler.h
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import <Foundation/Foundation.h>

@interface PushNotificationHandler : NSObject

//handle the received push notification userInfo
+(void)ProcessNotificationUserInfo:(NSDictionary*)userInfo;
//After update the token, send to the server
+(void)SendeAPNStokenToServer:(NSString*) newToken;

@end
