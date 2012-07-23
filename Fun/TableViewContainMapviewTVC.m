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

@end

@implementation TableViewContainMapviewTVC
@synthesize data=_data;
@synthesize foursquareSearchResults=_foursquareSearchResults;
@synthesize myTableView=_myTableView;
@synthesize myMapViewController=_myMapViewController;
@synthesize delegate=_default;
@synthesize foursquareConnectionType=_foursquareConnectionType;
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
}

#pragma mark - interface method to start feching data

#define OAUTH_TOKEN1 @"ZH04LVGZECDJMXXQ4D1BHJXHBI1RIYNRMUTYKM3VSGZVMDAN"
#define OAUTH_TOKEN2 @"ICJ4PDXPC4QR2HTT4REDDOUN5KYWJMM510ZPK0WWQDEI0CZX"
#define OAUTH_TOKEN3 @"XK02KZWHY0QUYRAIX4550UJ2FR12ZZGKKX3UXE4HX0LUOKVI"
#define VERSION_STRING @"20120623"
#define RESULT_NUMBER_LIMIT 15
//Start when searchBar text changed,find the user searched result from fousqure, and save them to self.foursquareSearchResults



-(void)SearchTheKeyWords:(NSString*)searchString AtUserLocation:(CLLocation *)userLocation withEventType:(NSString *)eventType
{    
    //random select oauth_token from 2 exist token
    NSString* oauthToken;
    switch (arc4random() % 3) {
        case 0:oauthToken=OAUTH_TOKEN1;break;
        case 1:oauthToken=OAUTH_TOKEN2;break;
        case 3:oauthToken=OAUTH_TOKEN3;break;
        default:oauthToken=OAUTH_TOKEN1;break;
    }
    
    NSString *keyWords=[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //get User current Location
    CLLocationCoordinate2D userCoordinate = userLocation.coordinate;
    
    //NSLog(@"user latitude = %f",userCoordinate.latitude);
    //NSLog(@"user longitude = %f",userCoordinate.longitude);

    //Searching the key word
    double lat=userCoordinate.latitude;
    double lng=userCoordinate.longitude;
    
    
    NSString *request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
    self.foursquareConnectionType=@"search";
    //if the search string is empty
    if ([searchString isEqualToString:@""]) {
        if ([eventType isEqualToString:@"food"]) {
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"food",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"party"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"drinks",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"outdoor"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"outdoors",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"shopping"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"shops",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"movie"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"cinema",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
        else if([eventType isEqualToString:@"entertain"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"theater",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
        else if([eventType isEqualToString:@"sports"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"sports",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
        else if([eventType isEqualToString:@"events"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"conference",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
    }
    //else if the search string (user input title) is not empty
    else {
        if ([eventType isEqualToString:@"food"]) {
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"food",keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"party"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"drinks",keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"outdoor"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"outdoors",keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"shopping"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/explore?ll=%f,%f&section=%@&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"shops",keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"explore";
        }
        else if([eventType isEqualToString:@"movie"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,@"cinema",RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
        else if([eventType isEqualToString:@"entertain"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
        else if([eventType isEqualToString:@"sports"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
        else if([eventType isEqualToString:@"events"]){
            request_string=[NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?ll=%f,%f&intent=checkin&query=%@&limit=%d&oauth_token=%@&v=%@",lat,lng,keyWords,RESULT_NUMBER_LIMIT,oauthToken,VERSION_STRING];
            self.foursquareConnectionType=@"search";
        }
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
    NSMutableArray *searchResult = [NSMutableArray array];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    NSLog(@"all %@",[json allKeys]);
    
    if ([self.foursquareConnectionType isEqualToString:@"search"]) {
        NSDictionary *meta = [json objectForKey:@"meta"];
        NSNumber *meta_code=[meta objectForKey:@"code"];
        NSLog(@"%@",meta_code);
        if ([meta_code intValue] == 200) {
            NSDictionary *response = [json objectForKey:@"response"];
            NSArray *venues=[response objectForKey:@"venues"];
            NSNumber *count =[NSNumber numberWithInt:[venues count]];
            NSLog(@"Have %@ elements",count);
            //start to put fetched data in to self.foursquareSearchResults
            for (NSDictionary *venue in venues) {
                FourSquarePlace *place = [FourSquarePlace initializeWithNSDictionary:venue];
                [searchResult addObject:place];
            }
        }
    }
    else {
        NSDictionary *meta = [json objectForKey:@"meta"];
        NSNumber *meta_code=[meta objectForKey:@"code"];
        NSLog(@"%@",meta_code);
        if ([meta_code intValue] == 200) {
            NSDictionary *response = [json objectForKey:@"response"];
            NSArray *groups=[response objectForKey:@"groups"];
            NSDictionary *group=[groups objectAtIndex:0];
            NSArray *items=[group objectForKey:@"items"];
            
            //start to put fetched data in to self.foursquareSearchResults
            for (NSDictionary *item in items) {
                FourSquarePlace *place = [FourSquarePlace initializeWithNSDictionary:[item objectForKey:@"venue"]];
                [searchResult addObject:place];
            }
        }
    }
    self.foursquareSearchResults=[searchResult sortedArrayUsingSelector:@selector(compare:)];//sorting the result using distance from the current location
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
    NSString *venue_title=(place.name)?place.name:@"No name";
    if (place.categories_shortName) {
        venue_title=[NSString stringWithFormat:@"%@ (%@)",venue_title,place.categories_shortName];
    }
    NSString *crossStreet=(place.crossStreet);
    //show the place name and location
    [cell.textLabel setText:venue_title];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:DEFAULT_TABLE_CELL_FONT_SIZE]];
    if (place.crossStreet) {
        NSString *detail=[NSString stringWithFormat:@"%@ (%@ m)",crossStreet,place.distance];
        [cell.detailTextLabel setText:detail];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:DEFAULT_TABLE_CELL_SUBTITLE_SIZE]];
    }
    else {
        [cell.detailTextLabel setHidden:TRUE];
        cell.selectionStyle = UITableViewCellStyleDefault;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
//deal with the selection of the outside table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FourSquarePlace *place=[self.foursquareSearchResults objectAtIndex:indexPath.row];
    NSString *venue_title=(place.name)?place.name:@"No name";
    if (place.categories_shortName) {
        venue_title=[NSString stringWithFormat:@"%@ (%@)",venue_title,place.categories_shortName];
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
    annotationPoint.title = venue_title;
    if (place.crossStreet) {
        annotationPoint.subtitle = [NSString stringWithFormat:@"%@ (%@ m)",place.crossStreet,place.distance];
    }
    [self.delegate selectWithAnnotation:annotationPoint DrawMapInTheRegion:region];
    [self.myTableView setContentOffset:CGPointZero animated:YES];
}

@end
