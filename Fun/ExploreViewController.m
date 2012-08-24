//
//  ExploreBlockElement.m
//  Fun
//
//  Created by Tongda Zhang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExploreViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DetailViewController.h"



@interface ExploreViewController ()
@property CGFloat currentY;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *CategoryFilterButton;


@property (nonatomic,retain) NSMutableArray *blockViews;
@property (nonatomic,retain) UIImageView *refreshView;
@property (nonatomic,retain) UIView *refreshViewdown;
@property (nonatomic,retain) UIView *antiTouchMaskView;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *freshConnectionType;
@property (nonatomic) int refresh_page_num;
@property (nonatomic,strong) NSString *tapped_event_id;
@property (nonatomic,strong) NSString *tapped_shared_event_id;
@property (nonatomic,strong) NSMutableArray *garbageCollection;
@property (nonatomic,strong) NSString *tapped_creator_id;
@property (nonatomic,weak) CLLocationManager *myLocationManager;

@property (nonatomic,strong) UIActionSheet *actionSheet;
@property (nonatomic,strong) NSString *pickerType;
@property (nonatomic,strong) NSString *categoryFilter;
@property (nonatomic,strong) NSString *categoryFilter_id;
@property (nonatomic)BOOL isCategoryPickerSelected;

@end

@implementation ExploreViewController
@synthesize refreshView=_refreshView;
@synthesize refreshViewdown=_refreshViewdown;

@synthesize blockViews = _blockViews;
@synthesize currentY = _currentY;
@synthesize mainScrollView = _mainScrollView;
@synthesize refreshButton = _refreshButton;
@synthesize CategoryFilterButton = _CategoryFilterButton;

@synthesize data=_data;
@synthesize freshConnectionType=_freshConnectionType;
@synthesize refresh_page_num=_refresh_page_num;
@synthesize tapped_event_id=_tapped_event_id;
@synthesize tapped_shared_event_id=_tapped_shared_event_id;
@synthesize garbageCollection=_garbageCollection;
@synthesize tapped_creator_id=_tapped_creator_id;
@synthesize antiTouchMaskView=_antiTouchMaskView;
@synthesize myLocationManager=_myLocationManager;

@synthesize actionSheet=_actionSheet;
@synthesize pickerType=_pickerType;
@synthesize categoryFilter=_categoryFilter;
@synthesize categoryFilter_id=_categoryFilter_id;
@synthesize isCategoryPickerSelected=_isCategoryPickerSelected;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (NSMutableArray *)blockViews {
    if (_blockViews == nil) {
        _blockViews = [[NSMutableArray alloc] init];
    }
    return _blockViews;
}


