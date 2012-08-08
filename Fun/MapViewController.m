//
//  MapViewController.m
//  MapViewPractice
//
//  Created by Tongda Zhang on 6/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "GlobalConstant.h"

@interface  MapViewController()
//@property (nonatomic,strong)NSNumber* oldZoom;
@property (nonatomic,strong)NSNumber* currentZOOMVALUE;
@property (nonatomic,strong)NSArray *foursquareSearchResults;
@property(nonatomic,retain) NSMutableData *data;  //using to restore the http connection data
@property (nonatomic, strong)MKPointAnnotation* annotation;

@property (nonatomic,strong)MKPointAnnotation* feedBackAnnotation; //used to give back the location information of the user choosed location

-(void)startSearchBaseonTheSearchBar;
@end

@implementation MapViewController
@synthesize predefinedSeachingWords=_predefinedSeachingWords;
@synthesize myMapView=_myMapView;
@synthesize MySearchDisplayController = _MySearchDisplayController;
@synthesize mySearchBar = _mySearchBar;
//@synthesize myStepper = _myStepper;
@synthesize annotation=_annotation;
@synthesize delegate=_delegate;
@synthesize myTableView = _myTableView;
@synthesize similarPlaceToLabel = _similarPlaceToLabel;
//@synthesize oldZoom=_oldZoom;
@synthesize currentZOOMVALUE=_currentZOOMVALUE;
@synthesize foursquareSearchResults=_foursquareSearchResults;
@synthesize data=_data;
@synthesize tableViewControllerContainMap=_tableViewControllerContainMap;
@synthesize predefinedAnnotation=_predefinedAnnotation;
@synthesize preDefinedEventType=_preDefinedEventType;

@synthesize feedBackAnnotation=_feedBackAnnotation;

#pragma mark - self define setting and getting method
-(TableViewContainMapviewTVC *)tableViewControllerContainMap{
    if (_tableViewControllerContainMap == nil) {
        _tableViewControllerContainMap=[[TableViewContainMapviewTVC alloc] init];
    }
    return _tableViewControllerContainMap;
}

-(void)setTableViewControllerContainMap:(TableViewContainMapviewTVC *)tableViewControllerContainMap{
    if (![_tableViewControllerContainMap isEqual:tableViewControllerContainMap]) {
        _tableViewControllerContainMap=tableViewControllerContainMap;
    }
}



#pragma mark - init
-(MKPointAnnotation *)feedBackAnnotation{
    if (!_feedBackAnnotation) {
        _feedBackAnnotation=[[MKPointAnnotation alloc] init];
    }
    return _feedBackAnnotation;
}

-(void)setFeedBackAnnotation:(MKPointAnnotation *)feedBackAnnotation{
    if (![_feedBackAnnotation isEqual:feedBackAnnotation]) {
        _feedBackAnnotation=feedBackAnnotation;
    }
}

-(MKPointAnnotation *)annotation{
    if (!_annotation) {
        _annotation=[[MKPointAnnotation alloc] init];
    }
    return _annotation;
}

