//
//  OtherProfilePageViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OtherProfilePageViewController.h"
#define VIEW_WIDTH 320
#define VIEW_HEIGHT 55 
#define PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT 165

@interface OtherProfilePageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *creatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookmarkNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumLabel;
@property (nonatomic,retain) NSMutableArray *blockViews;
@property (nonatomic,retain) UIView *refreshViewdown;
@property (nonatomic,retain) UIImageView *refreshView;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *freshConnectionType;
@property (nonatomic) BOOL isViewAppearConnection;
@property (nonatomic) int refresh_page_num;
@property (nonatomic,strong) NSString *tapped_event_id;
@property (nonatomic,strong) NSString *tapped_shared_event_id;
@property (nonatomic,strong) NSMutableArray *garbageCollection;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic) BOOL followed;
@property (nonatomic,weak)CLLocationManager *current_location_manager;

@property(nonatomic,strong)NSDictionary* lastReceivedJson_profile; //used to limite the refresh frequecy
@property(nonatomic,strong)NSArray* lastReceivedJson_bookmark; //used to limite the refresh frequecy

@end

@implementation OtherProfilePageViewController
@synthesize mainScrollView;
@synthesize refreshView=_refreshView;
@synthesize refreshViewdown=_refreshViewdown;
@synthesize creatorImageView = _creatorImageView;
@synthesize creatorNameLabel = _creatorNameLabel;
@synthesize bookmarkNumLabel = _bookmarkNumLabel;
@synthesize followingNumLabel = _followingNumLabel;
@synthesize followerNumLabel = _followerNumLabel;
@synthesize blockViews = _blockViews;
@synthesize data=_data;
@synthesize freshConnectionType=_freshConnectionType;
@synthesize isViewAppearConnection=_isViewAppearConnection;
@synthesize refresh_page_num=_refresh_page_num;
@synthesize tapped_event_id=_tapped_event_id;
@synthesize tapped_shared_event_id=_tapped_shared_event_id;
@synthesize garbageCollection=_garbageCollection;
@synthesize followButton = _followButton;
@synthesize creator_id=_creator_id;
@synthesize followed=_followed;
@synthesize current_location_manager=_current_location_manager;

@synthesize lastReceivedJson_bookmark=_lastReceivedJson_bookmark;
@synthesize lastReceivedJson_profile=_lastReceivedJson_profile;

//used to keep server log
@synthesize via=_via;


-(CLLocationManager *)current_location_manager{
    if (!_current_location_manager) {
         FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
        _current_location_manager=funAppdelegate.myLocationManager;
    }
    return _current_location_manager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableArray *)blockViews {
    if (_blockViews == nil) {
        _blockViews = [[NSMutableArray alloc] init];
    }
    return _blockViews;
}

-(NSDictionary *)lastReceivedJson_profile{
    if (!_lastReceivedJson_profile) {
        _lastReceivedJson_profile=[NSDictionary dictionary];
    }
    return _lastReceivedJson_profile;
}

-(NSArray *)lastReceivedJson_bookmark{
    if (!_lastReceivedJson_bookmark) {
        _lastReceivedJson_bookmark=[NSArray array];
    }
    return _lastReceivedJson_bookmark;
}

-(NSMutableArray *)garbageCollection{
    if(!_garbageCollection){
        _garbageCollection=[NSMutableArray array];
    }
    return _garbageCollection;
}

