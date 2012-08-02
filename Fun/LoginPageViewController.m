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
@property (nonatomic,strong) NSString *currentConnection;
@property (nonatomic,strong) CLLocationManager *myLocationManager;


-(void)faceBookLoginFinished; //deal with the finish of facebook login
@end

@implementation LoginPageViewController
@synthesize userName;
@synthesize userPassword;
@synthesize normalLoginButton;
@synthesize facebookLoginButton;
@synthesize data=_data;
@synthesize currentConnection;
@synthesize parentVC=_parentVC;
@synthesize myLocationManager=_myLocationManager;

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
    //ask user to require location
    CLLocationManager *current_location_manager = [[CLLocationManager alloc] init];
    [current_location_manager startUpdatingLocation];
    self.myLocationManager=current_location_manager;
    
    //[current_location_manager stopUpdatingLocation];
    //set the password field property
    self.userPassword.secureTextEntry=YES;
    
    //add notification receiver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.myLocationManager stopUpdatingLocation];
    //delete notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [PushNotificationHandler SendAPNStokenToServer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //add notification handler
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
- (IBAction)cancelLoginNew:(id)sender {
    //if user don't login,return to the featurned page
    int controllerIndex=0;
    UIView * fromView = self.parentVC.tabBarController.selectedViewController.view;
    UIView * toView = [[self.parentVC.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    // Position it off screen.
    toView.frame = CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
    [UIView animateWithDuration:0.01 
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];              
                         }
                     }];
    self.parentVC.tabBarController.selectedIndex = controllerIndex; 
    [self dismissModalViewControllerAnimated:YES];
}



//Start normal login
- (IBAction)normalLoginButtonClickedNew:(id)sender {
    //resign the firstResponser
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
    
    //if the name/password is too short, alert user
    if ([self.userName.text length]<4||[self.userPassword.text length]<5) {
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"Username / Password Error" message:@"Your name/password is wrong, please input again." delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [tooShort show];
        return;
    }
    //login
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_in.json",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data        
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
        NSLog(@"all %@",[json allKeys]);
        //if login success, then return to the page
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            //save the login_auth_token for later use
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *login_auth_token=[json objectForKey:@"auth_token"];
            [defaults setValue:login_auth_token forKey:@"login_auth_token"];
            [defaults setValue:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_id"]] forKey:@"user_id"];
            [defaults synchronize];
            //then return to the previouse page, quit login page
            [self dismissModalViewControllerAnimated:YES];
        }
        else {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[NSString stringWithFormat:@"The registration is not finished. Some error happened:%@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            error.delegate=self;
            [error show];
        }
    }];
    [request setFailedBlock:^{
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The registration is not finished. Some error happened" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        error.delegate=self;
        [error show];
    }];
    
    [request setPostValue:self.userName.text forKey:@"user[email]"];
    [request setPostValue:self.userPassword.text forKey:@"user[password]"];
    [request setPostValue:@"true" forKey:@"iphone"];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
}




//start facebook login
- (IBAction)facebookLoginButtonClickedNew:(id)sender {    
    
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
}



#pragma mark - facebook related process
-(void)faceBookLoginFinished{
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/sign_in",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:block_request.responseData options:kNilOptions error:&error];
        NSLog(@"all %@",[json allKeys]);
        //if login success, then return to the page
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            //save the login_auth_token for later use
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *login_auth_token=[json objectForKey:@"auth_token"];
            [defaults setValue:login_auth_token forKey:@"login_auth_token"];
            NSLog(@"%@",login_auth_token);
            [defaults setValue:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_id"]] forKey:@"user_id"];
            NSLog(@"%@",[json objectForKey:@"user_id"]);
            [defaults synchronize];
            //then return to the previouse page, quit login page
            [self dismissModalViewControllerAnimated:YES];
        }
        else {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Login Error" message:[NSString stringWithFormat:@"The login is not finished. Some error happened:%@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            error.delegate=self;
            [error show];
        }
    }];
    [request setFailedBlock:^{
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"The login is not finished. Some error happened" delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        error.delegate=self;
        [error show];
    }];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [request setPostValue:[defaults objectForKey:@"FBAccessTokenKey"] forKey:@"facebook_token"];
    [request setPostValue:@"true" forKey:@"iphone"];
    [request setRequestMethod:@"POST"];
    [request startAsynchronous];
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
    if ([self.currentConnection isEqualToString:@"facebookLogin"]) {
        self.currentConnection=nil;
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        NSLog(@"all %@",[json allKeys]);
        //if login success, then return to the page
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            //save the login_auth_token for later use
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *login_auth_token=[json objectForKey:@"auth_token"];
            [defaults setValue:login_auth_token forKey:@"login_auth_token"];
            [defaults setValue:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_id"]] forKey:@"user_id"];
            NSLog(@"%@",[json objectForKey:@"user_id"]);
            [defaults synchronize];
            //then return to the previouse page, quit login page
            [self dismissModalViewControllerAnimated:YES];
        }
    }
    else if([self.currentConnection isEqualToString:@"normalEmailLogin_register"]){
        self.currentConnection=nil;
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        NSLog(@"all %@",[json allKeys]);
        //if login success, then return to the page
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            //save the login_auth_token for later use
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *login_auth_token=[json objectForKey:@"auth_token"];
            [defaults setValue:login_auth_token forKey:@"login_auth_token"];
            [defaults setValue:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_id"]] forKey:@"user_id"];
            [defaults synchronize];
            //then return to the previouse page, quit login page
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"12345"]) {
        NSLog(@"12312342");
    }
}

#pragma mark - testfield delegate method
////////////////////////////////////////////////
//implement the method for dealing with the textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//the next 3 method deal with the keyboard covering with the text field
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    //if edit the add cost textfield, the whole view need to 
    //scroll up, get rid of the keyboard covering
    //if ([textField isEqual:self.textFieldSelfDefine]) {
        [self animateTextField: textField up: YES];
     //   self.uIViewUpFlag=YES;
    //}
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //if finished editign the add cost textfield, the whole view need to scroll down
    //if ([textField isEqual:self.textFieldSelfDefine]) {
       [self animateTextField: textField up: NO];
     //   self.uIViewUpFlag=NO;
    //}
    
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 120; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
