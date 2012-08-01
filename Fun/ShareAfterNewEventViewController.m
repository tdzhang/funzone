//
//  ShareAfterNewEventViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/28/12.
//
//

#import "ShareAfterNewEventViewController.h"

@interface ShareAfterNewEventViewController ()
@property (nonatomic,strong) UIImage *createEvent_image;
@property (nonatomic,strong) NSString *createEvent_title;
@property (nonatomic,strong) NSString *createEvent_latitude;
@property (nonatomic,strong) NSString *createEvent_longitude;
@property (nonatomic,strong) NSString *createEvent_locationName;
@property (nonatomic,strong) NSString *createEvent_time;
@property (nonatomic,strong) NSString *createEvent_address;
@property (nonatomic,strong) NSString *createEvent_imageUrlName;
@property (nonatomic,strong) NSString *preDefinedMode;
@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSDictionary *peopleGoOutWithMessage; //the infomation of the firend that user choose to go with
@property (weak, nonatomic) IBOutlet UIButton *WeixinButton;
@property (weak, nonatomic) IBOutlet UIButton *EmailButton;

@end

@implementation ShareAfterNewEventViewController
@synthesize WeixinButton = _WeixinButton;
@synthesize EmailButton = _EmailButton;
@synthesize delegate=_delegate;
@synthesize createEvent_image=_createEvent_image;
@synthesize createEvent_title=_createEvent_title;
@synthesize createEvent_latitude=_createEvent_latitude;
@synthesize createEvent_longitude=_createEvent_longitude;
@synthesize createEvent_locationName=_createEvent_locationName;
@synthesize createEvent_time=_createEvent_time;
@synthesize createEvent_address=_createEvent_address;
@synthesize createEvent_imageUrlName=_createEvent_imageUrlName;
@synthesize preDefinedMode=_preDefinedMode;

@synthesize peopleGoOutWith=_peopleGoOutWith;
@synthesize peopleGoOutWithMessage=_peopleGoOutWithMessage;


#pragma mark - self defined setter and getter
-(void)setPeopleGoOutWith:(NSDictionary *)peopleGoOutWith{
    _peopleGoOutWith=peopleGoOutWith;
}

-(NSDictionary*)peopleGoOutWith{
    if (_peopleGoOutWith == nil){
        _peopleGoOutWith = [[NSDictionary alloc	] init];
    }
    return _peopleGoOutWith;
}

-(void)peopleGoOutWithMessage:(NSDictionary *)peopleGoOutWithMessage{
    _peopleGoOutWithMessage=peopleGoOutWithMessage;
}

-(NSDictionary*)peopleGoOutWithMessage{
    if (_peopleGoOutWithMessage == nil){
        _peopleGoOutWithMessage = [[NSDictionary alloc] init];
    }
    return _peopleGoOutWithMessage;
}

#pragma mark - View Life Cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    //set up the weixin delegate
    FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    self.delegate=(id)appDelegate;
    
    //set the button to be a circle
    self.WeixinButton.layer.cornerRadius = 20;
    self.WeixinButton.clipsToBounds=YES;
    self.EmailButton.layer.cornerRadius = 20;
    self.EmailButton.clipsToBounds=YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined method
-(void)presetEventImage:(UIImage*)createEvent_image WithTiTle:(NSString*)createEvent_title WithLatitude:(NSString*)createEvent_latitude WithLongitude:(NSString*)createEvent_longitude WithLocationName:(NSString*)createEvent_locationName WithTime:(NSString*)createEvent_time WithAddress:(NSString*)createEvent_address WithImageUrlName:(NSString*)createEvent_imageUrlName{
    self.createEvent_image=createEvent_image;
    self.createEvent_title=createEvent_title;
    self.createEvent_latitude=createEvent_latitude;
    self.createEvent_longitude=createEvent_longitude;
    self.createEvent_locationName=createEvent_locationName;
    self.createEvent_time=createEvent_time;
    self.createEvent_address=createEvent_address;
    self.createEvent_imageUrlName=createEvent_imageUrlName;
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"ChooseFriends"] && [segue.destinationViewController isKindOfClass:[ChoosePeopleToGoTableViewController class]]){
        ChoosePeopleToGoTableViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        if ([self.preDefinedMode isEqualToString:@"email"]) {
            peopleController.alreadySelectedContacts=[self.peopleGoOutWith copy];
        } else {
            peopleController.alreadySelectedContacts=[self.peopleGoOutWithMessage copy];
        }
        peopleController.preDefinedMode=self.preDefinedMode;
    }
}


#pragma mark - Button Action
- (IBAction)FinishedThisSharePage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    [funAppdelegate.thisTabBarController setSelectedIndex:4];
}