#pragma mark - View Life Circle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    
    //query the user profile information
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/profile?auth_token=%@&user_id=%@&&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id,self.via]];
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                // Use when fetching text data
                //NSString *responseString = [block_request responseString];
                //NSLog(@"%@",responseString);
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_profile]]) {
                    self.lastReceivedJson_profile=json;
                    //only update the content when there is a content different
                    [self.creatorNameLabel setText:[json objectForKey:@"name"]];
                    self.navigationController.navigationBar.topItem.title = [json objectForKey:@"name"];
                    [self.bookmarkNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_bookmarks"]]];
                    [self.followerNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followers"]]];
                    [self.followingNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followings"]]];
                    //if already followed, changed the button name to "unfollow"
                    NSLog(@"%@",json);
                    self.followed=NO;
                    if ([[NSString stringWithFormat:@"%@",[json objectForKey:@"followed"]]isEqualToString:@"1"]) {
                        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                        self.followed=YES;
                    }
                    
                    NSURL *url=[NSURL URLWithString:[json objectForKey:@"profile_url"]];
                    if (![Cache isURLCached:url]) {
                        //using high priority queue to fetch the image
                        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                            //get the image data
                            NSData * imageData = nil;
                            imageData = [[NSData alloc] initWithContentsOfURL: url];
                            
                            if ( imageData == nil ){
                                //if the image data is nil, the image url is not reachable. using a default image to replace that
                                //NSLog(@"downloaded %@ error, using a default image",url);
                                UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                                imageData=UIImagePNGRepresentation(image);
                                
                                if(imageData){
                                    dispatch_async( dispatch_get_main_queue(),^{
                                        [Cache addDataToCache:url withData:imageData];
                                        [self.creatorImageView setImage:[UIImage imageWithData:imageData]];
                                    });
                                }
                            }
                            else {
                                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                                //NSLog(@"downloaded %@",url);
                                if(imageData){
                                    dispatch_async( dispatch_get_main_queue(),^{
                                        [Cache addDataToCache:url withData:imageData];
                                        [self.creatorImageView setImage:[UIImage imageWithData:imageData]];
                                    });
                                }
                            }
                        });
                    }
                    else {
                        dispatch_async( dispatch_get_main_queue(),^{
                            [self.creatorImageView setImage:[UIImage imageWithData:[Cache getCachedData:url]]];
                        });
                    }
                }
            }
            else{
                //connect error
                NSError *error = [request error];
                NSLog(@"%@",error.description);
                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Errow getting user profile!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                notsuccess.delegate=self;
                //[notsuccess show];
            }
            
        });
        
    });
        

    //quest the most recent 10 events
    self.refresh_page_num=2; //the next page that need to refresh is 2
    self.freshConnectionType=@"New";
    self.isViewAppearConnection=YES;
    NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@&user_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id];
    NSLog(@"%@",request_string);
    NSURLRequest* URLrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:URLrequest delegate:self];
    [connection start];
    if ([self.lastReceivedJson_bookmark count]<5) {
        self.mainScrollView.contentSize =CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, 5*PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT);
        self.mainScrollView.contentOffset = CGPointMake(0, 10);
    }
    
    //refresh part
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //set the Navigation Bar Style
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    //add the navigation back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.94111 green:0.6373 blue:0.3 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    _creatorImageView.layer.cornerRadius = 7;
    _creatorImageView.layer.masksToBounds = YES;
    

}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [self setCreatorImageView:nil];
    [self setCreatorNameLabel:nil];
    [self setBookmarkNumLabel:nil];
    [self setFollowingNumLabel:nil];
    [self setFollowerNumLabel:nil];
    [self setFollowButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - button action
- (IBAction)startFollowAction:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/follow?auth_token=%@&followee_id=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id,self.via]];
    if (self.followed) {
        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/unfollow?auth_token=%@&followee_id=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id,self.via]];
    }

    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                // Use when fetching text data
                NSString *responseString = [request responseString];
                NSLog(@"%@",responseString);
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                if (self.followed) {
                    if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Unfollow succeeded." message: [NSString stringWithFormat:@"You have successfully unfollowed the user you chose."] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        success.delegate=self;
                        //[success show];
                        [self.followButton setTitle:@"Follow" forState:UIControlStateNormal];
                        self.followed=NO;
                    }
                    else {
                        UIAlertView *unsuccess = [[UIAlertView alloc] initWithTitle:@"Unfollow not successful." message: [NSString stringWithFormat:@"Oops, something went wrong. Please try again."] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        unsuccess.delegate=self;
                        //[unsuccess show];
                    }
                }
                else if (!self.followed){
                    if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Follow succeeded." message: [NSString stringWithFormat:@"You have successfully followed the user you chose."] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        success.delegate=self;
                        //[success show];
                        [self.followButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                        self.followed=YES;
                    }
                    else {
                        UIAlertView *unsuccess = [[UIAlertView alloc] initWithTitle:@"Follow not successful." message: [NSString stringWithFormat:@"Oops, something went wrong. Please try again."] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                        unsuccess.delegate=self;
                        //[unsuccess show];
                    }
                }
            }
            else{
                //connect error
                NSError *error = [request error];
                NSLog(@"%@",error.description);
                UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                notsuccess.delegate=self;
                //[notsuccess show];
            }
            
        });
        
    });
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ViewEventDetail"]) {
        //if it's the segue to the view detail part, do this:
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        [detailVC preSetTheEventID:self.tapped_event_id andSetTheSharedEventID:self.tapped_shared_event_id andSetIsOwner:NO];
        [detailVC preSetServerLogViaParameter:VIA_OTHERS_PROFILE];
    }
    else if([segue.identifier isEqualToString:@"viewFollowingUser"]){
        MyFollowingTableViewController* VC=(MyFollowingTableViewController *)segue.destinationViewController;
        [VC setOther_user_id:self.creator_id];
    }
    else if([segue.identifier isEqualToString:@"viewFollowerUser"]){
        MyFollowerTableViewController* VC=(MyFollowerTableViewController *)segue.destinationViewController;
        [VC setOther_user_id:self.creator_id];
    }
}

