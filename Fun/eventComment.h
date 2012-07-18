//
//  eventComment.h
//  Fun
//
//  Created by Tongda Zhang on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface eventComment : NSObject
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,strong) NSNumber* fb_id;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* timestamp;

+(NSArray *)getEventComentArrayFromArray:(NSArray *)comments;
@end
