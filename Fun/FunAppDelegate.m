//
//  FunAppDelegate.m
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FunAppDelegate.h"

@interface FunAppDelegate() <FBSessionDelegate,WXApiDelegate>
@end

@implementation FunAppDelegate

@synthesize window = _window;
@synthesize facebook=_facebook;
@synthesize thisTabBarController = _thisTabBarController;
@synthesize myLocationManager=_myLocationManager;

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
    newFrame.size.height = 57.5;
    newFrame.origin.y -= 8.5;
    //newFrame.origin.x -= 5;
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
    background.frame = newFrame;
    [self.thisTabBarController.tabBar insertSubview:background atIndex:1];
    [[self.thisTabBarController.tabBar.items objectAtIndex:0] setFinishedSelectedImage: [UIImage imageNamed:@"HomeOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"HomeGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:1] setFinishedSelectedImage: [UIImage imageNamed:@"StarOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"StarGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:2] setFinishedSelectedImage: [UIImage imageNamed:@"AddOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"AddGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:4] setFinishedSelectedImage: [UIImage imageNamed:@"ActivityOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"ActivityGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    [[self.thisTabBarController.tabBar.items objectAtIndex:3] setFinishedSelectedImage: [UIImage imageNamed:@"ParcOrange.png"] withFinishedUnselectedImage: [UIImage imageNamed: @"ParcGrey.png"]];
    self.window.rootViewController = self.thisTabBarController;
    
    //set the default start page
    [self.thisTabBarController setSelectedIndex:1];
    
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
    if(self.myLocationManager)[self.myLocationManager stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [PushNotificationHandler synTheBadgeNumberOfActivityAndAllpication:self.thisTabBarController];
    
    //upload user's locaiton
    if(self.myLocationManager){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([CLLocationManager regionMonitoringEnabled]&&[defaults objectForKey:@"login_auth_token"]){
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

                NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/upload_current_location?auth_token=%@&current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.myLocationManager.location.coordinate.longitude,self.myLocationManager.location.coordinate.latitude]];
                NSLog(@"upload location:%@",url);
                ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
                [request setRequestMethod:@"GET"];
                [request startSynchronous];
                
                int code=[request responseStatusCode];
                NSLog(@"code:%d",code);
            });
        }
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //set the location manager, start getting user location
    CLLocationManager *current_location_manager = [[CLLocationManager alloc] init];
    [current_location_manager startUpdatingLocation];
    self.myLocationManager=current_location_manager;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MyPermenentCachePart EXITit];//save the permanentcache data
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //stop updating user's locaiton
    if(self.myLocationManager)[self.myLocationManager stopUpdatingLocation];
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
    [PushNotificationHandler synTheBadgeNumberOfActivityAndAllpication:self.thisTabBarController withUserInfo:userInfo];
}

#pragma mark - image processing
- (UIImage*)imageByScalingAndCroppingithImage:(UIImage*)sourceImage
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    NSLog(@"-->%f  -->%f",width,height);
    CGFloat targetFactor=sqrt(width*height/52684.8);
    if (targetFactor<1) {
        targetFactor=1;
    }
    CGFloat targetHeight = height/targetFactor;
    CGFloat targetWidth = width/targetFactor;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    CGSize targetSize=imageSize;
    targetSize.width=targetWidth;
    targetSize.height=targetHeight;
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
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

-(void)sendText:(NSString*)content WithImageURL:(NSURL*)imgurl{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =content;
    message.description=@"This is from OrangeParc.";
    [message setThumbImage:[self imageByScalingAndCroppingithImage:[UIImage imageWithData:[Cache getCachedData:imgurl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.orangeparc.com";//[NSString stringWithFormat:@"%@",imgurl];//@"http://www.orangeparc.com";
    //    WXImageObject *ext = [WXImageObject object];
    //    ext.imageData = [Cache getCachedData:imgurl];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}


- (void) RespText:(NSString*)content WithImageURL:(NSURL*)imgurl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =content;
    message.description=@"This is from OrangeParc.";
    [message setThumbImage:[self imageByScalingAndCroppingithImage:[UIImage imageWithData:[Cache getCachedData:imgurl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"%@",imgurl];//@"http://www.orangeparc.com";
    //    WXImageObject *ext = [WXImageObject object];
    //    ext.imageData = [Cache getCachedData:imgurl];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.bText = NO;
    resp.message = message;
    
    [WXApi sendResp:resp];
}

-(void)SendMoment:(NSString*)content WithImageURL:(NSURL*)imgurl{

    WXMediaMessage *message = [WXMediaMessage message];
    message.title =content;
    message.description=@"This is from OrangeParc.";
    [message setThumbImage:[self imageByScalingAndCroppingithImage:[UIImage imageWithData:[Cache getCachedData:imgurl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://www.orangeparc.com";//[NSString stringWithFormat:@"%@",imgurl];//@"http://www.orangeparc.com";
//    WXImageObject *ext = [WXImageObject object];
//    ext.imageData = [Cache getCachedData:imgurl];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
}

- (void) RespMoment:(NSString*)content WithImageURL:(NSURL*)imgurl
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =content;
    message.description=@"This is from OrangeParc.";
    [message setThumbImage:[self imageByScalingAndCroppingithImage:[UIImage imageWithData:[Cache getCachedData:imgurl]]]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"%@",imgurl];//@"http://www.orangeparc.com";
    //    WXImageObject *ext = [WXImageObject object];
    //    ext.imageData = [Cache getCachedData:imgurl];
    message.mediaObject = ext;
    
    GetMessageFromWXResp* resp = [[GetMessageFromWXResp alloc] init];
    resp.bText = NO;
    resp.message = message;
    
    [WXApi sendResp:resp];
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
