//
//  rottenTomatoMovieModel.h
//  Fun
//
//  Created by Tongda Zhang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface rottenTomatoMovieModel : NSObject
@property(nonatomic,strong) NSString* title;
@property(nonatomic,strong) NSString* year;
@property(nonatomic,strong) NSString* mpaa_rating;
@property(nonatomic,strong) NSString* score;
@property(nonatomic,strong) NSString* imageUrl;
+(rottenTomatoMovieModel *) getModelBy:(NSDictionary *)movie;
+(NSArray*)initializeWithJsonData:(NSData *)data;
@end