#pragma mark - View Life circle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //check for internet connection, if no connection, showing alert
    [CheckForInternetConnection CheckForConnectionToBackEndServer];
    
    
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
    if ([defaults objectForKey:@"login_auth_token"]&&![defaults objectForKey:@"notTheFirstTime"]) {
        NSLog(@"start introducing");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"yes" forKey:@"notTheFirstTime"];
        [defaults synchronize];
        [self performSegueWithIdentifier:@"StartIntroduceToTheApp" sender:self];
    }
    //ask user to require location
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    
    self.myLocationManager=funAppdelegate.myLocationManager;
    //refresh part
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];    
//    
//    UILabel *instruction = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, 260, 50)];
//    [instruction setText:@"See what are popular around you!"];
//    [instruction setFont:[UIFont boldSystemFontOfSize:14]];
//    [instruction setTextColor:[UIColor darkGrayColor]];
//    [instruction setBackgroundColor:[UIColor clearColor]];
//    [instruction setTextAlignment:UITextAlignmentCenter];
//    [self.mainScrollView addSubview:instruction];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation Bar Style
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    self.CategoryFilterButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    //change the color style of the refresh button
    self.refreshButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        NSURL *url=nil;
        if (self.categoryFilter_id) {
            if ([defaults objectForKey:@"login_auth_token"]) {
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&category_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.categoryFilter_id]];
                }
            }
            else{
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?category_id=%@",CONNECT_DOMIAN_NAME,self.categoryFilter_id]];
                }
            }
        } else {
            if ([defaults objectForKey:@"login_auth_token"]) {
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
                }
            }
            else{
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore",CONNECT_DOMIAN_NAME]];
                }
            }
        }
        
        
        NSLog(@"%@",url);
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                    NSError *error;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    NSLog(@"%@",json);
                    //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                    self.refresh_page_num=2;
                    
                    //clean the page
                    for (UIView* subView in self.mainScrollView.subviews) {
                        [subView removeFromSuperview];
                    }
                    [self.blockViews removeAllObjects];
                    for (NSDictionary* event in json) {
                        NSString *title=[event objectForKey:@"title"];
                        //NSString *description=[event objectForKey:@"description"];
                        NSString *photo=[event objectForKey:@"photo_url"];
                        NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                        //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
                        //NSString *num_interests=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_interests"]];
                        NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
                        NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                        NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                        NSString *locationName=[event objectForKey:@"location"];
                        NSString *creator_name=[event objectForKey:@"creator_name"];
                        NSString *creator_pic=[event objectForKey:@"creator_pic"];
                        NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
                        NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
                        
                        
                        if (!title) {continue;}
                        if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
                        NSURL *url=[NSURL URLWithString:photo];
                        [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+CONTENT_OFFSET_Y backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id  withEventCategory:event_category] atIndex:[self.blockViews count]];
                        //refresh the whole view
                        [self refreshAllTheMainScrollViewSUbviews];
                        
                    }
                    self.freshConnectionType=@"not"; 
                
            }
            else{
                //connect error
                
            }
            
        });
        
    });
    
    //set view background
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    
    //set mainScrollView layout styles
    self.mainScrollView.contentSize = CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, 0);
    [self.mainScrollView setContentOffset:CGPointMake(EXPLORE_PART_SCROLLVIEW_CONTENT_OFFSET_X, EXPLORE_PART_SCROLLVIEW_CONTENT_OFFSET_Y)];
}


- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [self setRefreshButton:nil];

    [self setCategoryFilterButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


#pragma mark - autorotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - implement the UIScrollViewDelegate
//when the scrolling over 最上方，need refresh process
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //NSLog(@"end here x=%f, y=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
    //if there already has a connection, donot create a new one, just return
    if (![self.freshConnectionType isEqualToString:@"not"]) {
        return;
    }
    
    //this is the upper most position that need to reget the most popular 10 events
    if (scrollView.contentOffset.y < -15) {
        
        //remove the main views
        for (UIView *view in [self.mainScrollView subviews]) {
            [view setFrame:CGRectMake(5, view.frame.origin.y+40, view.frame.size.width, view.frame.size.height)];
            //NSLog(@"put %f",view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2);
        }
        
        
        //set the refresh view ahead & and also the anti touch mask
        //NSLog(@"get most 10 popular pages called");
        [self.refreshView setFrame:CGRectMake(0, 0, 320, 50)];

        for(UIView *subview in [self.refreshView subviews]) {
            [subview removeFromSuperview];
        }
        
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
        loading.backgroundColor =[UIColor clearColor];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(130,15,80,20)];
        loadLabel.text =@"LOADING...";
        loadLabel.font =[UIFont boldSystemFontOfSize:12.0f];
        loadLabel.textAlignment = UITextAlignmentCenter;
        loadLabel.textColor =[UIColor darkGrayColor];
        loadLabel.backgroundColor =[UIColor clearColor];
        [loadLabel setShadowColor:[UIColor whiteColor]];
        [loadLabel setShadowOffset:CGSizeMake(0, 1)];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinning.frame =CGRectMake(115,15,20,20);
        [spinning startAnimating];
        [loading addSubview:spinning];
        [self.refreshView addSubview:loading];
        
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
            NSURL *url=nil;
            
            
            if (self.categoryFilter_id) {
                if ([defaults objectForKey:@"login_auth_token"]) {
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&category_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.categoryFilter_id]];
                    }
                }
                else{
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?category_id=%@",CONNECT_DOMIAN_NAME,self.categoryFilter_id]];
                    }
                }
            } else {
                if ([defaults objectForKey:@"login_auth_token"]) {
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
                    }
                }
                else{
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore",CONNECT_DOMIAN_NAME]];
                    }
                }
            }
            
            NSLog(@"%@",url);
            ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];

            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                        //set the freshConnectionType to "not"
                        
                        NSError *error;
                        NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                        NSLog(@"%@",json);
                        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                        self.refresh_page_num=2;
                        
                        //clean the page
                        for (UIView* subView in self.mainScrollView.subviews) {
                            [subView removeFromSuperview];
                        }
                        [self.blockViews removeAllObjects];
                        for (NSDictionary* event in json) {
                            NSString *title=[event objectForKey:@"title"];
                            //NSString *description=[event objectForKey:@"description"];
                            NSString *photo=[event objectForKey:@"photo_url"];
                            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                            //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
                            //NSString *num_interests=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_interests"]];
                            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
                            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                            NSString *locationName=[event objectForKey:@"location"];
                            NSString *creator_name=[event objectForKey:@"creator_name"];
                            NSString *creator_pic=[event objectForKey:@"creator_pic"];
                            NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
                            NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
                            
                            
                            if (!title) {continue;}
                            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
                            NSURL *url=[NSURL URLWithString:photo];
                            [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+CONTENT_OFFSET_Y backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id  withEventCategory:event_category] atIndex:[self.blockViews count]];
                            //refresh the whole view
                            [self refreshAllTheMainScrollViewSUbviews];
                            
                        }
                        self.freshConnectionType=@"not"; 
                    
                }
                else{
                    //connect error
                    
                }
                
            });
             
            
        });
    }
    //add more of the featured event
    else if(scrollView.contentOffset.y>EVENT_ELEMENT_CONTENT_HEIGHT*([self.blockViews count]-2.5))
    {
        //add the content add refresh indicator
        for(UIView *subview in [self.refreshViewdown subviews]) {
            [subview removeFromSuperview];
        }
        UIView *loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
        loading.backgroundColor =[UIColor clearColor];
        UILabel *loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(130,15,80,20)];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text =@"LOADING...";
        loadLabel.font =[UIFont boldSystemFontOfSize:12.0f];
        loadLabel.textAlignment =UITextAlignmentCenter;
        loadLabel.textColor =[UIColor darkGrayColor];
        [loadLabel setShadowColor:[UIColor whiteColor]];
        [loadLabel setShadowOffset:CGSizeMake(0, 1)];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView *spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinning.frame = CGRectMake(115,15,20,20);
        [spinning startAnimating];
        [loading addSubview:spinning];
        self.refreshViewdown= [[UIView alloc] initWithFrame:CGRectMake(0,(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)*([self.blockViews count]),320,50)];
        [self.refreshViewdown removeFromSuperview];
        [self.refreshViewdown addSubview:loading];
        [self.mainScrollView addSubview:self.refreshViewdown];
        self.mainScrollView.contentSize =CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.blockViews count])*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+50);
        
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
            NSURL *url=nil;
            if (self.categoryFilter_id) {
                if ([defaults objectForKey:@"login_auth_token"]) {
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?page=%d&auth_token=%@&current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?page=%d&auth_token=%@&category_id=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,[defaults objectForKey:@"login_auth_token"],self.categoryFilter_id]];
                    }
                }
                else{
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?page=%d&current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?page=%d&category_id=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,self.categoryFilter_id]];
                    }
                }
            } else {
                if ([defaults objectForKey:@"login_auth_token"]) {
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?page=%d&auth_token=%@&current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,self.refresh_page_num,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/page=%d&explore?auth_token=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,[defaults objectForKey:@"login_auth_token"]]];
                    }
                }
                else{
                    if([CLLocationManager regionMonitoringEnabled]){
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/page=%d&explore?current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,self.refresh_page_num,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                    }
                    else{
                        url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/page=%d&explore",CONNECT_DOMIAN_NAME,self.refresh_page_num]];
                    }
                }
            }

            NSLog(@"%@",url);
            ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
            
            [request setRequestMethod:@"GET"];
            
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    
                    //set the freshConnectionType to "not"
                    self.freshConnectionType=@"not";
                    NSError *error;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    //after receive the new page, add the next request page number
                    self.refresh_page_num++;
                    if ([json count]==0) {
                        //if the new received data is null, we know that this page is empty, no more data, so no need to add the next request page data.
                        NSLog(@"%d",self.refresh_page_num);
                        self.refresh_page_num--;
                        [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+50)];
                        [spinning removeFromSuperview];
                        loadLabel.frame = CGRectMake(120, 15, 80, 20);
                        loadLabel.text = @"ALL LOADED";
                    }
                    else{
                        for (NSDictionary* event in json) {
                            NSString *title=[event objectForKey:@"title"];
                            //NSString *description=[event objectForKey:@"description"];
                            NSString *photo=[event objectForKey:@"photo_url"];
                            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                            //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
                            //NSString *num_interests=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_interests"]];
                            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
                            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                            NSString *locationName=[event objectForKey:@"location"];
                            NSString *creator_name=[event objectForKey:@"creator_name"];
                            NSString *creator_pic=[event objectForKey:@"creator_pic"];
                            NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
                            NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
                            
                            if (!title) {continue;}
                            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
                            
                            NSURL *url=[NSURL URLWithString:photo];
                            [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+CONTENT_OFFSET_Y backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id  withLocationName:locationName  withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id withEventCategory:event_category] atIndex:[self.blockViews count]];
                            
                            //refresh the whole view
                            [self addMoreDataToTheMainScrollViewSUbviews];
                            
                        }
                        [self.refreshViewdown removeFromSuperview];
                    }
                }
                else{
                    //connect error
                    
                }
                
            });
            
        });
    }
  
}

