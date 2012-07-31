//
//  PushNotificationHandler.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "PushNotificationHandler.h"

@implementation PushNotificationHandler
static NSArray* notifications;
static bool isFetchingData=false;

+(void)StartFetchingNotificationsFromServer{
    isFetchingData=true;
    NSLog(@"fetching notification from server");
    //deal with notifications
#warning need to fetching notif from sever, and then set the isFetchingData to false, reload the activity data source
    //note: this action need to be make sure only called onece
}

+(void)synTheBadgeNumberOfActivityAndAllpication:(UITabBarController*)myTabBarController{
    //set the number of the tab bar
    if ([[UIApplication sharedApplication] applicationIconBadgeNumber]>0) {
        [[myTabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]]];
    } else {
        [[myTabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    }
    
    //start fetching data
    if([[UIApplication sharedApplication] applicationIconBadgeNumber]>0&&(!isFetchingData)){
        [PushNotificationHandler StartFetchingNotificationsFromServer];
    }
}

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

+(void)clearApplicationPushNotifNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
