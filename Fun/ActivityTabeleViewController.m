//
//  ActivityTabeleViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import "ActivityTabeleViewController.h"
#import "Flurry.h"


@interface ActivityTabeleViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentControl;
@property (weak, nonatomic) IBOutlet UIView *segmentationView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moreButton;

@property(strong,nonatomic) NSMutableDictionary *cellsForSeg1;
@property(strong,nonatomic) NSMutableDictionary *cellsForSeg2;

@property(nonatomic,strong)NSMutableArray* activities; //which is used to hold the array that hold the results to show
@property(nonatomic,strong)NSMutableArray* activities_conversation; //used to hold conversation activities
@property(nonatomic,strong)NSMutableArray* activities_normal; // used to hold other normal activitise
@property(nonatomic,strong)NSArray* lastReceivedJson; //used to limite the refresh frequecy
@property(nonatomic,strong)NSArray* lastReceivedJson_conversation; //used to limite the refresh frequecy
@property(nonatomic,strong)activityElementObject* tapped_element;
@property(nonatomic)int send_via;
//start fetching activity data from the sever(and did the badge clean job)
@property (weak, nonatomic) IBOutlet UIImageView *badgeView1;
@property (weak, nonatomic) IBOutlet UIImageView *badgeView2;


-(void)startFetchingActivityData;
@end

@implementation ActivityTabeleViewController
@synthesize refreshButton = _refreshButton;
@synthesize mySegmentControl = _mySegmentControl;
@synthesize segmentationView = _segmentationView;
@synthesize moreButton = _moreButton;
@synthesize activities=_activities;
@synthesize activities_conversation=_activities_conversation;
@synthesize activities_normal=_activities_normal;
@synthesize lastReceivedJson=_lastReceivedJson;
@synthesize lastReceivedJson_conversation=_lastReceivedJson_conversation;
@synthesize tapped_element=_tapped_element;
@synthesize send_via=_send_via;

@synthesize cellsForSeg1=_cellsForSeg1;
@synthesize cellsForSeg2=_cellsForSeg2;

#pragma mark - self defined setter and getter
-(NSMutableDictionary *)cellsForSeg1{
    if (!_cellsForSeg1) {
        _cellsForSeg1=[NSMutableDictionary dictionary];
    }
    return _cellsForSeg1;
}

-(NSMutableDictionary *)cellsForSeg2{
    if (!_cellsForSeg2) {
        _cellsForSeg2=[NSMutableDictionary dictionary];
    }
    return _cellsForSeg2;
}

-(NSMutableArray *)activities{
    if (!_activities) {
        _activities=[NSMutableArray array];
    }
    return _activities;
}
-(NSArray*)lastReceivedJson{
    if (!_lastReceivedJson) {
        _lastReceivedJson=[NSArray array];
    }
    return _lastReceivedJson;
}
-(NSMutableArray *)activities_conversation{
    if (!_activities_conversation) {
        _activities_conversation=[NSMutableArray array];
    }
    return _activities_conversation;
}

-(NSMutableArray *)activities_normal{
    if (!_activities_normal) {
        _activities_normal=[NSMutableArray array];
    }
    return _activities_normal;
}

-(NSArray *)lastReceivedJson_conversation{
    if (!_lastReceivedJson_conversation) {
        _lastReceivedJson_conversation=[NSArray array];
    }
    return _lastReceivedJson_conversation;
}

#pragma mark - segment control action
- (IBAction)segmentControlValuechanged:(id)sender {
    NSLog(@"%d",[self.mySegmentControl selectedSegmentIndex]);
    if ([self.mySegmentControl selectedSegmentIndex]==0) {
        self.activities=self.activities_normal;
        [self.tableView reloadData];
    }
    else if ([self.mySegmentControl selectedSegmentIndex]==1){
        self.activities=self.activities_conversation;
        [self.tableView reloadData];
    }
}

