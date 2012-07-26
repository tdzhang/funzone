//
//  Event.h
//  Fun
//
//  Created by Yizhou Zhu on 7/25/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * creator_id;
@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) NSString * img_url;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSNumber * num_likes;
@property (nonatomic, retain) NSNumber * num_pins;
@property (nonatomic, retain) NSNumber * num_shares;
@property (nonatomic, retain) NSNumber * num_views;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSData * timestamps;
@property (nonatomic, retain) NSString * title;

@end