-(void)setAnnotation:(MKPointAnnotation *)annotation
{
    if (self.myMapView.annotations) {
        [self.myMapView removeAnnotations:self.myMapView.annotations];
    }
    if(![_annotation isEqual:annotation]){
        _annotation=annotation; 
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

//show User curent location
-(void)showUserCurrentLocation{
    MKMapView *mapView=self.myMapView;
    CLLocation *userLoc = mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;

    MKCoordinateRegion region;
    MKCoordinateSpan span;
    CLLocationCoordinate2D location;
    span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE;
    span.longitudeDelta = DEFAULT_ZOOMING_SPAN_LONGITUDE;
    self.currentZOOMVALUE=[NSNumber numberWithDouble:DEFAULT_ZOOMING_SPAN_LONGITUDE];
    location.latitude=userCoordinate.latitude;
    location.longitude=userCoordinate.longitude;
    region.span=span;
    region.center=location;
    [mapView setRegion:region animated:NO];
    
    // add annotation at the point User pressed
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = location;
    annotationPoint.title=@"Current Location";
    //annotationPoint.subtitle=[NSString stringWithFormat:@"Latitude:%f, Longitute:%f",location.latitude,location.longitude];
    self.annotation=annotationPoint;
    [self.myMapView addAnnotation:annotationPoint];
    
    //set the feed back annotation
    [self setFeedBackAnnotation:annotationPoint];
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set the style of navigation bar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    
    MKMapView *mapView=self.myMapView;
    mapView.showsUserLocation=YES;
    mapView.mapType=MKMapTypeStandard;
    mapView.delegate=self;
    
    
    //setting the property of the table view(datasource and delegate)
    [self.myTableView setDelegate:self.tableViewControllerContainMap];
    [self.myTableView setDataSource:self.tableViewControllerContainMap];
    self.tableViewControllerContainMap.myTableView =self.myTableView;
    self.tableViewControllerContainMap.delegate=self;
    
    
    //add gesture recognizer for usering choosing locaiton
    UILongPressGestureRecognizer* lpgr =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration =0.25;  //press time to add a annotation
    lpgr.delegate = self;
    [self.myMapView addGestureRecognizer:lpgr];
    
    
    //initailize the zooming part
//    self.myStepper.minimumValue = 1;
//    self.myStepper.maximumValue = 9;
//    self.myStepper.stepValue = 1;
//    self.myStepper.wraps = NO;
//    self.myStepper.autorepeat = NO;
//    self.myStepper.continuous = NO;   
//    [self.myStepper setValue:5];
//    self.oldZoom =[NSNumber numberWithDouble:5];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //只有第二次启动的时候，user location 才会有值, make the view show user location
    MKMapView *mapView=self.myMapView;
//    CLLocation *userLoc = mapView.userLocation.location;
//    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
    
    NSLog(@"%@",self.preDefinedEventType);
    FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
   ;
    if ([self.preDefinedEventType isEqualToString:@"movie"]) {
        [self showUserCurrentLocation];
        if (self.predefinedSeachingWords) {
            [self.tableViewControllerContainMap SearchTheKeyWords:@"cinema" AtUserLocation: appDelegate.myLocationManager.location];
            
        }
    }
     
    
    //if the predefined annotation, then show it (instead of current location)
    if(self.predefinedAnnotation){
        if ((self.predefinedAnnotation.coordinate.latitude>0.02||self.predefinedAnnotation.coordinate.latitude<-0.02)) {
            MKPointAnnotation *annotation=self.predefinedAnnotation;
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE;
            span.longitudeDelta = DEFAULT_ZOOMING_SPAN_LONGITUDE;
            self.currentZOOMVALUE=[NSNumber numberWithDouble:DEFAULT_ZOOMING_SPAN_LONGITUDE];
            region.span=span;
            region.center=annotation.coordinate;
            [mapView setRegion:region animated:NO];
            // add annotation at the point User pressed
            self.annotation=annotation;
            [self.myMapView addAnnotation:annotation];
        }
    }
    else{
        [self showUserCurrentLocation];
    }


}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.myMapView.showsUserLocation=NO;
}


- (void)viewDidUnload
{
    [self setMyMapView:nil];
    [self setMySearchBar:nil];
    [self setMyTableView:nil];
    [self setMySearchDisplayController:nil];
    [self setSimilarPlaceToLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - implement the Gesture related method
- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        /*
         Only handle state as the touches began
         set the location of the annotation
         */
        
        CLLocationCoordinate2D coordinate = [self.myMapView convertPoint:[gestureRecognizer locationInView:self.myMapView] toCoordinateFromView:self.myMapView];
        
        // add annotation at the point User pressed
        MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
        annotationPoint.coordinate = coordinate;
        if (!self.feedBackAnnotation.title||[self.feedBackAnnotation.title isEqualToString:@"Current Location"]) {
            annotationPoint.title=@"You Pressed Here";
        }
        else{
            annotationPoint.title=self.feedBackAnnotation.title;
        }
        
        annotationPoint.subtitle=[NSString stringWithFormat:@"Latitude:%f, Longitute:%f",coordinate.latitude,coordinate.longitude];
        self.annotation=annotationPoint;
        [self.myMapView addAnnotation:annotationPoint];
        
        //set feedback annotation location information
        [self setFeedBackAnnotation:annotationPoint];
        
        //[self.myMapView selectAnnotation:annotationPoint animated:YES];
        
        /*//reset the MapView region
        MKCoordinateRegion region;
        region.center=coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta = 0.005;
        span.longitudeDelta = 0.005;
        region.span = span;
        [self.myMapView setRegion:region animated:YES];
         */
    }
}

//#pragma mark - implement the Stepper part (ZooMing)
//- (IBAction)Zooming:(id)sender {
//    double oldzoom=[self.oldZoom doubleValue];
//    double zoom = self.myStepper.value;
//    NSLog(@"oldzoom: %f",oldzoom);
//    NSLog(@"zoom: %f",zoom);
//    double la,lo;
//    if (zoom<oldzoom) {
//        la=[self.currentZOOMVALUE doubleValue]*ZOOM_RATIO;
//        lo=[self.currentZOOMVALUE doubleValue]*ZOOM_RATIO;
//        self.currentZOOMVALUE = [NSNumber numberWithDouble:la];
//    }else{
//        la=[self.currentZOOMVALUE doubleValue]/ZOOM_RATIO;
//        lo=[self.currentZOOMVALUE doubleValue]/ZOOM_RATIO;
//         self.currentZOOMVALUE = [NSNumber numberWithDouble:la];
//    }
//    self.oldZoom = [NSNumber numberWithDouble:zoom];
//    MKCoordinateRegion region;
//    CLLocationCoordinate2D coordinate;
//   
//    coordinate.latitude= self.myMapView.centerCoordinate.latitude;
//    coordinate.longitude= self.myMapView.centerCoordinate.longitude;
//    region.center=coordinate;
//    MKCoordinateSpan span;
//    span.latitudeDelta = la;
//    span.longitudeDelta = lo;
//    region.span = span;
//    [self.myMapView setRegion:region animated:YES];
//
//}

- (IBAction)returnToMyLocation {
    [self showUserCurrentLocation];
}


#pragma mark - implement the UISeachBar protocal
//Showing the location that User Searched, using Apple API
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //NSString *formerKeyWord=searchBar.text;
    //[searchBar resignFirstResponder];
   // [self.MySearchDisplayController setActive:NO animated:YES];
    //[searchBar setText:formerKeyWord];
    
    [self startSearchBaseonTheSearchBar];
    [self.similarPlaceToLabel setText:[NSString stringWithFormat:@"\"%@\"",self.mySearchBar.text]];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

#pragma mark - implement the search display results
//return the table row number
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView 
         isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.foursquareSearchResults count];
    }
    return rows;
}