#pragma mark - choose category filter button
#pragma mark UIPickerViewDelegate Methods



- (void)createActionSheet {

        // setup actionsheet to contain the UIPicker
        self.actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:nil];
        
        UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        pickerToolbar.barStyle = UIBarStyleBlackOpaque;
        [pickerToolbar sizeToFit];
        
        NSMutableArray *barItems = [[NSMutableArray alloc] init];
        
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [barItems addObject:flexSpace];

        
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone:)];
        [barItems addObject:doneBtn];

        
        [pickerToolbar setItems:barItems animated:YES];

        
        [self.actionSheet addSubview:pickerToolbar];

        [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
       // [self.actionSheet showInView:self.view];
        [self.actionSheet setBounds:CGRectMake(0,0,320, 464)];
    
}
- (IBAction)CategoryFilterClicked:(id)sender {
    [self createActionSheet];
    self.pickerType = @"picker";
    UIPickerView *chPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    chPicker.dataSource = self;
    chPicker.delegate = self;
    chPicker.showsSelectionIndicator = YES;
    [self.actionSheet addSubview:chPicker];

}





- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    self.categoryFilter_id=nil;
   [self.CategoryFilterButton setTitle:@"All"];
    self.isCategoryPickerSelected=NO;
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int count;
    if ([self.pickerType isEqualToString:@"picker"])
        count = 10;
    return count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *string;
    NSArray *category=[NSArray arrayWithObjects:@"All events",@"Food",@"Movie",@"Sports",@"Party",@"Outdoor",@"Entertain",@"Event",@"Shopping",@"Other", nil];
    if ([self.pickerType isEqualToString:@"picker"])
        string = [category objectAtIndex:row];
    return string;
}
// Set the width of the component inside the picker
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component             {
    return 200;
}

