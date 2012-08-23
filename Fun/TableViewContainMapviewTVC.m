//
//  TableViewContainMapviewTVC.m
//  Fun
//
//  Created by Tongda Zhang on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TableViewContainMapviewTVC.h"
#import "GlobalConstant.h"

@interface TableViewContainMapviewTVC ()
@property(nonatomic,strong)NSMutableData *data;
@property (nonatomic,strong)NSArray *foursquareSearchResults;
@property (nonatomic,strong)NSString *foursquareConnectionType;
@property (nonatomic)CLLocationCoordinate2D userCoordinate;

@end

@implementation TableViewContainMapviewTVC
@synthesize data=_data;
@synthesize foursquareSearchResults=_foursquareSearchResults;
@synthesize myTableView=_myTableView;
@synthesize myMapViewController=_myMapViewController;
@synthesize delegate=_default;
@synthesize foursquareConnectionType=_foursquareConnectionType;
@synthesize userCoordinate=_userCoordinate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
}

#pragma mark - interface method to start feching data

#define GOOGLE_API_TOKEN1 @"AIzaSyD9BEsxqFhS9ckAnUS8KCO7qyjee4I5LRA"
#define GOOGLE_API_TOKEN2 @"AIzaSyBtrzBUsPtnJrd7TsavS6WtyKetRWR_9lM"
#define OAUTH_TOKEN1 @"ZH04LVGZECDJMXXQ4D1BHJXHBI1RIYNRMUTYKM3VSGZVMDAN"
#define OAUTH_TOKEN2 @"ICJ4PDXPC4QR2HTT4REDDOUN5KYWJMM510ZPK0WWQDEI0CZX"
#define OAUTH_TOKEN3 @"XK02KZWHY0QUYRAIX4550UJ2FR12ZZGKKX3UXE4HX0LUOKVI"
#define VERSION_STRING @"20120623"
#define RESULT_NUMBER_LIMIT 15
//Start when searchBar text changed,find the user searched result from fousqure, and save them to self.foursquareSearchResults



-(void)SearchTheKeyWords:(NSString*)searchString AtUserLocation:(CLLocation *)userLocation
{    
    //random select oauth_token from 2 exist token
    //using google api to do the search
    NSString* oauthToken;
    switch (arc4random() % 2) {
        case 0:oauthToken=GOOGLE_API_TOKEN1;break;
        case 1:oauthToken=GOOGLE_API_TOKEN2;break;
        default:oauthToken=GOOGLE_API_TOKEN1;break;
    }
    
    NSString *keyWords=[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //get User current Location
    CLLocationCoordinate2D userCoordinate = userLocation.coordinate;
    
    //NSLog(@"user latitude = %f",userCoordinate.latitude);
    //NSLog(@"user longitude = %f",userCoordinate.longitude);

    //Searching the key word
    self.userCoordinate=userCoordinate;
    double lat=userCoordinate.latitude;
    double lng=userCoordinate.longitude;
    
    NSString *request_string=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%f,%f&radius=50000&query=%@&sensor=false&key=%@",lat,lng,keyWords,oauthToken];
    if ([searchString isEqualToString:@"cinema"]) {
        request_string=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%f,%f&radius=50000&query=%@&sensor=false&key=%@&types=movie_theater",lat,lng,keyWords,oauthToken];
    }
    NSLog(@"%@",request_string);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

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
    NSMutableArray *searchResult = [NSMutableArray array];
    
    NSNumber *count =[NSNumber numberWithInt:[results count]];
    NSLog(@"Have %@ elements",count);
    //start to put fetched data in to self.foursquareSearchResults
    for (NSDictionary *venue in results) {
        FourSquarePlace *place = [FourSquarePlace initializeWithGoogleTextNSDictionary:venue withOrigin:self.userCoordinate];
        [searchResult addObject:place];
    }
    
    self.foursquareSearchResults=searchResult;//sorting the result using distance from the current location
    //reload data for the search result receiving
    [self.myTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.foursquareSearchResults count]) {
        return [self.foursquareSearchResults count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ChooseLocationOutsideTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {  
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    FourSquarePlace *place=nil;
    place=(FourSquarePlace*)[self.foursquareSearchResults objectAtIndex:indexPath.row];
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
        //venue_title=[NSString stringWithFormat:@"%@ (%@)",venue_title,place.categories_shortName];
        venue_title=[NSString stringWithFormat:@"%@",venue_title];
    }
    [cell.textLabel setText:venue_title];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:DEFAULT_TABLE_CELL_FONT_SIZE]];
    return cell;
}

#pragma mark - Table view delegate
//deal with the selection of the outside table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FourSquarePlace *place=[self.foursquareSearchResults objectAtIndex:indexPath.row];
    NSString *venue_title=(place.name)?place.name:@"No name";
    
    if (place.categories_shortName) {
       // venue_title=[[NSString alloc] initWithFormat:@"%@ (%@)",[venue_title copy],place.categories_shortName];
        venue_title=[[NSString alloc] initWithFormat:@"%@",[venue_title copy]];
    }
       
    //set mapview region( where to show the map veiw)
    MKCoordinateRegion region;
    region.center.latitude = [place.latitude doubleValue];
    region.center.longitude = [place.longitude doubleValue];
    MKCoordinateSpan span;
    span.latitudeDelta = DEFAULT_ZOOMING_SPAN_LATITUDE;
    span.longitudeDelta= DEFAULT_ZOOMING_SPAN_LONGITUDE;
    region.span = span;
        
    //add annotation
    MKPointAnnotation *annotationPoint =   [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = region.center;
    annotationPoint.title = [NSString stringWithFormat:@"%@",venue_title];

     
    if (place.crossStreet) {
        annotationPoint.subtitle = [NSString stringWithFormat:@"%@ (%@ m)",place.crossStreet,place.distance];
    }
    [self.delegate selectWithAnnotation:annotationPoint DrawMapInTheRegion:region WithPlace:place];
     
}

@end
