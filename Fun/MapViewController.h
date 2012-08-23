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
#import "FunAppDelegate.h"
#import "SelfChooseLocation.h"

@class MapViewController;
@class TableViewContainMapviewTVC;






@interface MapViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIGestureRecognizerDelegate,FunTableViewContainMapviewTVCDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (weak, nonatomic) IBOutlet UISearchDisplayController *MySearchDisplayController;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
//@property (weak, nonatomic) IBOutlet UIStepper *myStepper;
@property (weak,nonatomic) id<SelfChooseLocation> delegate;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *similarPlaceToLabel;
@property (nonatomic,strong) TableViewContainMapviewTVC *tableViewControllerContainMap;
@property (nonatomic,weak) NSString *predefinedSeachingWords;
@property (nonatomic,strong) NSString *preDefinedEventType;
@property (nonatomic,strong) MKPointAnnotation *predefinedAnnotation;
@end


#define DEFAULT_ZOOMING_SPAN_LONGITUDE 0.015
#define DEFAULT_ZOOMING_SPAN_LATITUDE 0.015
#define ZOOM_RATIO 2.5	
