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

@end

@implementation registerViewController
@synthesize emailTextField;
@synthesize passwordTextField;
@synthesize rePasswordTextField;

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button action
//cancel register
- (IBAction)cancelRegister:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}



//start to register
- (IBAction)registerButtonClicked:(id)sender {
    //input too short
    if (self.emailTextField.text.length<5||self.passwordTextField.text.length<5||self.rePasswordTextField.text.length<5) {
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"Email/Password Too Short" message:@"The Email or the password you input is too short, please input a again." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        tooShort.delegate=self;
        [tooShort show];
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.rePasswordTextField resignFirstResponder];
        return;
    }
    //the password not match
    if(![self.passwordTextField.text isEqualToString:self.rePasswordTextField.text]){
        UIAlertView *tooShort = [[UIAlertView alloc] initWithTitle:@"Password Not Match" message:@"The password doesnot match, please input a again." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        tooShort.delegate=self;
        [tooShort show];
        [self.emailTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.rePasswordTextField resignFirstResponder];
        [self.passwordTextField setText:@""];
        [self.rePasswordTextField setText:@""];
        return;
    }
    //else, start too register
    
    
    /*
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Upload Complete!" message:@"The Event has been successfully uploaded to our server." delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
    success.delegate=self;
    [success show];
     */
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
