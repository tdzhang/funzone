//
//  FIndTopTableViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "FIndTopTableViewController.h"

@interface FIndTopTableViewController ()
@property(nonatomic,strong)NSArray* topfriends;
@end

@implementation FIndTopTableViewController
@synthesize topfriends=_topfriends;

#pragma mark - self defined setter and getter
-(NSArray *)topfriends{
    if (!_topfriends){
        _topfriends=[NSArray new];
    }
    return _topfriends;
}

-(void)setTopfriends:(NSArray *)topfriends{
    if (![_topfriends isEqual:topfriends]) {
        _topfriends=[topfriends copy];
    }
}

#pragma mark - View Life Cycle
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
    
    //initial the face book
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    if (!funAppdelegate.facebook) {
        funAppdelegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)funAppdelegate];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        NSLog(@"%@",funAppdelegate.facebook.accessToken);
        funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![funAppdelegate.facebook isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                @"read_stream",@"create_event",
                                @"email",
                                nil];
        [funAppdelegate.facebook authorize:permissions];
    }
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/top_users",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
        
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
        self.topfriends=[SearchedFriend TopFriendsWithJson:json];
        //NSLog(@"%d",[self.topfriends count]);
        [self.tableView reloadData];
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        /*
         UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Upload Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
         notsuccess.delegate=self;
         [notsuccess show];
         */
    }];
    
    //add login auth_token //add content
    defaults = [NSUserDefaults standardUserDefaults];
    [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.topfriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FindFriendTableViewCell";
    
    
    FindFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"FindFriendTableViewCell" owner:nil options:nil];
        
        for (UIView *view in views) {
            if([view isKindOfClass:[UITableViewCell class]])
            {
                cell = (FindFriendTableViewCell*)view;
            }
        }
    }
    
    [cell resetWithTopFriend:[self.topfriends objectAtIndex:indexPath.row]];
    
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