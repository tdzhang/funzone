//
//  LoginPageViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginPageViewController.h"

@interface LoginPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (nonatomic,strong) NSMutableData *data;
@property (weak, nonatomic) IBOutlet UIButton *normalLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookLoginButton;
@end

@implementation LoginPageViewController
@synthesize userName;
@synthesize userPassword;
@synthesize normalLoginButton;
@synthesize facebookLoginButton;
@synthesize data=_data;

#pragma mark - view life cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //set the password field property
    self.userPassword.secureTextEntry=YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setUserName:nil];
    [self setUserPassword:nil];
    [self setNormalLoginButton:nil];
    [self setFacebookLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button action
- (IBAction)normalLoginButtonClicked:(id)sender {
    /*
     NSString *request_string=[NSString stringWithFormat:@"https://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=%d&q=%@",GOOGLE_IMAGE_NUM,searchKeywords];
     NSLog(@"%@",request_string);
     //start the image seaching connection using google image api
     NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
     NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
     [connection start];
     */
}

- (IBAction)facebookLoginButtonClicked:(id)sender {
    /*
    //initial the face book
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    if (!funAppdelegate.facebook) {
        funAppdelegate.facebook = [[Facebook alloc] initWithAppId:@"433716793339720" andDelegate:(id)funAppdelegate];
        
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
                                    nil];
            [funAppdelegate.facebook authorize:permissions];
        }
    }
    
    
    //get the photo of the user 
    FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"id,picture" forKey:@"fields"];
    if ([delegate.facebook isSessionValid]) {
        self.currentFacebookConnect=@"get user photo and id";
        [delegate.facebook requestWithGraphPath:@"me" 
                                      andParams:params 
                                  andHttpMethod:@"GET" 
                                    andDelegate:self];
    }
    else {
        NSLog(@"Face book session invalid~~~");
    }
  */
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
}


@end
