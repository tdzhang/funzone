//
//  detailLocationMapViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/6/12.
//
//

#import "detailLocationMapViewController.h"

@interface detailLocationMapViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *GetDirectionButton;

@end

@implementation detailLocationMapViewController
@synthesize GetDirectionButton;
@synthesize myMapView;
@synthesize predefinedAnnotation=_predefinedAnnotation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#define DEFAULT_ZOOMING_SPAN_LONGITUDE 0.015
#define DEFAULT_ZOOMING_SPAN_LATITUDE 0.015
#define ZOOM_RATIO 2.5
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    MKMapView *mapView=self.myMapView;

    //if the predefined annotation, then show it (instead of current location)
    //(self.predefinedAnnotation.coordinate.latitude>0.02||self.predefinedAnnotation.coordinate.latitude<-0.02)
    if(self.predefinedAnnotation){
        MKPointAnnotation *annotation=self.predefinedAnnotation;
        if (annotation.coordinate.latitude <0.1&&annotation.coordinate.latitude>-0.1) {
            UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"This event does not have location information"] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
            notsuccess.delegate=self;
            [notsuccess show];
        }
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE;
        span.longitudeDelta = DEFAULT_ZOOMING_SPAN_LONGITUDE;
        region.span=span;
        region.center=annotation.coordinate;
        [mapView setRegion:region animated:YES];
        // add annotation at the point User pressed
        [self.myMapView addAnnotation:annotation];
    }

    self.GetDirectionButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the style of navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    MKMapView *mapView=self.myMapView;
    mapView.showsUserLocation=NO;
    mapView.mapType=MKMapTypeStandard;
    mapView.delegate=self;
}

- (void)viewDidUnload
{
    [self setMyMapView:nil];
    [self setGetDirectionButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - open Google Map app
- (IBAction)openMapApp:(id)sender {
    UIApplication *app = [UIApplication sharedApplication];
    NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/maps?q=%@&ll=%f,%f",[self.predefinedAnnotation.title stringByReplacingOccurrencesOfString:@" " withString:@"%20"] ,self.predefinedAnnotation.coordinate.latitude, self.predefinedAnnotation.coordinate.longitude]];
    NSLog(@"%@",url);
    [app openURL:url];

}


#pragma mark - implement the map view protocal
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    [mapView selectAnnotation:self.predefinedAnnotation animated:YES];
}


//create the annnotation view(In mapView)
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if(!aView){
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
    }
    aView.annotation=annotation;

    
    return aView;
}

@end