// Customize the appearance of table view cells (of the seach result display)
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MysearchResultDisplay";
    
    UITableViewCell *cell = [tableView 
                             dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] 
                initWithStyle:UITableViewCellStyleSubtitle //the style of the cell
                reuseIdentifier:CellIdentifier] ;
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    /* Configure the cell.  if the table view is used for showing search results*/
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        FourSquarePlace *place=[self.foursquareSearchResults objectAtIndex:indexPath.row];
        NSString *crossStreet=(place.crossStreet);
        if (place.crossStreet) {
            NSString *detail=[NSString stringWithFormat:@"%@ (%@ m)",crossStreet,place.distance];
            [cell.detailTextLabel setText:detail];
            [cell.detailTextLabel setFont:[UIFont systemFontOfSize:DEFAULT_TABLE_CELL_SUBTITLE_SIZE]];
        }
        else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell.detailTextLabel setHidden:TRUE];
        }
        //show the place name and location
        NSString *venue_title=(place.name)?place.name:@"No name";
        if (place.categories_shortName) {
            venue_title=[NSString stringWithFormat:@"%@ (%@)",venue_title,place.categories_shortName];
        }
        [cell.textLabel setText:venue_title];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:DEFAULT_TABLE_CELL_FONT_SIZE]];
    }
    return cell;
}
#define GOOGLE_API_TOKEN1 @"AIzaSyD9BEsxqFhS9ckAnUS8KCO7qyjee4I5LRA"
#define GOOGLE_API_TOKEN2 @"AIzaSyBtrzBUsPtnJrd7TsavS6WtyKetRWR_9lM"
#define OAUTH_TOKEN1 @"ZH04LVGZECDJMXXQ4D1BHJXHBI1RIYNRMUTYKM3VSGZVMDAN"
#define OAUTH_TOKEN2 @"ICJ4PDXPC4QR2HTT4REDDOUN5KYWJMM510ZPK0WWQDEI0CZX"
#define OAUTH_TOKEN3 @"XK02KZWHY0QUYRAIX4550UJ2FR12ZZGKKX3UXE4HX0LUOKVI"
#define VERSION_STRING @"20120623"
#define RESULT_NUMBER_LIMIT 15
-(void)startSearchBaseonTheSearchBar{
    //只有第二次启动的时候，user location 才会有值, make the view show user location
    NSString *searchString=self.mySearchBar.text;
    MKMapView *mapView=self.myMapView;
    CLLocation *userLoc = mapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
    if (userCoordinate.latitude>0.001) {
        //[self showUserCurrentLocation];
        if (self.predefinedSeachingWords) {
            [self.tableViewControllerContainMap SearchTheKeyWords:searchString AtUserLocation:userLoc];
        }
    }
    
    //using google api to do the search
    NSString* oauthToken;
    switch (arc4random() % 2) {
        case 0:oauthToken=GOOGLE_API_TOKEN1;break;
        case 1:oauthToken=GOOGLE_API_TOKEN2;break;
        default:oauthToken=GOOGLE_API_TOKEN1;break;
    }
    NSString *keyWords=[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //get User current Location
    //NSLog(@"user latitude = %f",userCoordinate.latitude);
    //NSLog(@"user longitude = %f",userCoordinate.longitude);
    if (userCoordinate.latitude<0.001) {
        UIAlertView *someError = [[UIAlertView alloc] initWithTitle:@"Location Unavailable" message: @"Cannot Locate Your Location, Please Check The Settings For Details." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [someError show];
    }
    else{
        //Searching the key word
        double lat=userCoordinate.latitude;
        double lng=userCoordinate.longitude;
        NSString *request_string=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=50000&keyword=%@&sensor=false&key=%@",lat,lng,keyWords,oauthToken];
        NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }

}

//Start when searchBar text changed,find the user searched result from fousqure, and save them to self.foursquareSearchResults
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    //in case the frequency of searching is too high
    int searchLength=[searchString length];
    if (searchLength<5||searchLength%4!=0) {
        return NO;
    }
    
    [self startSearchBaseonTheSearchBar];
    [self.similarPlaceToLabel setText:[NSString stringWithFormat:@"\"%@\"",self.mySearchBar.text]];
    return YES;
    
    /* 
    //test code
    NSLog(@"%@",searchString);
    NSMutableArray *result=[NSMutableArray array];
    FourSquarePlace *place=[[FourSquarePlace alloc] init];
    place.name=@"KK restaurant";
    place.categories_shortName=@"cafee";
    place.crossStreet=@"151 eleanor dr";
    place.latitude=[NSNumber numberWithDouble:37.3];
    place.longitude=[NSNumber numberWithDouble:-122.1];
     
    place.distance=[NSNumber numberWithInt:1540];
    NSLog(@"%@  %@",place.name,place.distance);
    [result  addObject:place];
    self.foursquareSearchResults=result;
    
     */

}

//response to user selection of the search result
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if the notificaiton is from the user select search results
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        FourSquarePlace *place=[self.foursquareSearchResults objectAtIndex:indexPath.row];
        if (place.latitude&&place.longitude) {
            //if is from google api
            NSString *venue_title=(place.name)?[place.name copy ]:@"No name";
            if (place.categories_shortName) {
                venue_title=[NSString stringWithFormat:@"%@ (%@)",venue_title,place.categories_shortName];
            }
            
            //set mapview region( where to show the map veiw)
            MKCoordinateRegion region;
            region.center.latitude = [place.latitude doubleValue];
            region.center.longitude = [place.longitude doubleValue];
            MKCoordinateSpan span;
            span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE;
            span.longitudeDelta=DEFAULT_ZOOMING_SPAN_LONGITUDE;
            region.span = span;
            
            //add annotation
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            annotationPoint.coordinate = region.center;
            annotationPoint.title =  [NSString stringWithFormat:@"%@",venue_title ];
            if (place.crossStreet) {
                annotationPoint.subtitle = [NSString stringWithFormat:@"%@ (%@ m)",place.crossStreet,place.distance];
            }
            [self setAnnotation:annotationPoint];
            [self.myMapView addAnnotation:annotationPoint];
            [self.myMapView setRegion:region animated:NO];
            [self.searchDisplayController setActive:NO animated:YES];
            
            //set the Search Bar and give up the Firstresponsder
            [self.mySearchBar setText:venue_title];
            
            
            //set the feedback annotation location information
            [self setFeedBackAnnotation:annotationPoint];
        } else {
            //if there is no lat and long information
            //add annotation
            MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
            annotationPoint.title = place.selfDefineName;
            [self.MySearchDisplayController setActive:NO animated:YES];
            //set the Search Bar and give up the Firstresponsder
            [self.mySearchBar setText:place.selfDefineName];
            
            //set the feedback annotation location information
            [self setFeedBackAnnotation:annotationPoint];
        }
        
    }
}

