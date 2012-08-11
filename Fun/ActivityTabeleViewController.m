//
//  ActivityTabeleViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import "ActivityTabeleViewController.h"


@interface ActivityTabeleViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property(nonatomic,strong)NSMutableArray* activities;
@property(nonatomic,strong)NSArray* lastReceivedJson; //used to limite the refresh frequecy
@property(nonatomic,strong)activityElementObject* tapped_element;
@property(nonatomic)int send_via;
//start fetching activity data from the sever(and did the badge clean job)
-(void)startFetchingActivityData;
@end

@implementation ActivityTabeleViewController
@synthesize refreshButton = _refreshButton;
@synthesize activities=_activities;
@synthesize lastReceivedJson=_lastReceivedJson;
@synthesize tapped_element=_tapped_element;
@synthesize send_via=_send_via;

#pragma mark - self defined setter and getter
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
    
    //get the notification list from the server
    [self startFetchingActivityData];  
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //change the color style of the refresh button
    self.refreshButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setRefreshButton:nil];
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
    return cell;
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
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/activities?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];

        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        int code=[request responseStatusCode];
        NSLog(@"%d",code);
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
                self.activities=[activityElementObject getActivityElementsArrayByJson:json];
                NSLog(@"Have fetched %d Activities",[self.activities count]);
                [self.tableView reloadData];
            }
            //reset the tabbat notification number
            [PushNotificationHandler clearApplicationPushNotifNumber];
            [[self.tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
        }
        else{
            //connect error
            NSError *error = [request error];
            NSLog(@"%@",error.description);
            UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Connection Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Connect later" otherButtonTitles:nil];
            notsuccess.delegate=self;
            [notsuccess show];
        }
        
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
                    self.activities=[activityElementObject getActivityElementsArrayByJson:json];
                    NSLog(@"Have fetched %d Activities",[self.activities count]);
                    [self.tableView reloadData];
                }
                //reset the tabbat notification number
                [PushNotificationHandler clearApplicationPushNotifNumber];
                [[self.tabBarController.tabBar.items objectAtIndex:4] setBadgeValue:nil];
            }
            else{
                //connect error
                NSError *error = [request error];
                NSLog(@"%@",error.description);
                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Connection Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Connect later" otherButtonTitles:nil];
                notsuccess.delegate=self;
                [notsuccess show];
            }
            
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
