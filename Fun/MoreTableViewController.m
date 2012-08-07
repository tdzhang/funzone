//
//  MoreTableViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/27/12.
//
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *signOutButton;

@end

@implementation MoreTableViewController
@synthesize signOutButton;

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
    
    //--------Navigation bar and Back button--------//
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.signOutButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    
    
}

- (void)viewDidUnload
{
    [self setSignOutButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

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
- (IBAction)signOutButtonClicked:(id)sender {
    UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Do you want to sign out?" delegate:self  cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel",nil];
    inputEmptyError.delegate=self;
    [inputEmptyError show];
}



#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //like use on face book(start to generate the facebook like  Request)
            [self likeUsOnFaceBook];
            
        }
    }
    else if (indexPath.section ==2){
        /*if (indexPath.row == 2) {
            UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Do you want to sign out?" delegate:self  cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel",nil];
            inputEmptyError.delegate=self;
            [inputEmptyError show];
        }
         */
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - self defined method
-(void)likeUsOnFaceBook{
    UIAlertView *likeUsOnFaceBook = [[UIAlertView alloc] initWithTitle:@"Like Us" message:@"You will post a messgae on wall." delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    likeUsOnFaceBook.delegate=self;
    [likeUsOnFaceBook show];
}
#pragma mark - alertview delegate method implementation
////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@",alertView.title);
    //deal with the Input Empty Error for the activity category choose
    if ([alertView.title isEqualToString:@"Sign Out"]) {
        //NSLog(@"%d",buttonIndex);
        if (buttonIndex == 0) {
            //sign out
            //logout from facebook
            FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
            if (!funAppdelegate.facebook) {
                funAppdelegate.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:(id)funAppdelegate];
            }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
                funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                NSLog(@"%@",funAppdelegate.facebook.accessToken);
                funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
                [funAppdelegate.facebook logout:(id)funAppdelegate];
            }
            
            //signout the auth_token
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_out.json?auth_token=%@",SECURE_DOMAIN_NAME,[defaults objectForKey:@"login_auth_token"]]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            __block ASIFormDataRequest *block_request=request;
            [request setCompletionBlock:^{
                // Use when fetching text data
                NSString *responseString = [block_request responseString];
                NSLog(@"%@",responseString);
                
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
                if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    /*
                    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Log out complete!" message:@"You have successfully logged out." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    success.delegate=self;
                    [success show];
                     */
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
                    [funAppdelegate.thisTabBarController setSelectedIndex:0];
                }
                else{
                    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Logout Error" message:[NSString stringWithFormat:@"The logout is not finished. Some error happened:%@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    error.delegate=self;
                    [error show];
                }
            }];
            [request setFailedBlock:^{
                NSError *error = [block_request error];
                NSLog(@"%@",error.description);
                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Log Out Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                notsuccess.delegate=self;
                [notsuccess show];
            }];
            
            //add login auth_token //add content
            //[request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setRequestMethod:@"DELETE"];
            [request startAsynchronous];
            
            [defaults setValue:nil forKey:@"login_auth_token"];
            [defaults synchronize];
            
        }
        else if(buttonIndex == 1){
            //Cancel
            NSLog(@"Sign Out Cancelled.");
        }
    }
    else if ([alertView.title isEqualToString:@"Like Us"]){
        if (buttonIndex == 0){
            NSLog(@"facebook invite friend.");
            FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
            if (!funAppdelegate.facebook) funAppdelegate.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:(id)funAppdelegate];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
                //if already login : start the action sheet
                funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
                funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
            }
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            [params setObject:@"http://www.orangeparc.com/" forKey:@"object"];
            if ([funAppdelegate.facebook isSessionValid]) {
                [funAppdelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"me/og.likes"]
                                                    andParams:params
                                                andHttpMethod:@"POST"
                                                  andDelegate:self];
            }
            else{
                //if not login, do it
                NSArray *permissions = [[NSArray alloc] initWithObjects:
                                        @"publish_stream",
                                        @"read_stream",@"create_event",@"email",
                                        nil];
                [funAppdelegate.facebook authorize:permissions];
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
            }
        }
    }
}

#pragma mark - facebook related protocal implement
-(void)faceBookLoginFinished{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self likeUsOnFaceBook];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"%@",result);
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Like Success" message: [NSString stringWithFormat:@"Thank you for liking us."] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
    success.delegate=self;
    [success show];
}


@end
