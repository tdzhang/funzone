//
//  MyFollowerTableViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/6/12.
//
//

#import "MyFollowerTableViewController.h"

@interface MyFollowerTableViewController ()
@property (nonatomic,strong)NSMutableArray *arrayProfileInfoElements;
@property (nonatomic,strong)NSArray* lastReceivedJson; //used to limite the refresh frequency
@end

@implementation MyFollowerTableViewController
@synthesize arrayProfileInfoElements=_arrayProfileInfoElements;
@synthesize lastReceivedJson=_lastReceivedJson;
@synthesize other_user_id=_other_user_id;

#pragma mark - self defined setter getter
-(NSArray *)arrayProfileInfoElements{
    if (!_arrayProfileInfoElements) {
        _arrayProfileInfoElements=[NSMutableArray array];
    }
    return _arrayProfileInfoElements;
}

-(NSArray *)lastReceivedJson{
    if (!_lastReceivedJson) {
        _lastReceivedJson=[NSArray array];
    }
    return _lastReceivedJson;
}

#pragma mark - View Life Circle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    //query the user profile information
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/followers?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
    if (self.other_user_id) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/followers?auth_token=%@&user_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.other_user_id]];
    }
    NSLog(@"request following:%@",url);
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                // Use when fetching text data
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson]]) {
                    //if there is a difference, start to fetch data
                    self.lastReceivedJson=json;
                    self.arrayProfileInfoElements=[[ProfileInfoElement generateProfileInfoElementArrayFromJson:json] mutableCopy];
                    NSLog(@"%d",[self.arrayProfileInfoElements count]);
                    [self.tableView reloadData];
                }
            }
            else{
                //connect error
//                NSError *error = [request error];
//                NSLog(@"%@",error.description);
//                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Error getting user profile" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//                notsuccess.delegate=self;
//                //[notsuccess show];
            }
            
        });
        
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - self defined method
- (void) buttonPressed: (id) sender withEvent: (UIEvent *) event
{
    UITouch * touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView: self.tableView];
    NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint: location];
    
    ProfileInfoElement*element=[self.arrayProfileInfoElements objectAtIndex:indexPath.row];
    //add login auth_token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int send_via=0;
    if (self.other_user_id){
        send_via=VIA_OTHERS_FOLLOWERS;
    }
    else{
        send_via=VIA_MY_FOLLOWERS;
    }
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/unfollow?followee_id=%@&auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,element.user_id,[defaults objectForKey:@"login_auth_token"],send_via]];
    if (!element.followed) {
        //if not followed
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/follow?auth_token=%@&followee_id=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],element.user_id,send_via]];
    }
    NSLog(@"request: %@",url);
    
    
    
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                // Use when fetching text data
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    NSLog(@"cool");
                }
                else {
                    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Unfollow Error" message:[NSString stringWithFormat:@"The unfollow is not finished. Some error happened:%@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    error.delegate=self;
                    //[error show];
                }
            }
            else{
                //connect error
//                NSError *error = [request error];
//                NSLog(@"%@",error.description);
//                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Error getting unfollow!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
//                notsuccess.delegate=self;
                //[notsuccess show];
            }
            
        });
        
    });
    
    
    
    
//    if (!self.other_user_id) {
//        [self.arrayProfileInfoElements removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
//    }
//    else{
        if (element.followed) {
            [[self.arrayProfileInfoElements objectAtIndex:indexPath.row] setFollowed:NO];
        }
        else{
            [[self.arrayProfileInfoElements objectAtIndex:indexPath.row] setFollowed:YES];
        }
        [self.tableView reloadData];
//    }
    /* indexPath contains the index of the row containing the button */
    /* do whatever it is you need to do with the row data now */
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
    return [self.arrayProfileInfoElements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyFollowingTableViewCell";
    
    MyFollowingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"MyFollowingTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (MyFollowingTableViewCell*)view;
            }
        }
    }
    //deal with the cell part
    ProfileInfoElement* element=[self.arrayProfileInfoElements objectAtIndex:indexPath.row];
    [cell.profileNameLabel setText:element.user_name];
    cell.user_id=element.user_id;
    cell.user_name=element.user_name;
    cell.user_pic=element.user_pic;
    cell.facebook_id=element.facebook_id;
    if (element.followed) {
        [cell.unfollowButton setTitle:@"Unfollow" forState:UIControlStateNormal];
    }
    else{
        [cell.unfollowButton setTitle:@"Follow" forState:UIControlStateNormal];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"user_id"] isEqualToString:cell.user_id]) {
        [cell.unfollowButton setTitle:@"Me" forState:UIControlStateNormal];
        [cell.unfollowButton setEnabled:NO];
    }
    else{
        [cell.unfollowButton setEnabled:YES];
    }
    
    [cell.unfollowButton addTarget: self
                            action: @selector(buttonPressed:withEvent:)
                  forControlEvents: UIControlEventTouchUpInside];
        
    //set the profile image
    NSURL* backGroundImageUrl=[NSURL URLWithString:cell.user_pic];
    if (![Cache isURLCached:backGroundImageUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: backGroundImageUrl];
            if (imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:backGroundImageUrl withData:imageData];
                        [cell.profileImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:backGroundImageUrl withData:imageData];
                        [cell.profileImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [cell.profileImageView setImage:[UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]]];
        });
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
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
