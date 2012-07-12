//
//  MovieAotoCompletionVC.h
//  Fun
//
//  Created by Tongda Zhang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rottenTomatoMovieModel.h"
#import "movieAutoCCell.h"
#import "Cache.h"

#define ROTTENTOMATOE_APIKEY @"fsdtjhkez9txeuj86n9b83ba"

@protocol movieInfoReturn <NSObject>

-(void)movieInfoReturn:(rottenTomatoMovieModel *)model from:(id) sender;

@end


@interface MovieAotoCompletionVC : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,weak)id<movieInfoReturn> delegate;
@end
