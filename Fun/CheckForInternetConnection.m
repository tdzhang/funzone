//
//  CheckForInternetConnection.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/20/12.
//
//

#import "CheckForInternetConnection.h"


@implementation CheckForInternetConnection

+(void)CheckForConnectionToBackEndServer{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    
    
    if(internetStatus == NotReachable) {
        UIAlertView *errorView;
        
        errorView = [[UIAlertView alloc]
                     initWithTitle: NSLocalizedString(@"Network error", @"Network error")
                     message: NSLocalizedString(@"No internet connection found, this application requires an internet connection to gather the data required.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"Close", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
    }
//    else{
//        reachability=[Reachability reachabilityWithHostName:@"http://www.google.com"];
//        internetStatus= [reachability currentReachabilityStatus];
//        if (internetStatus == NotReachable)
//        {
//            
//            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Server Connection Error." message:@"Our server is currently under maintainess. Please try again later."
//                                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
//        
//    }

}

@end
