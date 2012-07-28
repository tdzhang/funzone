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

@property (nonatomic,strong) NSDictionary *peopleGoOutWith; //the infomation of the firend that user choose to go with
@property (nonatomic,strong) NSDictionary *facebookFriendsGoOutWith; //the infomation of the facebook firends that user choose to go with
@property (nonatomic,strong) NSString *currentFacebookConnect;
@property (nonatomic,strong) NSString *facebookCurrentProcess;//use this to diff the facebook request intention

@end

@implementation ShareAfterNewEventViewController
@synthesize createEvent_image=_createEvent_image;
@synthesize createEvent_title=_createEvent_title;
@synthesize createEvent_latitude=_createEvent_latitude;
@synthesize createEvent_longitude=_createEvent_longitude;
@synthesize createEvent_locationName=_createEvent_locationName;
@synthesize createEvent_time=_createEvent_time;
@synthesize createEvent_address=_createEvent_address;
@synthesize createEvent_imageUrlName=_createEvent_imageUrlName;

@synthesize peopleGoOutWith=_peopleGoOutWith;
@synthesize facebookFriendsGoOutWith=_facebookFriendsGoOutWith;
@synthesize currentFacebookConnect=_currentFacebookConnect;
@synthesize facebookCurrentProcess=_facebookCurrentProcess;

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

-(void)setFacebookFriendsGoOutWith:(NSDictionary *)facebookFriendsGoOutWith{
    _facebookFriendsGoOutWith=facebookFriendsGoOutWith;
}

-(NSDictionary*)facebookFriendsGoOutWith{
    if (_facebookFriendsGoOutWith == nil){
        _facebookFriendsGoOutWith = [[NSDictionary alloc] init];
    }
    return _facebookFriendsGoOutWith;
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
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    if([segue.identifier isEqualToString:@"ChooseFacebookFriends"] && [segue.destinationViewController isKindOfClass:[ChooseFacebookFriendsToGoTableViewControllerViewController class]]){
        ChooseFacebookFriendsToGoTableViewControllerViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        peopleController.alreadySelectedContacts=[self.facebookFriendsGoOutWith copy];
    }
    else if([segue.identifier isEqualToString:@"ChooseFriends"] && [segue.destinationViewController isKindOfClass:[ChoosePeopleToGoTableViewController class]]){
        ChoosePeopleToGoTableViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        peopleController.alreadySelectedContacts=[self.peopleGoOutWith copy];
    }
}


#pragma mark - Button Action
- (IBAction)FinishedThisSharePage:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)PostOnFaceBookWall:(id)sender {
    FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    [params setObject:@"funnect event" forKey:@"name"];
    [params setObject:@"new funnect event" forKey:@"description"];
    [params setObject:[NSString stringWithFormat:@"Hey,\n\nfeel like %@ together? What about %@ at %@?\n\nCheers~",self.createEvent_title,self.createEvent_time,self.createEvent_locationName] forKey:@"message"];
    
    if ([delegate.facebook isSessionValid]) {
        self.currentFacebookConnect=@"create event";
        [delegate.facebook requestWithGraphPath:@"me/feed"
                                      andParams:params
                                  andHttpMethod:@"POST"
                                    andDelegate:self];
    }
    else {
        NSLog(@"Face book session invalid~~~");
    }
}

- (IBAction)CreateFacebookEvent:(id)sender {
    //invite friends first
    [self performSegueWithIdentifier:@"ChooseFacebookFriends" sender:self];
    
}

- (IBAction)Twitter:(id)sender {
}

- (IBAction)EmailShare:(id)sender {
    [self performSegueWithIdentifier:@"ChooseFriends" sender:self];
}

- (IBAction)WechatMoment:(id)sender {
}

- (IBAction)StartingAWechatDiscusion:(id)sender {
}

#pragma mark - facebook related protocal implement

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([self.currentFacebookConnect isEqualToString:@"create event"]) {
        //NSLog(@"%@",result);
        //get the event id
        NSString *event_id = [result objectForKey:@"id"];
        NSLog(@"start to invite people");
        //start to invite people
        if ([self.facebookFriendsGoOutWith count]>0) {
            FunAppDelegate *delegate=[[UIApplication sharedApplication] delegate];
            
            NSMutableDictionary* params = [NSMutableDictionary dictionary];
            NSString* user_ids=[NSString stringWithFormat:@""];
            BOOL temp_flag=NO;
            for (NSString *key in self.facebookFriendsGoOutWith) {
                FacebookContactObject *contact=[self.facebookFriendsGoOutWith objectForKey:key];
                if (temp_flag==NO) {
                    user_ids=[user_ids stringByAppendingString:[NSString stringWithFormat:@"%@",contact.facebook_id]];
                    temp_flag=YES;
                }
                else {
                    user_ids=[user_ids stringByAppendingString:[NSString stringWithFormat:@",%@",contact.facebook_id]];
                }
            }
            [params setObject:user_ids forKey:@"users"];
            
            if ([delegate.facebook isSessionValid]) {
                self.currentFacebookConnect=@"add invite";
                NSLog(@"%@",event_id);
                [delegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/invited",event_id] andParams:params andHttpMethod:@"POST" andDelegate:self];
            }
            else {
                NSLog(@"Face book session invalid~~~");
            }
        }
    }
    else if ([self.currentFacebookConnect isEqualToString:@"add invite"]) {
        NSLog(@"%@",result);
        self.currentFacebookConnect=nil;
    }
    else if([self.currentFacebookConnect isEqualToString:@"post on wall"]){
        self.currentFacebookConnect = nil;
        //NSLog(@"%@",result);
    }
    else {
        //NSLog(@"%@",result);
    }
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
//implement the method for the adding or delete Facebook contacts that will be go out with (FeedBackToFaceBookFriendToGoChange)
-(void)AddFacebookContactTogoInformtionToPeopleList:(FacebookContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSMutableDictionary *people=[self.facebookFriendsGoOutWith mutableCopy];
    NSString * key=person.facebook_name;
    [people setObject:(id)person forKey:key];
    self.facebookFriendsGoOutWith = [people copy];
}

-(void)DeleteFacebookContactTogoInformtionToPeopleList:(FacebookContactObject*)person{
    NSMutableDictionary *people=[self.facebookFriendsGoOutWith mutableCopy];
    NSString *key=person.facebook_name;
    [people removeObjectForKey:key];
    self.facebookFriendsGoOutWith = [people copy];
}

@end
