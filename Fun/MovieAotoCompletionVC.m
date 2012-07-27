//
//  MovieAotoCompletionVC.m
//  Fun
//
//  Created by Tongda Zhang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MovieAotoCompletionVC.h"
#import "GlobalConstant.h"

@interface MovieAotoCompletionVC ()

@property(nonatomic,strong) NSArray *searchResult;
@property(nonatomic,strong) NSMutableData *data;

@end

@implementation MovieAotoCompletionVC
@synthesize delegate=_delegate;
@synthesize searchResult=_searchResult;
@synthesize data=_data;

#pragma mark - View Life Circle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //preset the search bar to be the first responser
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - auto rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - implement the UISeachBar protocal
//Showing the location that User Searched, using Apple API
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString* searchString=self.searchDisplayController.searchBar.text;
    NSString* keyword=[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //if (searchLength<3||((searchLength-4)%2)!=0) {
    //    return NO;
    //}
    
    // else{
    //Searching the key word
    //http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=ted&page_limit=5&apikey=fsdtjhkez9txeuj86n9b83ba
    NSString *request_string=[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=%@&page_limit=10&apikey=%@",keyword,ROTTENTOMATOE_APIKEY];
    NSLog(@"%@",request_string);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    //[searchBar setText:@""];
    //[searchBar resignFirstResponder];
}

//Start when searchBar text changed,find the user searched result from fousqure, and save them to self.foursquareSearchResults

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    //in case the frequency of searching is too high
    //int searchLength=[searchString length];
    NSString* keyword=[searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    //if (searchLength<3||((searchLength-4)%2)!=0) {
    //    return NO;
    //}
    
   // else{
        //Searching the key word
        //http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=ted&page_limit=5&apikey=fsdtjhkez9txeuj86n9b83ba
        NSString *request_string=[NSString stringWithFormat:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json?q=%@&page_limit=10&apikey=%@",keyword,ROTTENTOMATOE_APIKEY];
        NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start]; 
    //}
    return YES;
}


#pragma mark - implement the search display results
//return the table row number
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    if ([tableView 
         isEqual:self.searchDisplayController.searchResultsTableView]){
        rows = [self.searchResult count];
    }
    return rows;
}

// Customize the appearance of table view cells (of the seach result display)
- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"movieAutoCompleteCell";
    

    movieAutoCCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"movieAutoCompleteCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (movieAutoCCell*)view;
            }
        }
    }
    rottenTomatoMovieModel *model=[self.searchResult objectAtIndex:indexPath.row];
    
    //show the place name and location

    [cell.labelTitle setText:model.title];
    [cell.labelYear setText:model.year];
    [cell.labelRating setText:model.mpaa_rating];
    [cell.labelScore setText:model.score];
    if ([Cache isURLCached:[NSURL URLWithString:model.imageUrl]]) {
        [cell.imageView setImage:[UIImage imageWithData:[Cache getCachedData:[NSURL URLWithString:model.imageUrl]]]];
    }
    return cell;
}
//response to user selection of the search result
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if the notificaiton is from the user select search results
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        [self.searchDisplayController setActive:NO];
        [self.delegate movieInfoReturn:[self.searchResult objectAtIndex:indexPath.row] from:self];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
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
    self.searchResult=[rottenTomatoMovieModel initializeWithJsonData:self.data];
    
    
    for (rottenTomatoMovieModel *model in self.searchResult) {
        if (model.imageUrl) {
            NSURL *url=[NSURL URLWithString:model.imageUrl];
            if (![Cache isURLCached:url]) {
                //using high priority queue to fetch the image
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
                    
                    //get the image data
                    NSData * imageData = nil;
                    imageData = [[NSData alloc] initWithContentsOfURL: url];
                    
                    if ( imageData == nil ){
                        //if the image data is nil, the image url is not reachable. using a default image to replace that
                        //NSLog(@"downloaded %@ error, using a default image",url);
                        UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
                        imageData=UIImagePNGRepresentation(image);
                        
                        if(imageData)[Cache addDataToCache:url withData:imageData];
                        dispatch_async( dispatch_get_main_queue(),^{
                        [self.searchDisplayController.searchResultsTableView reloadData]; 
                        });
                    }
                    else {
                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                        //NSLog(@"downloaded %@",url);
                        if(imageData)[Cache addDataToCache:url withData:imageData];
                        dispatch_async( dispatch_get_main_queue(),^{
                        [self.searchDisplayController.searchResultsTableView reloadData];  
                        });
                    }
                });
            }
        }
        /*
        NSLog(@"%@",model.title);
        NSLog(@"%@",model.imageUrl);
        NSLog(@"%@",model.year);
        NSLog(@"%@",model.score);
        NSLog(@"-=--------------");
         */
    }
     
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}


@end