#pragma mark - implement the UITextFieldDelegate method
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length]>0) {
        [self.feedBackAnnotation setTitle:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*
     //if edit the add cost textfield, the whole view need to
     //scroll up, get rid of the keyboard covering
     if ([textField isEqual:self.textFieldEventPrice]) {
     [self animateTextField: textField up: YES];
     }
     */
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    /*
     //if finished editign the add cost textfield, the whole view need to scroll down
     if ([textField isEqual:self.textFieldEventPrice]) {
     [self animateTextField: textField up: NO];
     }
     */
}

#pragma mark - implement NSURLconnection delegate methods 
//to deal with the returned data

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.data = [[NSMutableData alloc] init];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    /*UIAlertView *someError = [[UIAlertView alloc] initWithTitle:@"Connection Error" message: @"Unable to connect to searching server" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [someError show];*/
}



- (void)connectionDidFinishLoading:(NSURLConnection *)connection {     
    //deal with google part
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    //NSLog(@"all %@",[json allKeys]);
    NSArray *results = [json objectForKey:@"results"];
    CLLocation *userLoc = self.myMapView.userLocation.location;
    CLLocationCoordinate2D userCoordinate = userLoc.coordinate;
    
    NSMutableArray *searchResult = [NSMutableArray array];
    
    NSNumber *count =[NSNumber numberWithInt:[results count]];
    NSLog(@"Have %@ elements",count);
        //start to put fetched data in to self.foursquareSearchResults
    for (NSDictionary *venue in results) {
        FourSquarePlace *place = [FourSquarePlace initializeWithGoogleNSDictionary:venue withOrigin:userCoordinate];
        [searchResult addObject:place];
    }

    //insert a self define place at the begainning 
    FourSquarePlace *place=[FourSquarePlace initializeWithSelfDefine:self.mySearchBar.text];
    [searchResult insertObject:place atIndex:0];
    self.foursquareSearchResults=searchResult;//sorting the result using distance from the current location
    //reload data for the search result receiving
    [self.searchDisplayController.searchResultsTableView reloadData];
}