#pragma mark - implement the UIScrollViewDelegate
//when the scrolling over 最上方，need refresh process
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //if already in a feching process, return
    if (![self.freshConnectionType isEqualToString:@"not"]) {
        return;
    }
    
    if (scrollView.contentOffset.y<-EVENT_ELEMENT_CONTENT_HEIGHT/3) {
        
        //put all the view down to show the refresh view
        for (UIView *view in [self.mainScrollView subviews]) {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
            //NSLog(@"put %f",view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2);
        }
        
        //set the refresh view ahead & and also the anti touch mask
        //NSLog(@"get most 10 popular pages called");
        [self.refreshView setFrame:CGRectMake(0, 0, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT/2)];
        
        for(UIView *subview in [self.refreshView subviews]) {
            [subview removeFromSuperview];
        }
        
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT/2)];
        loading.layer.cornerRadius =15;
        loading.opaque = NO;
        loading.backgroundColor =[UIColor clearColor];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(90,10,140,40)];
        [loadLabel setBackgroundColor:[UIColor clearColor]];
        loadLabel.text =@"Loading";loadLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment =UITextAlignmentCenter;
        loadLabel.textColor =[UIColor colorWithWhite:0.2f alpha:0.5f];
        loadLabel.backgroundColor =[UIColor clearColor];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinning.frame =CGRectMake(120,20,80,80);
        [spinning startAnimating];[loading addSubview:spinning];
        [self.refreshView addSubview:loading];
        
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
        
        //and then do the refresh process
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@&user_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.freshConnectionType=@"New";
        self.isViewAppearConnection=NO;
        [connection start];
    }
    //add more of the featured event
    else if(scrollView.contentOffset.y>PROFILE_ELEMENT_VIEW_HEIGHT*(([self.blockViews count]/2+[self.blockViews count]%2-1.5))){
        //add the content add refresh indicator
        for(UIView *subview in [self.refreshViewdown subviews]) {
            [subview removeFromSuperview];
        }
        UIView* underloading=[[UIView alloc] initWithFrame:CGRectMake(0,0,EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT/2)];
        [underloading setBackgroundColor:[UIColor clearColor]];
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT/2)];
        loading.layer.cornerRadius =15;
        loading.opaque = NO;
        loading.backgroundColor =[UIColor clearColor];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(90,10,140,40)];
        [loadLabel setBackgroundColor:[UIColor clearColor]];
        loadLabel.text =@"Loading More";loadLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment =UITextAlignmentCenter;
        loadLabel.textColor =[UIColor colorWithWhite:0.4f alpha:1.0f];
        loadLabel.backgroundColor =[UIColor clearColor];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinning.frame = CGRectMake(120,20,80,80);
        [spinning startAnimating];[loading addSubview:spinning];
        self.refreshViewdown= [[UIView alloc] initWithFrame:CGRectMake(0,PROFILE_ELEMENT_VIEW_HEIGHT*([self.blockViews count]/2+[self.blockViews count]%2),EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT/2)];
        [self.refreshViewdown removeFromSuperview];
        [self.refreshViewdown addSubview:underloading];
        [self.refreshViewdown addSubview:loading];
        [self.mainScrollView addSubview:self.refreshViewdown];
        self.mainScrollView.contentSize =CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.blockViews count]/2+[self.blockViews count]%2+0.5)*PROFILE_ELEMENT_VIEW_HEIGHT);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@&user_id=%@&page=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id,self.refresh_page_num];
        NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        NSLog(@"ExploreViewController request2:%@",request_string);
        //set the freshConnectionType To @"Add"
        self.freshConnectionType=@"Add";
        [connection start];
    }
    
}

