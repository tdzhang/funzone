//
//  URLConnectionCache.h
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface URLConnectionCache : NSManagedObject

@property (nonatomic, retain) NSString * urlName;
@property (nonatomic, retain) NSData * data;

@end
