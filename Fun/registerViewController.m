//
//  registerViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "registerViewController.h"

@interface registerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *currentConnection;
@end

@implementation registerViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize rePasswordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize data=_data;
@synthesize currentConnection=_currentConnection;

#pragma mark - View life cycle
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
    
    //add notification receiver
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    //delete notification
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.passwordTextField.secureTextEntry = YES;
    self.rePasswordTextField.secureTextEntry = YES;
}

- (void)viewDidUnload
{
    [self setEmailTextField:nil];
    [self setPasswordTextField:nil];
    [self setRePasswordTextField:nil];
    [self setFirstNameTextField:nil];
    [self setLastNameTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self define helper method
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; 
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

#pragma mark - button action
//cancel register
- (IBAction)cancelRegisterNew:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


//start to register
- (IBAction)registerButtonBlicked:(id)sender {
    //input too short
    if (self.firstNameTextField.text.length<1||self.lastNameTextField.text.length<1||self.emailTextField.text.length<5||self.passwordTextField.text.length<6||self.rePasswordTextField.text.length<6) {
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"Name/Email/Password Too Short" message:@"The Name, Email or the password you input is too short, please input a again." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        tooShort.delegate=self;
        [tooShort show];
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.rePasswordTextField resignFirstResponder];
        return;
    }
    if(![self NSStringIsValidEmail:self.emailTextField.text]){
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"Email Invalid" message:@"The Email you input is not valid, please input a again." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        tooShort.delegate=self;
        [tooShort show];
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.rePasswordTextField resignFirstResponder];
        [self.emailTextField setText:@""];
        return;
    }
    //the password not match
    if(![self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]){
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"Password Not Match" message:@"The password doesnot match, please input a again." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        tooShort.delegate=self;
        [tooShort show];
        [self.firstNameTextField resignFirstResponder];
        [self.lastNameTextField resignFirstResponder];
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.rePasswordTextField resignFirstResponder];
        [self.passwordTextField setText:@""];
        [self.rePasswordTextField setText:@""];
        return;
    }
    //else, start too register
    
    NSString *request_string=[NSString stringWithFormat:@"%@/users.json?user[first_name]=%@&user[last_name]=%@&user[email]=%@&user[password]=%@&user[password_confirmation]=%@",CONNECT_DOMIAN_NAME,self.firstNameTextField.text,self.lastNameTextField.text,self.emailTextField.text,self.passwordTextField.text,self.rePasswordTextField.text];
    NSLog(@"%@",request_string);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)stillWantToSignInWithFaceBook:(id)sender {

    
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
    //when the facebook has login, send to the sever to get the user token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *request_string=[NSString stringWithFormat:@"%@/users/sign_in?iphone=true&facebook_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"FBAccessTokenKey"]];
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
            [defaults setValue:[NSString stringWithFormat:@"%@",[json objectForKey:@"user_id"]] forKey:@"user_id"];
            NSLog(@"%@",[json objectForKey:@"user_id"]);
            [defaults synchronize];
            //then return to the previouse page, quit login page
            [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
        }
    }
    else {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        NSLog(@"all %@",[json allKeys]);
        //get the response and the autu_token
        if ([[json objectForKey:@"response"]isEqualToString:@"ok"]) {
            //if the register is finished, get the auth_token
            //save the login_auth_token for later use
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *login_auth_token=[json objectForKey:@"auth_token"];
            [defaults setValue:login_auth_token forKey:@"login_auth_token"];
            [defaults synchronize];
            //then return to the previouse page, quit login page
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Register Success" message:@"The register is finished." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
            success.delegate=self;
            [success show];
        }
        else {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Register Error" message:@"The register is not finished. Some error happened" delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
            error.delegate=self;
            [error show];
        }
    }
}

#pragma mark - uiAlertView delegate
////////////////////////////////////////////////
//implement the method for dealing with the return of the alertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%@",alertView.title);
    //deal with the Input Empty Error for the activity category choose
    if ([alertView.title isEqualToString:@"Register Success"]) {
        NSLog(@"register success called");
        [self.presentingViewController.presentingViewController dismissModalViewControllerAnimated:YES];
    }
    if ([alertView.title isEqualToString:@"Register Error"]) {
        NSLog(@"register error called");
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
    if ([textField isEqual:self.passwordTextField]) {
        [self animateTextField:textField up:YES];
    }
    if ([textField isEqual:self.rePasswordTextField]) {
        [self animateTextField:textField up:YES];
    }
    //if edit the add cost textfield, the whole view need to 
    //scroll up, get rid of the keyboard covering
    //if ([textField isEqual:self.textFieldSelfDefine]) {
    //   [self animateTextField: textField up: YES];
    //   self.uIViewUpFlag=YES;
    //}
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField isEqual:self.passwordTextField]) {
        [self animateTextField:textField up:NO];
    }
    if ([textField isEqual:self.rePasswordTextField]) {
        [self animateTextField:textField up:NO];
    }
    
    //if finished editign the add cost textfield, the whole view need to scroll down
    //if ([textField isEqual:self.textFieldSelfDefine]) {
    //    [self animateTextField: textField up: NO];
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
