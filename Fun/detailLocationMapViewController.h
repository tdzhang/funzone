//
//  detailLocationMapViewController.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/6/12.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>


@interface detailLocationMapViewController : UIViewController<MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic,strong) MKPointAnnotation *predefinedAnnotation;
@end
