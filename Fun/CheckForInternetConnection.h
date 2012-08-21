//
//  CheckForInternetConnection.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/20/12.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "ASIFormDataRequest.h"
#import "GlobalConstant.h"

@interface CheckForInternetConnection : NSObject

+(void)CheckForConnectionToBackEndServer;

@end
