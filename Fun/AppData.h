//
//  AppData.h
//  Cookie
//
//  Created by He Yang on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppData : NSObject

+ (AppData *)getAppDataInstance;
@property (nonatomic,strong) NSArray *events;
@property (nonatomic,strong) NSArray *favorList;
@property (nonatomic) int event_id;

@end
