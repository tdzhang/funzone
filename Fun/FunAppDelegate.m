//
//  FunAppDelegate.m
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FunAppDelegate.h"

@interface FunAppDelegate() <FBSessionDelegate,WXApiDelegate>
@property (strong, nonatomic) UITabBarController *thisTabBarController;
@end

@implementation FunAppDelegate

@synthesize window = _window;
@synthesize facebook=_facebook;
@synthesize thisTabBarController = _thisTabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //push notification register
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    
    //if has notification, synchronize the number
    [PushNotificationHandler synTheBadgeNumberOfActivityAndAllpication:self.thisTabBarController];
    
    
    // Override point for customization after application launch.
    [Cache init];
    //向微信注册
    [WXApi registerApp:@"wx2089110c987d6949"];
    
    //customize tab bar
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName: @"MainStoryboard_iPhone" bundle: nil];
    self.thisTabBarController = (UITabBarController*) [mainStoryboard instantiateViewControllerWithIdentifier: @"mainTabBarController"];
    CGRect newFrame = self.thisTabBarController.view.frame;
    newFrame.size.height = 59;
    newFrame.origin.y -= 10;
    newFrame.origin.x -= 5;
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    background.frame = newFrame;
    [self.thisTabBarController.tabBar insertSubview:background atIndex:1];
    [[self.thisTabBarController.tabBar.items objectAtIndex:0] setFinishedSelectedImage: [UIImage imageNamed:@"HomeOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"HomeGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:1] setFinishedSelectedImage: [UIImage imageNamed:@"StarOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"StarGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:2] setFinishedSelectedImage: [UIImage imageNamed:@"AddOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"AddGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:3] setFinishedSelectedImage: [UIImage imageNamed:@"ActivityOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"ActivityGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:4] setFinishedSelectedImage: [UIImage imageNamed:@"ParcOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"ParcGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [MyPermenentCachePart EXITit];//save the permanentcache data
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self.thisTabBarController setSelectedIndex:1];
    [PushNotificationHandler synTheBadgeNumberOfActivityAndAllpication:self.thisTabBarController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MyPermenentCachePart EXITit];//save the permanentcache data
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
/////////////
// Pre iOS 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [self.facebook handleOpenURL:url]||[WXApi handleOpenURL:url delegate:self];
}
#pragma mark - push notification related stuff
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
	NSString* newToken = [deviceToken description];
	newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
	NSLog(@"My token is: %@", newToken);
    //send the new token to the sever;
    [PushNotificationHandler SendeAPNStokenToServer:newToken];

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    NSLog(@"here received notification userinfo");
    //handle the push notification
    [PushNotificationHandler synTheBadgeNumberOfActivityAndAllpication:self.thisTabBarController];
}

#pragma mark - weichat related stuff
-(void)sendText:(NSString*)content{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = content;
    req.scene=WXSceneSession;
    [WXApi sendReq:req];
    [self RespTextContent:content];
}

-(void)SendMoment:(NSString*)content{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = YES;
    req.text = content;
    req.scene=WXSceneTimeline;
    [WXApi sendReq:req];
}

-(void) RespTextContent:(NSString*)content
{
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.text = content;
    resp.bText = YES;
    [WXApi sendResp:resp];
}


#pragma mark - facebook related stuff
// For iOS 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.facebook handleOpenURL:url]||[WXApi handleOpenURL:url delegate:self];
}


- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    //send notification of login finished
    [[NSNotificationCenter defaultCenter] postNotificationName:@"faceBookLoginFinished" object:nil];
}
-(void)fbDidNotLogin:(BOOL)cancelled{
    NSLog(@"fbDidNotLogin called at FunAppDelegate.m, but nothing has been done");
}
-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt{
 //need to do sth
    NSLog(@"fbDidExtendToken called at FunAppDelegate.m, but nothing has been done");
}

-(void)fbSessionInvalidated{
    NSLog(@"fbSessionInvalidated called at FunAppDelegate.m, but nothing has been done");
}

-(void)fbDidLogout{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:@"FBAccessTokenKey"];
    [defaults setValue:nil forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response);
}
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    //NSLog(@"error %@",error);
}

@end
