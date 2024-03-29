//
//  MyPermenentCachePart.h
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "URLConnectionCache.h"
#import "Cache.h"

#define MYPERMANENTCACHEPART_SATASIZE_LIMITE 1024*1024*7

@interface MyPermenentCachePart : NSObject
+(void)init; // init the PermenetCachePart(including call startFrtchingData subroutine)
+(void)startFetchingData; //fetch all the data already in the coredata
+(UIManagedDocument *)document;//return the UIManagedDocument
+ (void) addDataToCache:(NSString*)urlName withData:(NSData*)data;//add data to the core data
+(NSMutableArray *)url2datas;
+(NSMutableDictionary *)url2dataDictionary;
+(void)EXITit;
//prevernt icloud back up
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