#pragma mark - implemetn the FunTableViewContainMapviewTVCDelegate protocal
-(void)selectWithAnnotation:(MKPointAnnotation*)annotation DrawMapInTheRegion:(MKCoordinateRegion)region{

    
    
    //add annotation

    [self setAnnotation:annotation];
    [self.myMapView addAnnotation:annotation];
    [self.myMapView setRegion:region animated:NO];

    
    //set the Search Bar and give up the Firstresponsder
    //[self.mySearchBar setText:annotation.title];
    
    
    //set the feedback annotation location information
    [self setFeedBackAnnotation:annotation];
}


#pragma mark - implement the map view protocal
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    //if ([mapView.annotations count]>1) {
    //    [mapView removeAnnotation:[mapView.annotations objectAtIndex:1]];
    //}
    //id myAnnotation = [mapView.annotations objectAtIndex:0]; 
    [mapView selectAnnotation:self.annotation animated:NO];
}


//when the user location update happen
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (!self.predefinedAnnotation) {
        [self showUserCurrentLocation];
    }
}

//create the annnotation view(In mapView)
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if(!aView){
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        //add left image view 30*30
        //aView.leftCalloutAccessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    aView.annotation=annotation;
    
    //add button on the right of the annotation detail
//    UIButton *rightButton=[UIButton buttonWithType:UIButtonTypeContactAdd];
//    [rightButton setTitle:@"Choose" forState:UIControlStateNormal];
//    aView.rightCalloutAccessoryView = rightButton;    
//    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
 
    return aView;
}