// Item picked
- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *category=[NSArray arrayWithObjects:@"All events",@"Food",@"Movie",@"Sports",@"Party",@"Outdoor",@"Entertain",@"Event",@"Shopping",@"Other", nil];
    if ([self.pickerType isEqualToString:@"picker"])
    {
        self.categoryFilter=[category objectAtIndex:row];
       // Txt.text = [array objectAtIndex:row];
    }
    self.isCategoryPickerSelected=YES;
    NSLog(@"%@",self.categoryFilter);
}

- (void)pickerDone:(id)sender
{
    if (!self.isCategoryPickerSelected) {
        self.categoryFilter_id=nil;
        [self.CategoryFilterButton setTitle:@"All"];
        [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        [self RefreshAction];
        return;
    }
    [self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
    self.actionSheet = nil;
    //self.actionSheet
    NSLog(@"%@",self.categoryFilter);
    if ([self.categoryFilter isEqualToString:@"All events"]||!self.categoryFilter) {
        self.categoryFilter_id=nil;
        [self.CategoryFilterButton setTitle:@"All"];

    }
    else if([self.categoryFilter isEqualToString:@"Food"]){
        self.categoryFilter_id=FOOD;
        [self.CategoryFilterButton setTitle:@"Food"];
    }
    else if([self.categoryFilter isEqualToString:@"Movie"]){
        self.categoryFilter_id=MOVIE;
        [self.CategoryFilterButton setTitle:@"Movie"];
    }
    else if([self.categoryFilter isEqualToString:@"Sports"]){
        self.categoryFilter_id=SPORTS;
        [self.CategoryFilterButton setTitle:@"Sports"];
    }
    else if([self.categoryFilter isEqualToString:@"Party"]){
        self.categoryFilter_id=NIGHTLIFE;
        [self.CategoryFilterButton setTitle:@"Party"];
    }
    else if([self.categoryFilter isEqualToString:@"Outdoor"]){
        self.categoryFilter_id=OUTDOOR;
        [self.CategoryFilterButton setTitle:@"Outdoor"];
    }
    else if([self.categoryFilter isEqualToString:@"Entertain"]){
        self.categoryFilter_id=ENTERTAIN;
        [self.CategoryFilterButton setTitle:@"Entertain"];
    }
    else if([self.categoryFilter isEqualToString:@"Event"]){
        self.categoryFilter_id=EVENTS;
        [self.CategoryFilterButton setTitle:@"Event"];
    }
    else if([self.categoryFilter isEqualToString:@"Shopping"]){
        self.categoryFilter_id=SHOPPING;
        [self.CategoryFilterButton setTitle:@"Shopping"];
    }
    else if([self.categoryFilter isEqualToString:@"Other"]){
        self.categoryFilter_id=OTHERS;
        [self.CategoryFilterButton setTitle:@"Other"];
    }
    [self RefreshAction];
}



#pragma mark - refresh button action part
- (IBAction)refreshButtonClicked:(id)sender {
    //disable the button before the request is finshed
    [self.refreshButton setEnabled:NO];
    
    [self RefreshAction];
}


-(void)RefreshAction{
    //remove the main views
    for (UIView *view in [self.mainScrollView subviews]) {
        [view setFrame:CGRectMake(5, view.frame.origin.y+40, view.frame.size.width, view.frame.size.height)];
        //NSLog(@"put %f",view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2);
    }
    
    //set the refresh view ahead & and also the anti touch mask
    //NSLog(@"get most 10 popular pages called");
    [self.refreshView setFrame:CGRectMake(0, 0, 320, 50)];
    
    for(UIView *subview in [self.refreshView subviews]) {
        [subview removeFromSuperview];
    }
    
    UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,320,50)];
    loading.backgroundColor =[UIColor clearColor];
    UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(130,15,80,20)];
    loadLabel.text =@"LOADING...";
    loadLabel.font =[UIFont boldSystemFontOfSize:12.0f];
    loadLabel.textAlignment = UITextAlignmentCenter;
    loadLabel.textColor =[UIColor darkGrayColor];
    loadLabel.backgroundColor =[UIColor clearColor];
    [loadLabel setShadowColor:[UIColor whiteColor]];
    [loadLabel setShadowOffset:CGSizeMake(0, 1)];
    [loading addSubview:loadLabel];
    UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinning.frame =CGRectMake(115,15,20,20);
    [spinning startAnimating];
    [loading addSubview:spinning];
    [self.refreshView addSubview:loading];
    
    [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        FunAppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
        NSURL *url=nil;
        if (self.categoryFilter_id) {
            if ([defaults objectForKey:@"login_auth_token"]) {
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&category_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.categoryFilter_id]];
                }
            }
            else{
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?current_longitude=%f&current_latitude=%f&category_id=%@",CONNECT_DOMIAN_NAME,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude,self.categoryFilter_id]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?category_id=%@",CONNECT_DOMIAN_NAME,self.categoryFilter_id]];
                }
            }
        } else {
            if ([defaults objectForKey:@"login_auth_token"]) {
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@&current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]]];
                }
            }
            else{
                if([CLLocationManager regionMonitoringEnabled]){
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore?current_longitude=%f&current_latitude=%f",CONNECT_DOMIAN_NAME,appDelegate.myLocationManager.location.coordinate.longitude,appDelegate.myLocationManager.location.coordinate.latitude]];
                }
                else{
                    url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/explore",CONNECT_DOMIAN_NAME]];
                }
            }
        }
        
        NSLog(@"%@",url);
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        [request setRequestMethod:@"GET"];
        [request startSynchronous];

        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            
            //enable the button after the request is finshed
            [self.refreshButton setEnabled:YES];
            
            if (code==200) {
                //success
                //set the freshConnectionType to "not"
                
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];

                //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                self.refresh_page_num=2;
                
                //clean the page
                for (UIView* subView in self.mainScrollView.subviews) {
                    [subView removeFromSuperview];
                }
                [self.blockViews removeAllObjects];
                for (NSDictionary* event in json) {
                    NSString *title=[event objectForKey:@"title"];
                    //NSString *description=[event objectForKey:@"description"];
                    NSString *photo=[event objectForKey:@"photo_url"];
                    NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                    //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
                    //NSString *num_interests=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_interests"]];
                    NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
                    NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                    NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                    NSString *locationName=[event objectForKey:@"location"];
                    NSString *creator_name=[event objectForKey:@"creator_name"];
                    NSString *creator_pic=[event objectForKey:@"creator_pic"];
                    NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
                    NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
                    
                    
                    if (!title) {continue;}
                    if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
                    NSURL *url=[NSURL URLWithString:photo];
                    [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+CONTENT_OFFSET_Y backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id  withEventCategory:event_category] atIndex:[self.blockViews count]];
                    //refresh the whole view
                    [self refreshAllTheMainScrollViewSUbviews];
                    
                }
                self.freshConnectionType=@"not";
                
            }
            else{
                //connect error
                
            }
            
        });
        
        
    });
}