-(void)reloadDataConsiderSegmentControl{
    if ([self.mySegmentControl selectedSegmentIndex]==0) {
        self.activities=self.activities_normal;
        [self.tableView reloadData];
    }
    else if ([self.mySegmentControl selectedSegmentIndex]==1){
        self.activities=self.activities_conversation;
        [self.tableView reloadData];
    }
}


#pragma mark - View Life Cycle
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [Flurry logEvent:FLURRY_ENTER_ACTIVITY];
    
    //get the notification list from the server
    [self startFetchingActivityData];  
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor =  [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //check for internet connection, if no connection, showing alert
    //[CheckForInternetConnection CheckForConnectionToBackEndServer];
    
    //change the color style of the refresh button
    self.refreshButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];

    self.moreButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //-----------------------> segment control part<<---------------------------------------\\
    self.mySegmentControl.frame = CGRectMake(0, 0, 310, 40);
    UIImage *segmentSelected = [[UIImage imageNamed:@"tab_unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *segmentUnselected = [[UIImage imageNamed:@"tab_selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.mySegmentControl.frame = CGRectMake(0, 0, 320, 40);
    [self.mySegmentControl setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.mySegmentControl setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // — Dividers
    UIImage *imgSelectedUnSelected = [[UIImage imageNamed:@"button_seperator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedUnSelected = [[UIImage imageNamed:@"button_seperator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedSelected = [[UIImage imageNamed:@"button_seperator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.mySegmentControl setDividerImage:imgSelectedUnSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mySegmentControl setDividerImage:imgUnSelectedUnSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mySegmentControl setDividerImage:imgUnSelectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.mySegmentControl setTitle:@"NOTIFICATIONS" forSegmentAtIndex:0];
    [self.mySegmentControl setTitle:@"MESSAGES" forSegmentAtIndex:1];
    [self.mySegmentControl setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor colorWithRed:255.0/255.0 green:139/255.0 blue:41/255.0 alpha:1.0], UITextAttributeTextColor,
                                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                                    [UIFont boldSystemFontOfSize:12], UITextAttributeFont, nil] forState:UIControlStateSelected];
    [self.mySegmentControl setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                    [UIColor grayColor], UITextAttributeTextColor,
                                                    [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                    [UIFont boldSystemFontOfSize:12], UITextAttributeFont, nil] forState:UIControlStateNormal];
    [self.mySegmentControl setContentOffset:CGSizeMake(0, 5) forSegmentAtIndex:0];
    [self.mySegmentControl setContentOffset:CGSizeMake(0, 5) forSegmentAtIndex:1];

    //set view background
    [self.view setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
    
    self.segmentationView.layer.cornerRadius = 2;
    self.segmentationView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.segmentationView.layer.shadowOffset = CGSizeMake(0, 1);
    self.segmentationView.layer.shadowRadius = 1.5f;
    self.segmentationView.layer.shadowOpacity = 0.6f;
}

- (void)viewDidUnload
{
    [self setRefreshButton:nil];
    [self setMySegmentControl:nil];
    [self setSegmentationView:nil];
    [self setMoreButton:nil];
    [self setBadgeView2:nil];
    [self setBadgeView1:nil];
    [self setBadgeView2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mySegmentControl selectedSegmentIndex]==0) {
        if ([self.cellsForSeg1 objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]) {
            return [self.cellsForSeg1 objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        }
        else{
            //for the normal activities
            static NSString *CellIdentifier = @"ActivityTableViewCell";
            
            ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:nil options:nil];
                
                for (UIView *view in views) {
                    if([view isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (ActivityTableViewCell*)view;
                    }
                }
            }
            [cell resetWithActivityObject:[self.activities objectAtIndex:indexPath.row]];
            
            [self.cellsForSeg1 setObject:cell forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
             return cell;
        }
        
       
    }
    else{
        if ([self.cellsForSeg2 objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]) {
            return [self.cellsForSeg2 objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]];
        }
        else{
            //for the conversation activities
            static NSString *CellIdentifier = @"ActivityTableViewCell";
            
            ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                NSArray* views = [[NSBundle mainBundle] loadNibNamed:@"ActivityTableViewCell" owner:nil options:nil];
                
                for (UIView *view in views) {
                    if([view isKindOfClass:[UITableViewCell class]])
                    {
                        cell = (ActivityTableViewCell*)view;
                    }
                }
            }
            [cell resetWithConversationActivityObject:[self.activities objectAtIndex:indexPath.row]];
            
            [self.cellsForSeg2 setObject:cell forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
#pragma mark - Start Fetching Data
-(void)startFetchingActivityData{
    [self.cellsForSeg1 removeAllObjects];
    [self.cellsForSeg2 removeAllObjects];
    //fetching the normal activity data
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/activities?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];

        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        int code=[request responseStatusCode];
        dispatch_async( dispatch_get_main_queue(),^{
        if (code==200) {
            //success
            NSString *responseString = [request responseString];
            NSLog(@"%@",responseString);
            NSError *error;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
            if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson]]) {
                //not equal, update the last reveived json
                self.lastReceivedJson=json;
                //deal with json
                self.activities_normal=[activityElementObject getActivityElementsArrayByJson:json];
                NSLog(@"Have fetched %d Activities",[self.activities_normal count]);
                [self reloadDataConsiderSegmentControl];
            }
            //reset the tabbat notification number
            [PushNotificationHandler clearApplicationPushNotifNumber];
            [[self.tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
        }
        else{}
        });
    });
    
    //fetching the conversation activity data
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/conversations?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        int code=[request responseStatusCode];
        //NSLog(@"%d",code);
        //NSLog(@"%@",request.responseString);
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                //if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_conversation]]) {
                    //not equal, update the last reveived json
                    self.lastReceivedJson_conversation=json;
                    //deal with json
                    self.activities_conversation=[activityElementObject getConversationActivityElementsArrayByJson:json];
                    NSLog(@"Have fetched %d Activities",[self.activities_conversation count]);
                    [self reloadDataConsiderSegmentControl];
                
                int sum=0;
                for (activityElementObject* ele in self.activities_conversation) {
                    sum=sum+[ele.unread_msg_num intValue];
                }
                
                if (sum>0) {
                    [self.badgeView2 setHidden:NO];
                }
                //}
                //reset the tabbat notification number
                [PushNotificationHandler clearApplicationPushNotifNumber];
                [[self.tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
            }
            else{}
        });
    });
    
}