//did something when user touch the pin
/*-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //add image (can define a delegate and using delegate method to get a related image back)
    //UIImage *image=nil;
    //[(UIImageView *)view.leftCalloutAccessoryView setImage:image];
}*/

/*
//do the right thing when user tap the button of the annotation
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    if ([(UIButton*)control buttonType]==UIButtonTypeContactAdd) {
        
        MKPointAnnotation *annotationPoint = view.annotation;
        [mapView deselectAnnotation:annotationPoint animated:NO];
        //Move the target into the center of the mapview
        MKCoordinateRegion region;
        region.center = annotationPoint.coordinate;
        MKCoordinateSpan span;
        span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE*1;
        span.longitudeDelta=DEFAULT_ZOOMING_SPAN_LONGITUDE*1;
        region.span = span;
        [self.myMapView setRegion:region animated:NO];
        
        
        
        //do the snapshot of the map view
        UIGraphicsBeginImageContextWithOptions(mapView.frame.size, NO, 0.0);
        //UIGraphicsBeginImageContext(mapView.frame.size);
        [mapView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext(); 
        
        //then crop the snapshot
        //run the delegate method to feedback
        if ([self.delegate conformsToProtocol:@protocol(SelfChooseLocation)]) {
             NSLog(@"%@",view.annotation.title);
            [self.delegate UpdateLocation:view  withLocationName:view.annotation.title withSnapShot:image sendFrom:self];
            
           
        }
        [self.navigationController popViewControllerAnimated:YES];        
    }
}
*/
//the action of the finish button
- (IBAction)DoneWithChooseLocation:(id)sender {
    
    MKPointAnnotation *annotationPoint = [MKPointAnnotation new];
    [annotationPoint setCoordinate:self.annotation.coordinate];
    [annotationPoint setTitle:self.annotation.title];
    [annotationPoint setSubtitle:self.annotation.subtitle];
    
    //[self.myMapView deselectAnnotation:annotationPoint animated:NO];
    //Move the target into the center of the mapview
    MKCoordinateRegion region;

    region.center = annotationPoint.coordinate;
    MKCoordinateSpan span;
    span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE*1;
    span.longitudeDelta=DEFAULT_ZOOMING_SPAN_LONGITUDE*1;
    region.span = span;
    [self.myMapView setRegion:region animated:NO];
    
    //do the snapshot of the map view
    //UIGraphicsBeginImageContextWithOptions(self.myMapView.frame.size, NO, 0.0);
    //UIGraphicsBeginImageContext(mapView.frame.size);
    //[self.myMapView.layer renderInContext:UIGraphicsGetCurrentContext()];
    //UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //UIGraphicsEndImageContext();
    
    //then crop the snapshot
    //run the delegate method to feedback
    
    if ([self.delegate conformsToProtocol:@protocol(SelfChooseLocation)]) {
        NSLog(@"%@",self.annotation.title);
        MKPointAnnotation* annotation=[[MKPointAnnotation alloc] init];
        [annotation setCoordinate:self.feedBackAnnotation.coordinate];
        [annotation setTitle:self.feedBackAnnotation.title];
        [annotation setSubtitle:self.feedBackAnnotation.subtitle];
        [self.delegate UpdateLocation:annotation  withLocationName:self.feedBackAnnotation.title withSnapShot:nil sendFrom:self];
    }
     
    [self.navigationController popViewControllerAnimated:YES];
}
@end
