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
#import "FunAppDelegate.h"
#import "movieInfoReturnProtocal.h"
#import "MovieSelectionTableViewController.h"

#define ROTTENTOMATOE_APIKEY @"fsdtjhkez9txeuj86n9b83ba"

@interface MovieAotoCompletionVC : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,weak)id<movieInfoReturn> delegate;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


@end
