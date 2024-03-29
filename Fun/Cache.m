//
//  Cache.m
//  Cookie
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "Cache.h"

@interface Cache ()
//#define CACHE_LIMIT 1024*1024*50
@end

@implementation Cache

static bool cacheInitialized = false;
static int cacheSize;
static int usedCacheSize;
//current documenr directory
static NSString* documentDir;
//cacheDic mapping "key" to "path"
static NSMutableDictionary* cacheDict;
static NSString* cacheDictPath;
//recentViewList store the recent fetched data sequence
static NSMutableArray* recentViewList;
static NSString* recentViewListPath;
/*****************************************************************
 
 *****************************************************************/
+ (BOOL) isInitialized{
    if (cacheInitialized) {
        return YES;
    }
    return NO;
}

+ (void)init {
    cacheInitialized = YES;
    cacheSize = CACHE_LIMIT;
    usedCacheSize = 0;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",paths);
    documentDir = [paths objectAtIndex:0];
    // set cache dictionary path as current document directory with appending cache naming component
    cacheDictPath = [documentDir stringByAppendingPathComponent:DEFAULT_CACHE_DICT_FILE];
    cacheDict = [[NSMutableDictionary alloc] initWithContentsOfFile:cacheDictPath];
    if (cacheDict == nil) {
        cacheDict = [[NSMutableDictionary alloc] init];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:cacheDictPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    for (id key in cacheDict) {
        NSString* path = [cacheDict objectForKey:key];
        UInt32 fileSize = [[fileManager attributesOfItemAtPath:path error:NULL] fileSize];
        usedCacheSize += fileSize;
    }
    
    // initialize recent viewing list
    recentViewListPath = [documentDir stringByAppendingPathComponent:DEFAULT_RECENT_VIEW_LIST_FILE];
    recentViewList = [[NSMutableArray alloc] initWithContentsOfFile:recentViewListPath];
    if (recentViewList == nil) {
        recentViewList = [[NSMutableArray alloc] init];
    }
    
    //Add all the data from the permenentCachePartInto this dynamic part
    [MyPermenentCachePart init];
    
    
}

+ (NSString*) generateKeyFromURL:(NSURL*)url {
    //NSString* key = [url relativePath];
    NSString* key = [url absoluteString];
    key=[key stringByReplacingOccurrencesOfString:@"/" withString:@"."];
    key=[key stringByReplacingOccurrencesOfString:@":" withString:@"."];
    key=[key stringByReplacingOccurrencesOfString:@"?" withString:@"."];
    key=[key stringByReplacingOccurrencesOfString:@"=" withString:@"."];
    key=[key stringByReplacingOccurrencesOfString:@"..." withString:@"."];
    return [key stringByReplacingOccurrencesOfString:@"/" withString:@"."];
}



+ (BOOL) addDataToCache:(NSURL*)url withData:(NSData*)data
{
    
    if (!cacheInitialized) {
        [Cache init];
    }
    //add the data into permanent cache
    
    //dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0),^{  
    //get the image data
    [MyPermenentCachePart addDataToCache:[NSString stringWithFormat:@"%@",url] withData:[data copy]];
    //});
    
    BOOL result = NO;
    NSString *key = [Cache generateKeyFromURL:url];
    if (key) {
        NSString *path = [documentDir stringByAppendingPathComponent:key];
        result = [data writeToFile:path atomically:YES];
        if (result) {
            @synchronized(self) {
                usedCacheSize += [data length];
                [cacheDict setValue:path forKey:key];
                
                while (usedCacheSize > cacheSize) {
                    NSString* key = [recentViewList objectAtIndex:0];
                    if (key != nil) {
                        [self removeCachedDataWithKey:key];
                    }
                    //NSLog(@"%@", recentViewList);
                    //NSLog(@"usedCacheSize = %d/%d\n", usedCacheSize, cacheSize);
                }
                
                [cacheDict writeToFile:cacheDictPath atomically:YES];
                [recentViewList writeToFile:recentViewListPath atomically:YES];
            }
        }
    }
    return result;
}

+ (BOOL) isURLCached:(NSURL *)url {
    if (!cacheInitialized) {
        [Cache init];
    }

    if ([[MyPermenentCachePart url2dataDictionary] objectForKey:[Cache generateKeyFromURL:url]]) {
        return YES;
    }
    NSString* path = [cacheDict valueForKey:[Cache generateKeyFromURL:url]];
    return (path != nil);
}

+ (NSData*) getCachedData:(NSURL *)url {
    if (!cacheInitialized) {
        [Cache init];
    }
    NSString* key = [Cache generateKeyFromURL:url];
    //if permenent has, get it
    if ([[MyPermenentCachePart url2dataDictionary] objectForKey:key]) {
        return [[MyPermenentCachePart url2dataDictionary] objectForKey:key];
    }
    //else find int the cache
    NSString* path = [cacheDict valueForKey:key];
    if (path == nil) {
        return nil;
    }
    else {
        @synchronized(self) {
            int index = -1;
            for (int i = 0; i < [recentViewList count]; i++) {
                if ([[recentViewList objectAtIndex:i] isEqualToString:key]) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                [recentViewList removeObjectAtIndex:index];
            }
            [recentViewList addObject:key];
            //NSLog(@"%@", recentViewList);
            //NSLog(@"usedCacheSize = %d/%d\n", usedCacheSize, cacheSize);
            return ([NSData dataWithContentsOfFile:path]);
        }
    }
}

+ (BOOL) removeCachedDataWithKey:(NSString *)key {
    if (!cacheInitialized) {
        [Cache init];
    }
    BOOL result = NO;
    NSString* path = [cacheDict valueForKey:key];
    if (path != nil) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        @synchronized(self) {
            NSError *error;
            BOOL fileExists = [fileManager fileExistsAtPath:path];
            if (fileExists) {
                usedCacheSize -= [[fileManager attributesOfItemAtPath:path error:NULL] fileSize];
                result = [fileManager removeItemAtPath:path error:&error];
                if (result == NO) {
                    NSLog(@"Error: %@", [error localizedDescription]);
                }
                else {
                    NSLog(@"Cache: removed %s", [key UTF8String]);
                }
            }
            [cacheDict removeObjectForKey:key];
            int index = -1;
            for (int i = 0; i < [recentViewList count]; i++) {
                if ([[recentViewList objectAtIndex:i] isEqualToString:key]) {
                    index = i;
                    break;
                }
            }
            if (index >= 0) {
                [recentViewList removeObjectAtIndex:index];
            }
        }
    }
    return result;
}

+ (BOOL) removeDataFromCache:(NSURL *)url {
    NSString* key = [Cache generateKeyFromURL:url];
    return [self removeCachedDataWithKey:key];
}

@end



