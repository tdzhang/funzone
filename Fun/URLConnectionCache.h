//
//  URLConnectionCache.h
//  Fun
//
//  Created by Yizhou Zhu on 7/25/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface URLConnectionCache : NSManagedObject

@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSString * urlName;

@end