#pragma mark - already load the new data, refresh the whole view/ or add more on the down side
-(void)refreshAllTheMainScrollViewSUbviews{
    [self.refreshView removeFromSuperview];
    ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EVENT_ELEMENT_CONTENT_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];
    [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP))];
}
//use to add more (than 10) from down side
-(void)addMoreDataToTheMainScrollViewSUbviews{
    ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP))];
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

}


//when the connection get the returned data (json form)
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //renew the 10 newest features!!!!
    if ([self.freshConnectionType isEqualToString:@"New"]) {
        //set the freshConnectionType to "not"
         
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        NSLog(@"%@",json);
        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
        self.refresh_page_num=2;
        
        //clean the page
        for (UIView* subView in self.mainScrollView.subviews) {
            [subView removeFromSuperview];
        }
        [self.blockViews removeAllObjects];
        for (NSDictionary* event in json) {
            NSString *title=[event objectForKey:@"title"];
            //NSString *description=[event objectForKey:@"description"];
            NSString *photo=[event objectForKey:@"photo_url"];
            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
            //NSString *num_interests=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_interests"]];
            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *locationName=[event objectForKey:@"location"];
            NSString *creator_name=[event objectForKey:@"creator_name"];
            NSString *creator_pic=[event objectForKey:@"creator_pic"];
            NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
            NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
            
            
            if (!title) {continue;}
            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
            NSURL *url=[NSURL URLWithString:photo];
            [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+CONTENT_OFFSET_Y backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id  withEventCategory:event_category] atIndex:[self.blockViews count]];
            //refresh the whole view
            [self refreshAllTheMainScrollViewSUbviews];
        
        }
        self.freshConnectionType=@"not"; 
    }
    else if([self.freshConnectionType isEqualToString:@"Add"]){
        //set the freshConnectionType to "not"
        self.freshConnectionType=@"not";
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        //after receive the new page, add the next request page number
        self.refresh_page_num++;
        if ([json count]==0) {
            //if the new received data is null, we know that this page is empty, no more data, so no need to add the next request page data.
            self.refresh_page_num--;
            [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP))];
        }
        for (NSDictionary* event in json) {
            NSString *title=[event objectForKey:@"title"];
            //NSString *description=[event objectForKey:@"description"];
            NSString *photo=[event objectForKey:@"photo_url"];
            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
            //NSString *num_interests=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_interests"]];
            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *locationName=[event objectForKey:@"location"];
            NSString *creator_name=[event objectForKey:@"creator_name"];
            NSString *creator_pic=[event objectForKey:@"creator_pic"];
            NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
            NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
            
            if (!title) {continue;}
            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
            
            NSURL *url=[NSURL URLWithString:photo];
            [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP)+CONTENT_OFFSET_Y backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id  withLocationName:locationName  withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id withEventCategory:event_category] atIndex:[self.blockViews count]];
            
            //refresh the whole view
            [self addMoreDataToTheMainScrollViewSUbviews];

        }        
        [self.refreshViewdown removeFromSuperview];
    }
    
}
#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ViewEventDetail"]) {
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        //if it's the segue to the view detail part, do this:
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        [detailVC preSetTheEventID:self.tapped_event_id andSetTheSharedEventID:self.tapped_shared_event_id andSetIsOwner:[[NSString stringWithFormat:@"%@",[defaults objectForKey:@"user_id"]] isEqualToString:self.tapped_creator_id]];
        [detailVC preSetServerLogViaParameter:VIA_EXPLORE];
    }
    else if([segue.identifier isEqualToString:@"ViewOthersProfile"]){
        OtherProfilePageViewController* OPPVC=segue.destinationViewController;
        OPPVC.creator_id=self.tapped_creator_id;
        OPPVC.via=VIA_EXPLORE;
    }
    else if([segue.identifier isEqualToString:@"ViewProfile"]){
        ProfilePageViewController* PPVC=segue.destinationViewController;
        PPVC.via=VIA_EXPLORE;
    }
}

#pragma mark - Gesture handler

//handle when user tap a certain block view
-(void)tapBlock:(UITapGestureRecognizer *)tapGR {
    if ([self.blockViews count]==0) {
        return;
    }
    CGPoint touchPoint=[tapGR locationInView:[self mainScrollView]];
    float tempTouchPointY=touchPoint.y;
    if ([self.freshConnectionType isEqualToString:@"New"]) {
        tempTouchPointY-=EVENT_ELEMENT_CONTENT_HEIGHT/2;
    }
    //get the index of the touched block view
    int index=tempTouchPointY/(EVENT_ELEMENT_CONTENT_HEIGHT+EVENT_ELEMENT_GAP);
    ExploreBlockElement* tapped_element=[self.blockViews objectAtIndex:index];
    self.tapped_event_id=tapped_element.event_id;
    self.tapped_shared_event_id=tapped_element.shared_event_id;
    [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
    //do some pre-segue stuff with event_id and shared_id
    /*
     self.detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:self.detailViewController animated:YES completion:^{}];
     */
}

@end
