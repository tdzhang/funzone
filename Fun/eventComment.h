//
//  eventComment.h
//  Fun
//
//  Created by Tongda Zhang on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//The class file for a comment
#import <Foundation/Foundation.h>

@interface eventComment : NSObject
@property (nonatomic,strong) NSNumber *user_id;
@property (nonatomic,strong) NSNumber* fb_id;
@property (nonatomic,strong) NSString* content;
@property (nonatomic,strong) NSString* timestamp;
@property (nonatomic,strong) NSString* user_name;

//generate the array of the eventComment from the json got from the sever
+(NSArray *)getEventComentArrayFromArray:(NSArray *)comments;
@end
