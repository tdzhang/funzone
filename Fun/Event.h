//
//  Event.h
//  Fun
//
//  Created by He Yang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * event_id;
@property (nonatomic, retain) NSNumber * creator_id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * img_url;
@property (nonatomic, retain) NSString * intro;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * num_shares;
@property (nonatomic, retain) NSNumber * num_likes;
@property (nonatomic, retain) NSNumber * num_pins;
@property (nonatomic, retain) NSNumber * num_views;
@property (nonatomic, retain) NSData * timestamps;

@end
