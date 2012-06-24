//
//  AppData.m
//  Cookie
//
//  Created by He Yang on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppData.h"

@implementation AppData

@synthesize events = events;
@synthesize event_id = _event_id;
@synthesize favorList = _favorList;

static AppData *instance = nil;

+ (AppData *)getAppDataInstance {
    if (instance == nil) {
        instance = [AppData new];
    }
    return instance;
}

- (AppData *)init {
    self = [super init];
    _event_id = 0;
    return self;
}

@end



