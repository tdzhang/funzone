//
//  MoreTableViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/27/12.
//
//

#import "MoreTableViewController.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

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
    else if (indexPath.section == 1){
    }
    else if (indexPath.section ==2){
        if (indexPath.row == 2) {
            UIAlertView *inputEmptyError = [[UIAlertView alloc] initWithTitle:@"Sign Out" message:@"Do you want to sign out?" delegate:self  cancelButtonTitle:@"Yes" otherButtonTitles:@"Cancel",nil];
            inputEmptyError.delegate=self;
            [inputEmptyError show];
        }
    }
    
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
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_out.json?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            __block ASIFormDataRequest *block_request=request;
            [request setCompletionBlock:^{
                // Use when fetching text data
                NSString *responseString = [block_request responseString];
                NSLog(@"%@",responseString);
                
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
                if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Log out complete!" message:@"You have successfully logged out." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    success.delegate=self;
                    [success show];
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

}

@end
