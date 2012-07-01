//
//  ChooseImageTableViewController.m
//  GoogleImageAPIpractice
//
//  Created by Tongda Zhang on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChooseImageTableViewController.h"

@interface ChooseImageTableViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBarImage;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSMutableArray *imageUrls;
@property (nonatomic,strong) NSMutableArray *imageTitles;
//use to cash the image 
@property (nonatomic,strong) NSMutableDictionary *cacheImage;
//use to indicate whether a url is deploying with a spinning activity indicator
@property (nonatomic,strong) NSMutableDictionary *indicatorDictionary;
@end

@implementation ChooseImageTableViewController
@synthesize mySearchBar = _mySearchBar;
@synthesize searchBarImage;
@synthesize data=_data;
@synthesize imageUrls=_imageUrls;
@synthesize imageTitles=_imageTitles;
@synthesize cacheImage=_cacheImage;
@synthesize predefinedKeyWord=_predefinedKeyWord;
@synthesize indicatorDictionary=_indicatorDictionary;

#pragma mark - self define getter and setter
-(NSMutableDictionary *)indicatorDictionary{
    if (_indicatorDictionary==nil) {
        _indicatorDictionary = [NSMutableDictionary dictionary];
    }
    return _indicatorDictionary;
}

-(void)setIndicatorDictionary:(NSMutableDictionary *)indicatorDictionary{
    if (![_indicatorDictionary isEqual:indicatorDictionary]) {
        _indicatorDictionary=indicatorDictionary;
    }
}

-(NSMutableDictionary *)cacheImage{
    if (_cacheImage==nil) {
        _cacheImage = [NSMutableDictionary dictionary];
    }
    return _cacheImage;
}

-(void)setCacheImage:(NSMutableDictionary *)cacheImage{
    if (![_cacheImage isEqual:cacheImage]) {
        _cacheImage=cacheImage;
    }
}


-(NSMutableArray *)imageTitles{
    if (_imageTitles==nil) {
        _imageTitles=[NSMutableArray array];
    }
    return _imageTitles;    
}

-(void)setImageTitles:(NSMutableArray *)imageTitles{
    if (![_imageTitles isEqual:imageTitles]) {
        _imageTitles=imageTitles;
    }
}

-(NSMutableArray *)imageUrls{
    if (_imageUrls==nil) {
        _imageUrls=[NSMutableArray array];
    }
    return _imageUrls;
}

-(void)setImageUrls:(NSMutableArray *)imageUrls{
    if (![_imageUrls isEqual:imageUrls]) {
        _imageUrls=imageUrls;
    }
}

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
    
    //before the user defined search start, load the predefined seach key words
    if (_predefinedKeyWord) {
        [self.mySearchBar setText:_predefinedKeyWord];
        NSString* searchKeywords=[_predefinedKeyWord stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSString *request_string=[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=%d&q=%@",GOOGLE_IMAGE_NUM,searchKeywords];
        // NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setSearchBarImage:nil];
    [self setMySearchBar:nil];
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
    //NSLog(@"count:%d",[self.imageUrls count]);
    return [self.imageUrls count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *CellIdentifier = @"ImageTableCell";
        
    ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ImageTableCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (ImageTableViewCell*)view;
            }
        }
    }
    // Configure the cell...if the range is not right return empty table cell
    if ([self.imageUrls count]<=indexPath.row) return cell;
    
    NSString* urlString=[self.imageUrls objectAtIndex:indexPath.row];
    //if the image url can be found in the temp cache, get the image from the cache
    if ([self.cacheImage objectForKey:urlString]) { 
        [cell.imageViewContent setImage:[UIImage imageWithData:(NSData*)[self.cacheImage objectForKey:urlString]]];
    } 
    //if the image can not be found in the temp cache, which means the image is still in the fetching process, so here we add the spinning activity indicator
    else if(![self.indicatorDictionary objectForKey:urlString]) {
        //NSLog(@"lack url :%@",urlString);
        //NSLog(@"%d",indexPath.row);
        UIView *loading = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 120, 120)]; 
        loading.opaque = NO;
        loading.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.6f];
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, 81, 22)];
        loadLabel.text = @"Loading";
        loadLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment = UITextAlignmentCenter;
        loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        loadLabel.backgroundColor = [UIColor clearColor];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame = CGRectMake(42, 54, 37, 37);
        [spinning startAnimating];
        [loading addSubview:spinning];
        
        loading.frame = CGRectMake(100, 200, 120, 120);
        [cell addSubview:loading];
        //after adding the indicator, it need to be saved to indicatorDictionary, to make the image fetching block can delete the indicator for the table cell view when it finished.
        [self.indicatorDictionary setObject:loading forKey:urlString];
        // NSLog(@"add indicator url:%@",urlString);
        
    }
    [cell.labelTitle setText:[self.imageTitles objectAtIndex:indexPath.row]];
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
#pragma mark - UIseachBar delegate method implement
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
}

//deal with the seaching button clicked
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //get the searching key words from the UISearchBar
    NSString* searchKeywords=[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSString *request_string=[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=%d&q=%@",GOOGLE_IMAGE_NUM,searchKeywords];
    NSLog(@"%@",request_string);
    //start the image seaching connection using google image api
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    [searchBar resignFirstResponder];
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
    //NSLog(@"%@",connection.originalRequest.URL);
    //NSLog(@"%@",error);
}


//when the connection get the returned data (json form)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {     
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    NSLog(@"all %@",[json allKeys]);
    NSDictionary* responseData = [json objectForKey:@"responseData"];
    NSArray *results = [responseData objectForKey:@"results"];
    NSLog(@"get %d results",[results count]);
    
    //update the imageURLs and ImageTitles (the property of this table view)
    [self.imageUrls removeAllObjects];  
    [self.imageTitles removeAllObjects];
    
    for (NSDictionary* result in results) {
        NSString *url=nil;
        NSString *title=nil;
        url=[result objectForKey:@"url"];
        [self.imageUrls addObject:url];//add the new image url
        title=[result objectForKey:@"contentNoFormatting"];
        [self.imageTitles addObject:title]; //add the new image title
        
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
            
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:url]];
            
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                [self.cacheImage setObject:imageData forKey:url];
                [self.tableView reloadData]; 
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and them reload the table view data.
                //NSLog(@"downloaded %@",url);
                [self.cacheImage setObject:imageData forKey:url];
                [self.tableView reloadData]; 
            }
         
            //when the image fetching thread is done, delete the spining activity indicator
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.indicatorDictionary objectForKey:url]) {
                    UIView *loading=nil;
                    loading=(UIView *)[self.indicatorDictionary objectForKey:url];
                    [loading removeFromSuperview];
                    [self.indicatorDictionary removeObjectForKey:url];
                    //NSLog(@"delete 1 subview:%@",url);
                }
            });	
           
       });
        
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
