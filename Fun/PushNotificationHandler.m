//
//  PushNotificationHandler.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "PushNotificationHandler.h"

@implementation PushNotificationHandler


+(void)synTheBadgeNumberOfActivityAndAllpication:(UITabBarController*)myTabBarController{
    //set the number of the tab bar
    if ([[UIApplication sharedApplication] applicationIconBadgeNumber]>0) {
        [[myTabBarController.tabBar.items objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%d",[[UIApplication sharedApplication] applicationIconBadgeNumber]]];
    } else {
        [[myTabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
    }
}

+(void)ProcessNotificationUserInfo:(NSDictionary *)userInfo ChangeTabBarController:(UITabBarController*)myTabBarController{
    NSLog(@"did receive push notification %@",userInfo);
    NSDictionary *aps=[userInfo objectForKey:@"aps"];
    
    [[myTabBarController.tabBar.items objectAtIndex:4] setBadgeValue:[NSString stringWithFormat:@"%@",[aps objectForKey:@"badge"]]];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


+(void)SendeAPNStokenToServer:(NSString*) newToken{
    NSLog(@"send the apns token to the sever");
    //handle the new token
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload_device_token",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
    }];
    
    //add login auth_token //add content
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"login_auth_token"]) {
        [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
        [request setPostValue:newToken forKey:@"device_token"];
        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
    }
    else{
        [defaults setValue:newToken forKey:@"push_notification_token"];
        [defaults synchronize];
    }
}

+(void)SendAPNStokenToServer{
    NSLog(@"send old apns token to the sever");
    //handle the new token
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload_device_token",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
    }];
    
    //add login auth_token //add content
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"login_auth_token"]&&[defaults objectForKey:@"push_notification_token"]) {
        [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
        [request setPostValue:[defaults objectForKey:@"push_notification_token"] forKey:@"device_token"];
        [request setRequestMethod:@"POST"];
        [request startAsynchronous];
    }
}

+(void)clearApplicationPushNotifNumber{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end
