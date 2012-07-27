//
//  SettingPageViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingPageViewController.h"

@interface SettingPageViewController ()
@end

@implementation SettingPageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Navigation Bar Style
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStylePlain
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.84111 green:0.5373 blue:0.1 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)logoutStarted:(id)sender {
    //logout from facebook
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    if (!funAppdelegate.facebook) {
        funAppdelegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)funAppdelegate];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        NSLog(@"%@",funAppdelegate.facebook.accessToken);
        funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
        [funAppdelegate.facebook logout:funAppdelegate];
        
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

@end
