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

-(void)faceBookLoginFinished; //deal with the finish of facebook login
@end

@implementation LoginPageViewController
@synthesize userName;
@synthesize userPassword;
@synthesize normalLoginButton;
@synthesize facebookLoginButton;
@synthesize data=_data;
@synthesize currentConnection;

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
    
    //add notification handler
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
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
    //resign the firstResponser
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
    
    //if the name/password is too short, alert user
    if ([self.userName.text length]<4||[self.userPassword.text length]<5) {
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"User Name/Password Error" message:@"Your name/password is too short, please input again." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        [tooShort show];
        return;
    }
    
    
    //login
    self.currentConnection=@"normalEmailLogin_register";
    NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/users/sign_in.json?iphone=true&user[email]=%@&user[password]=%@",self.userName.text,self.userPassword.text];
    NSLog(@"%@",request_string);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    
    /*log out
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/users/sign_out.json?auth_token=%@",[defaults objectForKey:@"login_auth_token"]];
    NSLog(@"%@",request_string);
    [defaults removeObjectForKey:@"login_auth_token"];
    [defaults synchronize];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    [request setHTTPMethod:@"DELETE"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
     */
}

- (IBAction)facebookLoginButtonClicked:(id)sender {
    
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
                                    @"email",
                                    nil];
            [funAppdelegate.facebook authorize:permissions];
        }
    }
}

#pragma mark - facebook related process
-(void)faceBookLoginFinished{
    //when the facebook has login, send to the sever to get the user token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/users/sign_in?iphone=true&facebook_token=%@",[defaults objectForKey:@"FBAccessTokenKey"]];
    NSLog(@"%@",request_string);
    //start connection
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    self.currentConnection=@"facebookLogin";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
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
            [defaults synchronize];
            //then return to the previouse page, quit login page
            [self dismissModalViewControllerAnimated:YES];
        }
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
     //   [self animateTextField: textField up: YES];
     //   self.uIViewUpFlag=YES;
    //}
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    //if finished editign the add cost textfield, the whole view need to scroll down
    //if ([textField isEqual:self.textFieldSelfDefine]) {
    //    [self animateTextField: textField up: NO];
     //   self.uIViewUpFlag=NO;
    //}
    
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


@end
