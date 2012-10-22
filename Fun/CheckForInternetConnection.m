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
                     message: NSLocalizedString(@"No internet connection found. Please change your network settings.", @"Network error")
                     delegate: self
                     cancelButtonTitle: NSLocalizedString(@"OK", @"Network error") otherButtonTitles: nil];
        
        [errorView show];
    }
    else{
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/available",CONNECT_DOMIAN_NAME]];
        NSLog(@"%@",url);
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    // Use when fetching text data
                }
                else{
                    //connect error
                    //UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"Server Connection Not Complete." message:@"The speed of internet connection is slow, please try the refresh button to reload the data." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    //[alert show];
                }
            });
            
        });
        
    }

}

@end