#pragma mark - refresh button action part
- (IBAction)refreshButtonClicked:(id)sender {
    //disable the button before the request is finshed
    [self.refreshButton setEnabled:NO];
    
    [self RefreshAction];
}

-(void)RefreshAction{
    [self.cellsForSeg1 removeAllObjects];
    [self.cellsForSeg2 removeAllObjects];
    
    //fetching the normal activity data
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/activities?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        int code=[request responseStatusCode];
        NSLog(@"%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            //disable the button before the request is finshed
            [self.refreshButton setEnabled:YES];
            
            if (code==200) {
                //success
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson]]) {
                    //not equal, update the last reveived json
                    self.lastReceivedJson=json;
                    //deal with json
                    self.activities_normal=[activityElementObject getActivityElementsArrayByJson:json];
                    NSLog(@"Have fetched %d Activities",[self.activities_normal count]);
                    [self reloadDataConsiderSegmentControl];
                }
                //reset the tabbat notification number
                [PushNotificationHandler clearApplicationPushNotifNumber];
                [[self.tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
            }
            else{}
        });
        
    });
    
    //fetching the conversation activity data
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/conversations?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        int code=[request responseStatusCode];
        NSLog(@"%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            //disable the button before the request is finshed
            [self.refreshButton setEnabled:YES];
            
            if (code==200) {
                //success
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_conversation]]) {
                    //not equal, update the last reveived json
                    self.lastReceivedJson_conversation=json;
                    //deal with json
                    self.activities_conversation=[activityElementObject getConversationActivityElementsArrayByJson:json];
                    NSLog(@"Have fetched %d Activities",[self.activities_conversation count]);
                    [self reloadDataConsiderSegmentControl];
                }
                //reset the tabbat notification number
                [PushNotificationHandler clearApplicationPushNotifNumber];
                [[self.tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
            }
            else{}
        });
        
    });
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    activityElementObject* element=[self.activities objectAtIndex:indexPath.row];
    self.tapped_element=element;
    if ([[NSString stringWithFormat:@"%@",element.type] isEqualToString:[NSString stringWithFormat:@"%d",INTEREST_EVENT]]) {
        // some one show interest on your event// go to that event
        self.send_via=VIA_ACTIVITY_INTEREST;
        [self performSegueWithIdentifier:@"seeMyEvent" sender:self];
    }
    else if([[NSString stringWithFormat:@"%@",element.type] isEqualToString:[NSString stringWithFormat:@"%d",FOLLOW_SOMEONE]]){
        //some one followed you
        self.send_via=VIA_ACTIVITY_FOLLOW;
        [self performSegueWithIdentifier:@"seeOtherProfile" sender:self];
    }
    else if([[NSString stringWithFormat:@"%@",element.type] isEqualToString:[NSString stringWithFormat:@"%d",COMMENT_EVENT]]){
        //some one comment on you event
        self.send_via=VIA_ACTIVITY_COMMENT;
        [self performSegueWithIdentifier:@"seeMyEvent" sender:self];
    }
    else if([[NSString stringWithFormat:@"%@",element.type] isEqualToString:[NSString stringWithFormat:@"%d",INVITED_TO_EVENT]]){
        //show the event
        self.send_via=VIA_ACTIVITY_INVITE;
        [self performSegueWithIdentifier:@"seeOtherEvent" sender:self];
    }else if ([[NSString stringWithFormat:@"%@",element.type] isEqualToString:[NSString stringWithFormat:@"%d",NEW_FRIEND_JOIN]]){
        // your friend has just joined orange parc, go to that page to follow
        self.send_via=VIA_ACTIVITY_FRIEND_JOIN;
        [self performSegueWithIdentifier:@"seeOtherProfile" sender:self];
    }
    else if ([[NSString stringWithFormat:@"%@",element.type] isEqualToString:@"conversation"]){
        // your friend has just joined orange parc, go to that page to follow
        self.send_via=VIA_ACTIVITY_CONVERSATION;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([element.user_id isEqualToString:[defaults objectForKey:@"user_id"]]) {
            [self performSegueWithIdentifier:@"seeMyEvent" sender:self];
        }
        else{
            [self performSegueWithIdentifier:@"seeOtherEvent" sender:self];
        }
    }
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"%d",self.send_via);
    if ([segue.identifier isEqualToString:@"seeMyEvent"]) {
        //if it's the segue to the view detail part, do this:
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        [detailVC preSetTheEventID:self.tapped_element.event_id andSetTheSharedEventID:self.tapped_element.shared_event_id andSetIsOwner:YES];
        [detailVC preSetServerLogViaParameter:self.send_via];
    }
    else if([segue.identifier isEqualToString:@"seeOtherProfile"]) {
        OtherProfilePageViewController* OPPVC=segue.destinationViewController;
        OPPVC.creator_id=self.tapped_element.user_id;
        OPPVC.via=self.send_via;
    }
    
    else if ([segue.identifier isEqualToString:@"seeOtherEvent"]) {
        //if it's the segue to the view detail part, do this:
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        [detailVC preSetTheEventID:self.tapped_element.event_id andSetTheSharedEventID:self.tapped_element.shared_event_id andSetIsOwner:NO];
        [detailVC preSetServerLogViaParameter:self.send_via];
    }
}



@end
