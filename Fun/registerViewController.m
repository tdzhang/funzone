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
@end

@implementation registerViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize rePasswordTextField;
@synthesize firstNameTextField;
@synthesize lastNameTextField;
@synthesize data=_data;

#pragma mark - View life cycle
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
- (IBAction)cancelRegister:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}



//start to register
- (IBAction)registerButtonClicked:(id)sender {
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
    
    NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/users.json?user[first_name]=%@&user[last_name]=%@&user[email]=%@&user[password]=%@&user[password_confirmation]=%@",self.firstNameTextField.text,self.lastNameTextField.text,self.emailTextField.text,self.passwordTextField.text,self.rePasswordTextField.text];
    NSLog(@"%@",request_string);
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
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    NSLog(@"all %@",[json allKeys]);
    [self dismissModalViewControllerAnimated:YES];
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
