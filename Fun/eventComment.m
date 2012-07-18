//
//  eventComment.m
//  Fun
//
//  Created by Tongda Zhang on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "eventComment.h"

@implementation eventComment

@synthesize user_id=_user_id;
@synthesize fb_id=_fb_id;
@synthesize content=_content;
@synthesize timestamp=_timestamp;

+(NSArray *)getEventComentArrayFromArray:(NSArray *)comments{
    NSMutableArray *temp_array=[NSMutableArray array];
    for (NSDictionary *comment in comments) {
        NSNumber *user_id=[comment objectForKey:@"user_id"];
        NSNumber *fb_id=[comment objectForKey:@"fb_id"];
        NSString *content=[comment objectForKey:@"content"];
        NSString *timestamp=[comment objectForKey:@"timestamp"];
        eventComment *commentOne=[[eventComment alloc] init];
        commentOne.user_id=user_id;
        commentOne.fb_id=fb_id;
        commentOne.content=content;
        commentOne.timestamp=timestamp;
        [temp_array addObject:commentOne];
    }
    return temp_array;
}

@end