- (IBAction)EmailShare:(id)sender {
    self.preDefinedMode=@"email";
    [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
}

- (IBAction)MesssgeShare:(id)sender {
    self.preDefinedMode=@"message";
    [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
}

- (IBAction)WechatShare:(id)sender {
    UIActionSheet *pop=[[UIActionSheet alloc] initWithTitle:@"Choose A WeChat Way" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share On Moment",@"Send Friend Message", nil];
    pop.actionSheetStyle=UIActionSheetStyleBlackTranslucent;
    [pop showFromTabBar:self.tabBarController.tabBar];
}

//start to compose email(the FeedBackToCreateActivityChange)
-(void)StartComposeEmail{
    //compose the email
    if (self.peopleGoOutWith) {
        if ([self.peopleGoOutWith count] > 0) {
            //Now we have friends to be invided using email
            //get the email list
            NSMutableArray *emailList=[NSMutableArray array];
            for (NSString* key in [self.peopleGoOutWith allKeys] ){
                UserContactObject *user=[self.peopleGoOutWith objectForKey:key];
                if (user.email) {
                    if ([user.email count]>0) {
                        [emailList addObject:[user.email objectAtIndex:0]];
                    }
                }
            }
            //we have the email list, now try to send email invitation
            if([MFMailComposeViewController canSendMail]) {
                //if the device allowed sending email
                MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
                mailCont.mailComposeDelegate = self;
        
                //email subject
                [mailCont setSubject:[NSString stringWithFormat:@"Event Invitation! Yeah, Let's %@",self.createEvent_title]];
                //email list
                [mailCont setToRecipients:emailList];
                //email body
                [mailCont setMessageBody:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.createEvent_title,self.createEvent_time,self.createEvent_locationName] isHTML:NO];
                //go!
                [self presentModalViewController:mailCont animated:YES];
            }
        }
    }
}
//start to compose message(the FeedBackToCreateActivityChange)
-(void)StartComposeMessage{
    //compose the message
    if (self.peopleGoOutWithMessage) {
        if ([self.peopleGoOutWithMessage count] > 0) {
            //Now we have friends to be invided using email
            //get the email list
            NSMutableArray *phoneList=[NSMutableArray array];
            for (NSString* key in [self.peopleGoOutWithMessage allKeys] ){
                UserContactObject *user=[self.peopleGoOutWithMessage objectForKey:key];
                if (user.phone) {
                    if ([user.phone count]>0) {
                        [phoneList addObject:[user.phone objectAtIndex:0]];
                    }
                }
            }
            //we have the phone list, now try to send email invitation
            if([MFMessageComposeViewController canSendText]) {
                //if the device allowed sending email
                MFMessageComposeViewController *messageSender = [MFMessageComposeViewController new];
                messageSender.messageComposeDelegate = self;
                //phone list
                [messageSender setRecipients:phoneList];
                //phone body
                [messageSender setBody:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.createEvent_title,self.createEvent_time,self.createEvent_locationName]];
                //go!
                [self presentModalViewController:messageSender animated:YES];
            }
        }
    }

    
    /*
     if ([MFMessageComposeViewController canSendText]) {
     MFMessageComposeViewController *messageSender = [MFMessageComposeViewController new];
     
     NSString *messageText = [[NSString stringWithFormat:@"Hi, your friend just shared recipe of %@ with you. Check it out here: ",_dish.name] stringByAppendingFormat:_dish.dishURL];
     
     [messageSender setBody:messageText];
     [self presentModalViewController:messageSender animated:YES];
     } else {
     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed to sent SMS"
     message:@"Your device cannot send SMS for now. Please check."
     delegate:nil
     cancelButtonTitle:@"Cancel"
     otherButtonTitles: nil];
     [alert show];
     }
     */
    
}

#pragma mark - self defined protocal method implementation
////////////////////////////////////////////////
//implement the method for the adding or delete contacts that will be go out with
-(void)AddContactInformtionToPeopleList:(UserContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSMutableDictionary *people=[self.peopleGoOutWith mutableCopy];
    NSString * key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people setObject:(id)person forKey:key];
    self.peopleGoOutWith = [people copy];
}

-(void)DeleteContactInformtionToPeopleList:(UserContactObject*)person{
    NSMutableDictionary *people=[self.peopleGoOutWith mutableCopy];
    NSString *key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people removeObjectForKey:key];
    self.peopleGoOutWith = [people copy];
}

////////////////////////////////////////////////
//implement the method for the adding or delete Message contacts that will be go out with
-(void)AddMessageContactInformtionToPeopleList:(UserContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSMutableDictionary *people=[self.peopleGoOutWithMessage mutableCopy];
    NSString * key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people setObject:(id)person forKey:key];
    self.peopleGoOutWithMessage = [people copy];
}

-(void)DeleteMessageContactInformtionToPeopleList:(UserContactObject*)person{
    NSMutableDictionary *people=[self.peopleGoOutWithMessage mutableCopy];
    NSString *key=[NSString stringWithFormat:@"%@, %@",person.firstName,person.lastName];
    [people removeObjectForKey:key];
    self.peopleGoOutWithMessage = [people copy];
}

#pragma mark - implement protocals
////////////////////////////////////////////////
//implement the MFMailComposeViewControllerDelegate Method
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        NSLog(@"Sending Email Error Happended!");
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    [self dismissModalViewControllerAnimated:YES];
}

////////////////////////////////////////////////
//implement the UIActionSheetDelegate Method
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    //for the when to go action sheet
    NSLog(@"%@",actionSheet.title);
    if([actionSheet.title isEqualToString:@"Choose A WeChat Way"]){
        if(buttonIndex == 0){
            //shared on moment
            [self.delegate SendMoment:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.createEvent_title,self.createEvent_time,self.createEvent_locationName]];
        }
        else if(buttonIndex == 1){
            //send message to friend
            [self.delegate sendText:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~~",self.createEvent_title,self.createEvent_time,self.createEvent_locationName]];
            
        }
    }
}

- (void)viewDidUnload {
    [self setWeixinButton:nil];
    [self setEmailButton:nil];
    [super viewDidUnload];
}
@end
