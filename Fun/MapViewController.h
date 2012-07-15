//
//  MapViewController.h
//  MapViewPractice
//
//  Created by Tongda Zhang on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FourSquarePlace.h"
#import <QuartzCore/QuartzCore.h>
#import "TableViewContainMapviewTVC.h"
#import "FunTableViewContainMapviewTVCDelegate.h"

@class MapViewController;
@class TableViewContainMapviewTVC;



@protocol SelfChooseLocation <NSObject>

-(void)UpdateLocation:(MKAnnotationView*)aView withSnapShot:(UIImage*)image sendFrom:(MapViewController*)sender;

@end


@interface MapViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIGestureRecognizerDelegate,FunTableViewContainMapviewTVCDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *myMapView;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (weak, nonatomic) IBOutlet UIStepper *myStepper;
@property (weak,nonatomic) id<SelfChooseLocation> delegate;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,strong) TableViewContainMapviewTVC *tableViewControllerContainMap;
@property (nonatomic,strong) NSString *predefinedSeachingWords;
@property (nonatomic,strong) MKPointAnnotation *predefinedAnnotation;
@end


#define DEFAULT_ZOOMING_SPAN_LONGITUDE 0.015
#define DEFAULT_ZOOMING_SPAN_LATITUDE 0.015
#define ZOOM_RATIO 2.5	