#pragma mark - get more data and show the more event
-(void)refreshAllTheMainScrollViewSUbviews{

    
    [self.refreshView removeFromSuperview];
    ProfileEventElement *Element=(ProfileEventElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EVENT_ELEMENT_CONTENT_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];
    
    [self.mainScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, ([self.blockViews count]/2 + [self.blockViews count]%2)*PROFILE_ELEMENT_VIEW_HEIGHT)];
}
//use to add more (than 10) from down side
-(void)addMoreDataToTheMainScrollViewSUbviews{
    ProfileEventElement *Element=(ProfileEventElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    [self.mainScrollView setContentSize:CGSizeMake(VIEW_WIDTH, ([self.blockViews count]/2 + [self.blockViews count]%2)*PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT)];
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
    //renew the 10 newest features!!!!
    if ([self.freshConnectionType isEqualToString:@"New"]) {
        //set the freshConnectionType to "not"
        
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        //NSLog(@"%@",json);
        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
        if ([[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]]) {
            //do nothing here, if there is no diff
            self.refresh_page_num=2;
            self.freshConnectionType=@"not";
            if (!self.isViewAppearConnection) {
                for (UIView *view in [self.mainScrollView subviews]) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                    //NSLog(@"put %f",view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2);
                }
            }
        }
        else{
            self.refresh_page_num=2;
            self.lastReceivedJson_bookmark=json;
            //clean the page
            for (UIView* subView in self.mainScrollView.subviews) {
                [subView removeFromSuperview];
            }
            
            [self.blockViews removeAllObjects];
            //set the freshConnectionType to "not"
            self.freshConnectionType=@"not";
            for (NSDictionary *event in json) {
                //after receive the new page, add the next request page number
                NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                NSString *title=[event objectForKey:@"title"];
                NSString *event_photo_url=[event objectForKey:@"photo_url"];
                NSString *locationName=[event objectForKey:@"location"];
                NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                NSString *longitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"longitude"]];
                NSString *latitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"latitude"]];
                CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];

                CLLocation *current_location = self.current_location_manager.location;
                
                CLLocationDistance distance;
                if ([latitude isEqualToString:@"<null>"] || [longitude isEqualToString:@"<null>"]) {
                    distance = -1;
                } else {
                    distance = [current_location distanceFromLocation:location]*0.000621371;
                }                
                if (!title) {
                    continue;
                }
                if ([[NSString stringWithFormat:@"%@",event_photo_url] isEqualToString:@"<null>"]) {
                    continue;
                }
                NSURL *url=[NSURL URLWithString:event_photo_url];
                if (![Cache isURLCached:url]) {
                    //using high priority queue to fetch the image
                    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                        //get the image data
                        NSData * imageData = nil;
                        imageData = [[NSData alloc] initWithContentsOfURL: url];
                        
                        if ( imageData == nil ){
                            //if the image data is nil, the image url is not reachable. using a default image to replace that
                            //NSLog(@"downloaded %@ error, using a default image",url);
                            UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
                            imageData=UIImagePNGRepresentation(image);
                            
                            if(imageData){
                                dispatch_async( dispatch_get_main_queue(),^{
                                    [Cache addDataToCache:url withData:imageData];
                                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
                                    ;
                                    //refresh the whole view
                                    NSLog(@"profile0:%@",event_id);
                                    [self refreshAllTheMainScrollViewSUbviews];
                                });
                            }
                        }
                        else {
                            //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                            //NSLog(@"downloaded %@",url);
                            if(imageData){
                                dispatch_async( dispatch_get_main_queue(),^{
                                    [Cache addDataToCache:url withData:imageData];
                                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                                    //refresh the whole view
                                    NSLog(@"profile0:%@",event_id);
                                    [self refreshAllTheMainScrollViewSUbviews];
                                });
                            }
                        }
                    });
                }
                else {
                    dispatch_async( dispatch_get_main_queue(),^{
                        [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                        //refresh the whole view
                        NSLog(@"profile1:%@",shared_event_id);
                        [self refreshAllTheMainScrollViewSUbviews];
                    });
                }
                [self.refreshViewdown removeFromSuperview];
            }
            self.freshConnectionType=@"not";
        }
        
    }
    else if([self.freshConnectionType isEqualToString:@"Add"]){
        //set the freshConnectionType to "not"
        //self.freshConnectionType=@"not";
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        //after receive the new page, add the next request page number
        self.refresh_page_num++;
        if ([json count]==0) {
            //if the new received data is null, we know that this page is empty, no more data, so no need to add the next request page data.
            self.refresh_page_num--;
            [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.blockViews count]/2 + [self.blockViews count]%2)*PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT)];
        }
        
        //set the freshConnectionType to "not"
        self.freshConnectionType=@"not";
        for (NSDictionary *event in json) {
            //after receive the new page, add the next request page number
            NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *title=[event objectForKey:@"title"];
            NSString *event_photo_url=[event objectForKey:@"photo_url"];
            NSString *locationName=[event objectForKey:@"location"];
            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            NSString *longitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"longitude"]];
            NSString *latitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"latitude"]];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];

            CLLocation *current_location = self.current_location_manager.location;
            CLLocationDistance distance;
            if ([latitude isEqualToString:@"<null>"] || [longitude isEqualToString:@"<null>"]) {
                distance = -1;
            } else {
                distance = [current_location distanceFromLocation:location]*0.000621371;
            }
            
            if (!title) {
                continue;
            }
            if ([[NSString stringWithFormat:@"%@",event_photo_url] isEqualToString:@"<null>"]) {
                continue;
            }
            NSURL *url=[NSURL URLWithString:event_photo_url];
            if (![Cache isURLCached:url]) {
                //using high priority queue to fetch the image
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                    //get the image data
                    NSData * imageData = nil;
                    imageData = [[NSData alloc] initWithContentsOfURL: url];
                    
                    if ( imageData == nil ){
                        //if the image data is nil, the image url is not reachable. using a default image to replace that
                        //NSLog(@"downloaded %@ error, using a default image",url);
                        UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
                        imageData=UIImagePNGRepresentation(image);
                        
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:url withData:imageData];
                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
                                ;
                                //refresh the whole view
                                NSLog(@"profile0:%@",event_id);
                                [self addMoreDataToTheMainScrollViewSUbviews];
                            });
                        }
                    }
                    else {
                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                        //NSLog(@"downloaded %@",url);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:url withData:imageData];
                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                                //refresh the whole view
                                NSLog(@"profile0:%@",event_id);
                                [self addMoreDataToTheMainScrollViewSUbviews];
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                    //refresh the whole view
                    NSLog(@"profile1:%@",shared_event_id);
                    [self addMoreDataToTheMainScrollViewSUbviews];
                });
            }
            [self.refreshViewdown removeFromSuperview];
        }
        
        [self.refreshViewdown removeFromSuperview];
    }

}

#pragma mark - Gesture handler

//handle when user tap a certain block view
-(void)tapBlock:(UITapGestureRecognizer *)tapGR {
    
    CGPoint touchPoint=[tapGR locationInView:[self mainScrollView]];
    //get the index of the touched block view
    int index_y=touchPoint.y/PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT;
    int index_x=touchPoint.x/160;
    ProfileEventElement* tapped_element=[self.blockViews objectAtIndex:index_y*2+index_x];
    self.tapped_event_id=tapped_element.event_id;
    self.tapped_shared_event_id=tapped_element.shared_event_id;
    //do some pre-segue stuff with event_id and shared_id
    [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
    
    /*
    self.detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:self.detailViewController animated:YES completion:^{}];
    */
}

@end
