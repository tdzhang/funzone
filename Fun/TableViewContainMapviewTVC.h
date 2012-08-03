//
//  TableViewContainMapviewTVC.h
//  Fun
//
//  Created by Tongda Zhang on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FourSquarePlace.h"
#import "UserContactObject.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "FunTableViewContainMapviewTVCDelegate.h"
@class MapViewController;


@interface TableViewContainMapviewTVC : UITableViewController
@property(nonatomic,weak)UITableView *myTableView;
@property (nonatomic,weak)MapViewController *myMapViewController;
@property (nonatomic,weak)id<FunTableViewContainMapviewTVCDelegate>delegate;
-(void)SearchTheKeyWords:(NSString*)keyWords AtUserLocation:(CLLocation *)userLocation;
@end
