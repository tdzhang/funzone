//
//  FindFriendTableViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "FindFriendTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "Flurry.h"



@interface FindFriendTableViewController ()

@property(nonatomic,strong)NSArray* friends;
@property(nonatomic,strong)NSString* tapped_creator_id;

@end

@implementation FindFriendTableViewController

@synthesize friends=_friends;
@synthesize tapped_creator_id=_tapped_creator_id;

#pragma mark - self defined setter and getter
-(NSArray *)friends{
    if (!_friends){
        _friends=[NSArray new];
    }
    return _friends;
}

-(void)setFriends:(NSArray *)friends{
    if (![_friends isEqual:friends]) {
        _friends=[friends copy];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor =  [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
   self.navigationItem.leftBarButtonItem.tintColor =  [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [Flurry logEvent:FLURRY_ENTER_FINDFACEBOOKFRIEND];
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
//        NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                @"publish_stream",
//                                @"read_stream",@"create_event",
//                                @"email",
//                                nil];
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                @"email",
                                nil];
        [funAppdelegate.facebook authorize:permissions];
    }
    
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/facebook_friends",CONNECT_DOMIAN_NAME]];
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        //add login auth_token //add content
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
        [request setPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"access_token"];
        [request setRequestMethod:@"POST"];
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
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                self.friends=[SearchedFriend SearchedFriendsWithJson:json];
                NSLog(@"%d",[self.friends count]);
                
                [self.tableView reloadData];
            }
            else{
                //connect error
//                NSError *error = [request error];
//                NSLog(@"%@",error.description);
            }
            
        });
        
    });
    
    self.navigationItem.leftBarButtonItem.tintColor =  [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];;
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
    return [self.friends count];
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

    [cell resetWithSearchedFriend:[self.friends objectAtIndex:indexPath.row] AtIndexPath:indexPath];
    cell.friendImageView.layer.cornerRadius = 4;
    cell.friendImageView.clipsToBounds = YES;
    [cell.friendImageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.friendImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    cell.friendImageView.layer.borderWidth = 1;
    
    cell.via=VIA_FACEBOOK_SEARCH;
    cell.delegate=self;
    return cell;
}

#pragma mark - findFriendTVCDelegate method
-(void)changeTheFollowStateAtIndex:(NSIndexPath *)indexPath{
    SearchedFriend* friend=[self.friends objectAtIndex:indexPath.row];
    if (friend.followed) {
        friend.followed=NO;
    } else {
        friend.followed=YES;
    }
}

-(void)UsersProfilePhotoTouchedWithUserID:(NSString*)user_id{
    self.tapped_creator_id=user_id;
    if (!user_id) {
        //if the user is not register yet, can not be touched
        return;
    } 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *myid=[defaults objectForKey:@"user_id"];
    if ([myid isEqualToString:user_id]) {
        [self performSegueWithIdentifier:@"ViewProfile" sender:self];
    }
    else {
        [self performSegueWithIdentifier:@"ViewOthersProfile" sender:self];
    }
}

#pragma mark - segue related
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ViewOthersProfile"]){
        OtherProfilePageViewController* OPPVC=segue.destinationViewController;
        OPPVC.creator_id=self.tapped_creator_id;
        OPPVC.via=VIA_FIND_TOPFRIEND;
    }
    else if([segue.identifier isEqualToString:@"ViewProfile"]){
        ProfilePageViewController* PVVC=segue.destinationViewController;
        PVVC.via=VIA_FIND_TOPFRIEND;
    }
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


#pragma mark - searchBar delegate
//Showing the location that User Searched, using Apple API
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    if ([searchBar.text length]==0) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/facebook_friends",CONNECT_DOMIAN_NAME]];       
        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //add login auth_token //add content
            defaults = [NSUserDefaults standardUserDefaults];
            [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"access_token"];
            [request setRequestMethod:@"POST"];
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
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    self.friends=[SearchedFriend SearchedFriendsWithJson:json];
                    NSLog(@"%d",[self.friends count]);
                    [self.tableView reloadData];
                }
                else{
                    //connect error
//                    NSError *error = [request error];
//                    NSLog(@"%@",error.description);
                }
                
            });
            
        });
    }
    else {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/find_friends",CONNECT_DOMIAN_NAME]];
        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //add login auth_token //add content
            defaults = [NSUserDefaults standardUserDefaults];
            [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setPostValue:searchBar.text forKey:@"query"];
            [request setPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"access_token"];
            [request setRequestMethod:@"POST"];
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
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    self.friends=[SearchedFriend SearchedFriendsWithJson:json];
                    NSLog(@"%d",[self.friends count]);
                    [self.tableView reloadData];
                }
                else{
                    //connect error
//                    NSError *error = [request error];
//                    NSLog(@"%@",error.description);
                }
            });
            
        });
        
        
        [searchBar resignFirstResponder];
    }
    
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar setText:@""];
}


@end
