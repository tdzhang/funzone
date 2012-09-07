//
//  AddCommentVC.m
//  Fun
//
//  Created by Tongda Zhang on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddCommentVC.h"

@interface AddCommentVC ()
@property (nonatomic,strong)addAndViewCommentTVC* myTVC;
@property (weak, nonatomic) IBOutlet UITextView *addCommentTextView;
@property (nonatomic,strong) NSMutableData *data;
@end

@implementation AddCommentVC
@synthesize myTVC=_myTVC;
@synthesize addCommentTextView = _addCommentTextView;
@synthesize myTableView;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize comments=_comments;
@synthesize data=_data;
//used for server log
@synthesize via=_via;


#pragma mark - self defined setter and getter
-(NSArray *)comments{
    if (!_comments) {
        _comments=[[NSArray alloc] init];
    }
    return _comments;
}

#pragma mark - View Life Cycle
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
    
   
    //send log to server
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/view_comments?event_id=%@&shared_event_id=%@&via=%d&auth_token=%@",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,self.via,[defaults objectForKey:@"login_auth_token"]]];
        
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        int code=[request responseStatusCode];
        NSLog(@"%d",code);
    });
    
    
    //judge whether the user is login? if not, do the login
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"login_auth_token"]) {
        //if not login, do it
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
        LoginPageViewController* loginVC=[storyboard instantiateViewControllerWithIdentifier:@"loginPage"];
        loginVC.parentVC=self;
        loginVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:loginVC animated:YES completion:^{}];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    
	//set up the table view controller
    self.myTVC=[[addAndViewCommentTVC alloc] init];
    self.myTVC.comments=self.comments;
    self.myTVC.event_id=self.event_id;
    self.myTVC.shared_event_id=self.shared_event_id;
    self.myTableView.delegate=self.myTVC;
    self.myTableView.dataSource=self.myTVC;
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setAddCommentTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button action part
- (IBAction)addCommentButtonClicked:(id)sender {
    [self.addCommentTextView resignFirstResponder];
    if (self.addCommentTextView.text.length>0) {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/comment",CONNECT_DOMIAN_NAME]];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            
            //add login auth_token //add content
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setPostValue:self.shared_event_id forKey:@"shared_event_id"];
            [request setPostValue:self.addCommentTextView.text forKey:@"comment"];
            [request setPostValue:[NSString stringWithFormat:@"%d",self.via] forKey:@"via"];
            [request setRequestMethod:@"POST"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:nil message:[NSString     stringWithFormat:@"We are sorry. Your comment was not received by the server. Please try again."] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        notsuccess.delegate=self;
                        [notsuccess show];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
            });
            
        });
    }
}



#pragma mark - implement UITextViewDelegate method
////////////////////////////////////////////////
//implement the Protocal UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {  
    
    UIBarButtonItem *done =    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];  
    
    self.navigationItem.rightBarButtonItem = done;      
    [self animateTextView:textView up:YES];
}  

- (void)textViewDidEndEditing:(UITextView *)textView {  
    self.navigationItem.rightBarButtonItem = nil; 
    [self animateTextView:textView up:NO];
}  

//deal with when user pressed the "done" button
- (void)leaveEditMode {  
    [self.addCommentTextView resignFirstResponder];  
}
//To compensate for the showing up keyboard
- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    const int movementDistance = 215; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
