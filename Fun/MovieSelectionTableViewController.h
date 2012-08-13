//
//  MovieSelectionTableViewController.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/13/12.
//
//

#import <UIKit/UIKit.h>
#import "rottenTomatoMovieModel.h"
#import "movieAutoCCell.h"
#import "Cache.h"
#import "FunAppDelegate.h"
#import "movieInfoReturnProtocal.h"

#define ROTTENTOMATOE_APIKEY @"fsdtjhkez9txeuj86n9b83ba"

@interface MovieSelectionTableViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,weak)id<movieInfoReturn> delegate;
@end
