//
//  MoreTableViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/27/12.
//
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()<MFMailComposeViewControllerDelegate>
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
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.signOutButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    
    
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
    UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Are you sure that you would like to sign out?" delegate:self  cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel",nil];
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
        if (indexPath.row==1) {
            //start compose email
            NSMutableArray *emailList=[NSMutableArray array];
            [emailList addObject:@"contact@orangeparc.com"];
            //we have the email list, now try to send email invitation
            if([MFMailComposeViewController canSendMail]) {
                //if the device allowed sending email
                MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                mailCont.mailComposeDelegate = self;
            
                //email list
                [mailCont setToRecipients:emailList];
                
                //go!
                [self presentModalViewController:mailCont animated:YES];
            }
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - self defined method
-(void)likeUsOnFaceBook{
    UIAlertView *likeUsOnFaceBook = [[UIAlertView alloc] initWithTitle:nil message:@"Like us on Facebook?" delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
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
            
            ///////////////////////////////////////////////////////////////////////////
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
                [request setRequestMethod:@"DELETE"];
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
                        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
                            [funAppdelegate.thisTabBarController setSelectedIndex:0];
                        }
                        else{
                            UIAlertView *error = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Logout did not succeed. %@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            error.delegate=self;
                            [error show];
                        }
                    }
                    
                });
                
            });
            
            
            
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
//                NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                        @"publish_stream",
//                                        @"read_stream",@"create_event",@"email",
//                                        nil];
                NSArray *permissions = [[NSArray alloc] initWithObjects:
                                        @"publish_stream",
                                        @"email",
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
}


#pragma mark - implement protocals <MFMessageComposeViewControllerDelegate>
////////////////////////////////////////////////
//implement the MFMailComposeViewControllerDelegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        NSLog(@"Sending Email Error Happended!");
    }
    [self dismissModalViewControllerAnimated:YES];
}


@end
