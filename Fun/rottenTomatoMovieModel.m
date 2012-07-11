//
//  rottenTomatoMovieModel.m
//  Fun
//
//  Created by Tongda Zhang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "rottenTomatoMovieModel.h"

@implementation rottenTomatoMovieModel
@synthesize title=_title;
@synthesize year=_year;
@synthesize mpaa_rating=_mpaa_rating;
@synthesize score=_score;
@synthesize imageUrl=_imageUrl;

+(rottenTomatoMovieModel *) getModelBy:(NSDictionary *)movie{
    rottenTomatoMovieModel* model=[[rottenTomatoMovieModel alloc] init];
    model.title=[movie objectForKey:@"title"];
    model.year=[NSString stringWithFormat:@"%@",[movie objectForKey:@"year"]];
    model.mpaa_rating=[movie objectForKey:@"mpaa_rating"];
    model.score=[NSString stringWithFormat:@"%@", [[movie objectForKey:@"ratings"] objectForKey:@"audience_score"]];
    model.imageUrl=[[movie objectForKey:@"posters"] objectForKey:@"thumbnail"];
    return model;
}

+(NSArray*)initializeWithJsonData:(NSData *)data{
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *movies=[json objectForKey:@"movies"];
    NSMutableArray *models=[NSMutableArray array];
    
    for (NSDictionary* movie in movies) {
        [models addObject:[rottenTomatoMovieModel getModelBy:movie]];
    }
    return models;
}
@end
