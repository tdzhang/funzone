//
//  ProfilePageViewController.m
//  Fun
//
//  Created by Tongda Zhang on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfilePageViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CheckForInternetConnection.h"


@interface ProfilePageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *joinedScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *creatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookmarkNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentControl;
@property (weak, nonatomic) IBOutlet UIView *profileHeaderView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;

@property (nonatomic, strong) UIButton* showAllFollowingsButton;
@property (nonatomic,retain) NSMutableArray *blockViews;
@property (nonatomic,retain) NSMutableArray *joined_blockViews;
@property (nonatomic,retain) UIView *refreshViewdown;
@property (nonatomic,retain) UIView *joined_refreshViewdown;
@property (nonatomic,retain) UIImageView *refreshView;
@property (nonatomic,retain) UIImageView *joined_refreshView;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *freshConnectionType;
@property (nonatomic,strong) NSString *joined_freshConnectionType;
@property (nonatomic) BOOL isViewAppearConnection;
@property (nonatomic) BOOL joined_isViewAppearConnection;
@property (nonatomic) int refresh_page_num;
@property (nonatomic) int joined_refresh_page_num;
@property (nonatomic,strong) NSString *tapped_event_id;
@property (nonatomic,strong) NSString *tapped_shared_event_id;
@property (nonatomic) BOOL tapped_event_isOwner;

@property (nonatomic,weak)CLLocationManager *current_location_manager;

@property(nonatomic,strong)NSDictionary* lastReceivedJson_profile; //used to limite the refresh frequecy
@property(nonatomic,strong)NSArray* lastReceivedJson_bookmark; //used to limite the refresh frequecy
@property(nonatomic,strong)NSArray* lastReceivedJson_bookmark_joined; //used to limite the refresh frequecy


-(void)refreshAllTheMainScrollViewSUbviews;
-(void)addMoreDataToTheMainScrollViewSUbviews;
-(void)joined_refreshAllTheMainScrollViewSUbviews;

@end

@implementation ProfilePageViewController
@synthesize mainScrollView;
@synthesize joinedScrollView = _joinedScrollView;
@synthesize refreshView=_refreshView;
@synthesize joined_refreshView=_joined_refreshView;
@synthesize refreshViewdown=_refreshViewdown;
@synthesize joined_refreshViewdown=_joined_refreshViewdown;
@synthesize creatorImageView = _creatorImageView;
@synthesize creatorNameLabel = _creatorNameLabel;
@synthesize bookmarkNumLabel = _bookmarkNumLabel;
@synthesize followingNumLabel = _followingNumLabel;
@synthesize followerNumLabel = _followerNumLabel;
@synthesize mySegmentControl = _mySegmentControl;
@synthesize profileHeaderView = _profileHeaderView;
@synthesize refreshButton = _refreshButton;
@synthesize showAllFollowingsButton = _showAllFollowingsButton;
@synthesize blockViews = _blockViews;
@synthesize joined_blockViews=_joined_blockViews;
@synthesize data=_data;
@synthesize freshConnectionType=_freshConnectionType;
@synthesize joined_freshConnectionType=_joined_freshConnectionType;
@synthesize isViewAppearConnection=_isViewAppearConnection;
@synthesize joined_isViewAppearConnection=_joined_isViewAppearConnection;
@synthesize refresh_page_num=_refresh_page_num;
@synthesize joined_refresh_page_num=_joined_refresh_page_num;
@synthesize tapped_event_id=_tapped_event_id;
@synthesize tapped_shared_event_id=_tapped_shared_event_id;
@synthesize tapped_event_isOwner=_tapped_event_isOwner;

@synthesize current_location_manager=_current_location_manager;

@synthesize lastReceivedJson_bookmark=_lastReceivedJson_bookmark;
@synthesize lastReceivedJson_profile=_lastReceivedJson_profile;
@synthesize lastReceivedJson_bookmark_joined=_lastReceivedJson_bookmark_joined;

//used to keep server log
@synthesize via=_via;

-(CLLocationManager *)current_location_manager{
    if (!_current_location_manager) {
        FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
        _current_location_manager=funAppdelegate.myLocationManager;
    }
    return _current_location_manager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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

-(NSMutableArray *)joined_blockViews{
    if (_joined_blockViews == nil) {
        _joined_blockViews=[NSMutableArray array];
    }
    return _joined_blockViews;
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

-(NSArray *)lastReceivedJson_bookmark_joined{
    if (!_lastReceivedJson_bookmark_joined) {
        _lastReceivedJson_bookmark_joined=[NSArray array];
    }
    return _lastReceivedJson_bookmark_joined;
}

#pragma mark - segment control
- (IBAction)segmentControlChange:(id)sender {
    NSLog(@"%d",[self.mySegmentControl selectedSegmentIndex]);
    if ([self.mySegmentControl selectedSegmentIndex]==0) {
        [self.mainScrollView setHidden:NO];
        [self.joinedScrollView setHidden:YES];
    }
    else if ([self.mySegmentControl selectedSegmentIndex]==1){
        [self.mainScrollView setHidden:YES];
        [self.joinedScrollView setHidden:NO];
    }
}

#pragma mark - compare two json array
-(BOOL)isTwoJasonEventArrayTheSameOne:(NSArray*)one withOther:(NSArray*)two{
    BOOL result=YES;
     if([one count]!=[two count]){
         result=NO;
     }
     else{
         for (int i=0;i<[one count];i++) {
             NSDictionary* elementOne=[one objectAtIndex:i];
             NSDictionary* elementTwo=[two objectAtIndex:i];
             if (![[NSString stringWithFormat:@"%@",[elementOne objectForKey:@"event_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[elementTwo objectForKey:@"event_id"]]]) {
                 result=NO;
                 break;
             }
             if (![[NSString stringWithFormat:@"%@",[elementOne objectForKey:@"shared_event_id"]] isEqualToString:[NSString stringWithFormat:@"%@",[elementTwo objectForKey:@"shared_event_id"]]]) {
                 result=NO;
                 break;
             }
         }
     }
    return result;
}

#pragma mark - View Life Circle
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
    else{
    
    //query the user profile information
    //add login auth_token
    defaults = [NSUserDefaults standardUserDefaults];
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/profile?auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.via]];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                    if (![[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_profile]]) {
                        self.lastReceivedJson_profile=json;
                        //only update the content when there is a content different
                        [self.creatorNameLabel setText:[json objectForKey:@"name"]];
                        [self.bookmarkNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_bookmarks"]]];
                        [self.followerNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followers"]]];
                        [self.followingNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followings"]]];
                        NSURL *url=[NSURL URLWithString:[json objectForKey:@"profile_url"]];
                        NSLog(@"%@",url);
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
                
            });
            
        });
    
        
    //---------->mainScrollView
    //quest the most recent 10 events
 //the next page that need to refresh is 2
    self.freshConnectionType=@"New";
    self.isViewAppearConnection=YES;
    
    //main scroll view refresh
    self.freshConnectionType=@"New";
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]];
        NSLog(@"%@",request_string);
        NSURL *url=[NSURL URLWithString:request_string];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        ///////////////
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //set the freshConnectionType to "not"
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                [self.mySegmentControl setTitle:[NSString stringWithFormat:@"%d COLLECTED",[json count]] forSegmentAtIndex:0];
                NSLog(@"%@",[NSString stringWithFormat:@"%@",json]);
                NSLog(@"%@",[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]);
                //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                //[[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]]
                if ([self isTwoJasonEventArrayTheSameOne:json withOther:self.lastReceivedJson_bookmark]) {
                    //do nothing here, if there is no diff
                    //self.refresh_page_num=2;
                    self.freshConnectionType=@"not";
                    if (!self.isViewAppearConnection) {
                        for (UIView *view in [self.mainScrollView subviews]) {
                            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                        }
                    }
                }
                else{
                    for (UIView *view in [self.mainScrollView subviews]) {
                        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                    }
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
                        //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                        NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                            //for the image is null situation
                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
                            ;
                            [self refreshAllTheMainScrollViewSUbviews];
                        }
                        else{
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
                                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                                    //refresh the whole view
                                    NSLog(@"profile1:%@",shared_event_id);
                                    [self refreshAllTheMainScrollViewSUbviews];
                                });
                            }
                            [self.refreshViewdown removeFromSuperview];
                        }
                        
                        
                    }
                    self.freshConnectionType=@"not";
                }
            }
            else{
                //connect error
            }
            
        });
    });
    //refresh part
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
        [self.mainScrollView addSubview:self.refreshView];
    
    //---------->joined ScrollView
    //quest the most recent 10 events
    //self.joined_refresh_page_num=2; //the next page that need to refresh is 2
    self.joined_freshConnectionType=@"New";
    self.joined_isViewAppearConnection=YES;
    
    //main scroll view refresh
    self.joined_freshConnectionType=@"New";
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_string=[NSString stringWithFormat:@"%@/invitations?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]];
        NSLog(@"%@",request_string);
        NSURL *url=[NSURL URLWithString:request_string];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        ///////////////
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //set the freshConnectionType to "not"
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                [self.mySegmentControl setTitle:[NSString stringWithFormat:@"%d INVITED",[json count]] forSegmentAtIndex:1];
                //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                //[[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark_joined]]
                if ([self isTwoJasonEventArrayTheSameOne:json withOther:self.lastReceivedJson_bookmark_joined]) {
                    //do nothing here, if there is no diff
                    //self.joined_refresh_page_num=2;
                    self.joined_freshConnectionType=@"not";
                    if (!self.joined_isViewAppearConnection) {
                        for (UIView *view in [self.joinedScrollView subviews]) {
                            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                        }
                    }
                }
                else{
                    for (UIView *view in [self.joinedScrollView subviews]) {
                        [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                    }
                    self.joined_refresh_page_num=2;
                    self.lastReceivedJson_bookmark_joined=json;
                    //clean the page
                    for (UIView* subView in self.joinedScrollView.subviews) {
                        [subView removeFromSuperview];
                    }
                    [self.joined_blockViews removeAllObjects];
                    //set the freshConnectionType to "not"
                    self.joined_freshConnectionType=@"not";
                    for (NSDictionary *event in json) {
                        //after receive the new page, add the next request page number
                        NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                        NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                        NSString *title=[event objectForKey:@"title"];
                        NSString *event_photo_url=[event objectForKey:@"photo_url"];
                        NSString *locationName=[event objectForKey:@"location"];
                        //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                        NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                            //for the image is null situation
                            [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                            ;
                            [self joined_refreshAllTheMainScrollViewSUbviews];
                        }
                        else{
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
                                                [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                                ;
                                                //refresh the whole view
                                                NSLog(@"profile0:%@",event_id);
                                                [self joined_refreshAllTheMainScrollViewSUbviews];
                                            });
                                        }
                                    }
                                    else {
                                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                                        //NSLog(@"downloaded %@",url);
                                        if(imageData){
                                            dispatch_async( dispatch_get_main_queue(),^{
                                                [Cache addDataToCache:url withData:imageData];
                                                [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                                //refresh the whole view
                                                NSLog(@"profile0:%@",event_id);
                                                [self joined_refreshAllTheMainScrollViewSUbviews];
                                            });
                                        }
                                    }
                                });
                            }
                            else {
                                dispatch_async( dispatch_get_main_queue(),^{
                                    [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                    //refresh the whole view
                                    NSLog(@"profile1:%@",shared_event_id);
                                    [self joined_refreshAllTheMainScrollViewSUbviews];
                                });
                            }
                            [self.joined_refreshViewdown removeFromSuperview];
                        }
                        
                        
                    }
                    self.joined_freshConnectionType=@"not";
                }
            }
            else{
                //connect error
            }
            
        });
        
        ////////////////
        
        
    });
    
        //refresh part
        self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
        [self.mainScrollView addSubview:self.refreshView];
        
        //refresh part
        self.joined_refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
        [self.joinedScrollView addSubview:self.joined_refreshView];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //change the color style of the refresh button
    self.refreshButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    
    //Navigation Bar Style
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStyleBordered
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:255/255.0 green:150/255.0 blue:0/255.0 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
   
    self.mySegmentControl.frame = CGRectMake(0, 70, 310, 40);
    UIImage *segmentSelected = [[UIImage imageNamed:@"tab_unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *segmentUnselected = [[UIImage imageNamed:@"tab_unselected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.mySegmentControl setBackgroundImage:segmentSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.mySegmentControl setBackgroundImage:segmentUnselected forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    // — Dividers
    UIImage *imgSelectedUnSelected = [[UIImage imageNamed:@"button_seperator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedUnSelected = [[UIImage imageNamed:@"button_seperator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *imgUnSelectedSelected = [[UIImage imageNamed:@"button_seperator.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.mySegmentControl setDividerImage:imgSelectedUnSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mySegmentControl setDividerImage:imgUnSelectedUnSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mySegmentControl setDividerImage:imgUnSelectedSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
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
    [self.view setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1]];
    
    self.profileHeaderView.layer.cornerRadius = 2;
    self.profileHeaderView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.profileHeaderView.layer.shadowOffset = CGSizeMake(0, 1);
    self.profileHeaderView.layer.shadowRadius = 1.0f;
    self.profileHeaderView.layer.shadowOpacity = 0.6f;
    
    self.creatorImageView.layer.cornerRadius = 4;
    self.creatorImageView.clipsToBounds = YES;
    [self.creatorImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.creatorImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.creatorImageView.layer.borderWidth = 1;
}

- (void)viewDidUnload{
    [self setMainScrollView:nil];
    [self setCreatorImageView:nil];
    [self setCreatorNameLabel:nil];
    [self setBookmarkNumLabel:nil];
    [self setFollowingNumLabel:nil];
    [self setFollowerNumLabel:nil];
    [self setMySegmentControl:nil];
    [self setJoinedScrollView:nil];
    [self setProfileHeaderView:nil];
    [self setRefreshButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - implement the UIScrollViewDelegate
//when the scrolling over 最上方，need refresh process
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //NSLog(@"end here x=%f, y=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
    //if there already has a connection, donot create a new one, just return
    if (![self.freshConnectionType isEqualToString:@"not"]) {
        return;
    }
    //------->Main scroll view
    if ([self.mySegmentControl selectedSegmentIndex]==0) {
        //this is the upper most position that need to reget the most popular 10 events
        if (scrollView.contentOffset.y<-EVENT_ELEMENT_CONTENT_HEIGHT/3) {
            //remove the main views
            
            for (UIView *view in [self.mainScrollView subviews]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
            }
            //refreshe the last receive json
            self.lastReceivedJson_bookmark=[NSArray array];
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
            //main scroll view refresh
            self.freshConnectionType=@"New";
            self.isViewAppearConnection=NO;
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]];
                NSLog(@"%@",request_string);
                NSURL *url=[NSURL URLWithString:request_string];
                ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
                
                [request setRequestMethod:@"GET"];
                [request startSynchronous];
                
                int code=[request responseStatusCode];
                NSLog(@"code:%d",code);
                ///////////////
                dispatch_async( dispatch_get_main_queue(),^{
                    if (code==200) {
                        //set the freshConnectionType to "not"
                        NSError *error;
                        NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                        //[[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]]
                        if ([self isTwoJasonEventArrayTheSameOne:json withOther:self.lastReceivedJson_bookmark]) {
                            //do nothing here, if there is no diff
                            self.refresh_page_num=2;
                            self.freshConnectionType=@"not";
                            if (!self.isViewAppearConnection) {
                                for (UIView *view in [self.mainScrollView subviews]) {
                                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                                }
                            }
                        }
                        else{
                            for (UIView *view in [self.mainScrollView subviews]) {
                                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                            }
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
                                //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                                NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                                    //for the image is null situation
                                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
                                    ;
                                    [self refreshAllTheMainScrollViewSUbviews];
                                }
                                else{
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
                                                        [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                                        [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                                            //refresh the whole view
                                            NSLog(@"profile1:%@",shared_event_id);
                                            [self refreshAllTheMainScrollViewSUbviews];
                                        });
                                    }
                                    [self.refreshViewdown removeFromSuperview];
                                }
                                
                                
                            }
                            self.freshConnectionType=@"not";
                        }
                    }
                    else{
                        //connect error
                    }
                    
                });
                
                ////////////////
                
                
            });
        }
        //add more of the featured event
        else if(scrollView.contentOffset.y>PROFILE_ELEMENT_VIEW_HEIGHT*(([self.blockViews count]/2+[self.blockViews count]%2-1.5))){
            if ([self.blockViews count]<7) {
                return;
            }
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
            self.mainScrollView.contentSize =CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.blockViews count]/2+[self.blockViews count]%2+0.5)*PROFILE_ELEMENT_VIEW_HEIGHT+5);
            
            //set the freshConnectionType To @"Add"
            self.freshConnectionType=@"Add";
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?page=%d&auth_token=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,[defaults objectForKey:@"login_auth_token"]];
                NSLog(@"%@",request_string);
                NSURL *url=[NSURL URLWithString:request_string];
                ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
                
                [request setRequestMethod:@"GET"];
                [request startSynchronous];
                
                int code=[request responseStatusCode];
                NSLog(@"code:%d",code);
                ///////////////
                dispatch_async( dispatch_get_main_queue(),^{
                    //set the freshConnectionType to "not"
                    //self.freshConnectionType=@"not";
                    NSError *error;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    //after receive the new page, add the next request page number
                    self.refresh_page_num++;
                    if ([json count]==0) {
                        //if the new received data is null, we know that this page is empty, no more data, so no need to add the next request page data.
                        self.refresh_page_num--;
                        [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.blockViews count]/2 + [self.blockViews count]%2)*PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT+5)];
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
                        //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                        NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
                        NSString *longitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"longitude"]];
                        NSString *latitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"latitude"]];
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
                        
                        CLLocation *current_location = self.current_location_manager.location;
                        CLLocationDistance distance;
                        if ([latitude isEqualToString:@"<null>"] || [longitude isEqualToString:@"<null>"]) {
                            distance = -1;
                        } else {
                            distance = [current_location distanceFromLocation:location]*0.000621371;
                        }            if (!title) {
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
                                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                                //refresh the whole view
                                NSLog(@"profile1:%@",shared_event_id);
                                [self addMoreDataToTheMainScrollViewSUbviews];
                            });
                        }
                        [self.refreshViewdown removeFromSuperview];
                    }
                    
                    [self.refreshViewdown removeFromSuperview];
                });
                
                ////////////////
                
                
            });
        }
    }
    //-------->Joined scroll view
    else if ([self.mySegmentControl selectedSegmentIndex]==1){
        //this is the upper most position that need to reget the most popular 10 events
        if (scrollView.contentOffset.y<-EVENT_ELEMENT_CONTENT_HEIGHT/3) {
            //remove the main views
            
            for (UIView *view in [self.joinedScrollView subviews]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
            }
            //refreshe the last receive json
            self.lastReceivedJson_bookmark_joined=[NSArray array];
            //set the refresh view ahead & and also the anti touch mask
            //NSLog(@"get most 10 popular pages called");
            [self.joined_refreshView setFrame:CGRectMake(0, 0, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT/2)];
            
            for(UIView *subview in [self.joined_refreshView subviews]) {
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
            [self.joined_refreshView addSubview:loading];
            
            [self.joinedScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            
            //and then do the refresh process
            //main scroll view refresh
            self.joined_freshConnectionType=@"New";
            self.joined_isViewAppearConnection=NO;
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *request_string=[NSString stringWithFormat:@"%@/invitations?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]];
                NSLog(@"%@",request_string);
                NSURL *url=[NSURL URLWithString:request_string];
                ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
                
                [request setRequestMethod:@"GET"];
                [request startSynchronous];
                
                int code=[request responseStatusCode];
                NSLog(@"code:%d",code);
                ///////////////
                dispatch_async( dispatch_get_main_queue(),^{
                    if (code==200) {
                        //set the freshConnectionType to "not"
                        NSError *error;
                        NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                        //[[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark_joined]]
                        if ([self isTwoJasonEventArrayTheSameOne:json withOther:self.lastReceivedJson_bookmark_joined]) {
                            //do nothing here, if there is no diff
                            self.joined_refresh_page_num=2;
                            self.joined_freshConnectionType=@"not";
                            if (!self.joined_isViewAppearConnection) {
                                for (UIView *view in [self.joinedScrollView subviews]) {
                                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                                }
                            }
                        }
                        else{
                            for (UIView *view in [self.joinedScrollView subviews]) {
                                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                            }
                            self.joined_refresh_page_num=2;
                            self.lastReceivedJson_bookmark_joined=json;
                            //clean the page
                            for (UIView* subView in self.joinedScrollView.subviews) {
                                [subView removeFromSuperview];
                            }
                            [self.joined_blockViews removeAllObjects];
                            //set the freshConnectionType to "not"
                            self.joined_freshConnectionType=@"not";
                            for (NSDictionary *event in json) {
                                //after receive the new page, add the next request page number
                                NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                                NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                                NSString *title=[event objectForKey:@"title"];
                                NSString *event_photo_url=[event objectForKey:@"photo_url"];
                                NSString *locationName=[event objectForKey:@"location"];
                                //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                                NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                                    //for the image is null situation
                                    [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                    ;
                                    [self joined_refreshAllTheMainScrollViewSUbviews];
                                }
                                else{
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
                                                        [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                                        ;
                                                        //refresh the whole view
                                                        NSLog(@"profile0:%@",event_id);
                                                        [self joined_refreshAllTheMainScrollViewSUbviews];
                                                    });
                                                }
                                            }
                                            else {
                                                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                                                //NSLog(@"downloaded %@",url);
                                                if(imageData){
                                                    dispatch_async( dispatch_get_main_queue(),^{
                                                        [Cache addDataToCache:url withData:imageData];
                                                        [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                                        //refresh the whole view
                                                        NSLog(@"profile0:%@",event_id);
                                                        [self joined_refreshAllTheMainScrollViewSUbviews];
                                                    });
                                                }
                                            }
                                        });
                                    }
                                    else {
                                        dispatch_async( dispatch_get_main_queue(),^{
                                            [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                            //refresh the whole view
                                            NSLog(@"profile1:%@",shared_event_id);
                                            [self joined_refreshAllTheMainScrollViewSUbviews];
                                        });
                                    }
                                    [self.joined_refreshViewdown removeFromSuperview];
                                }
                                
                                
                            }
                            self.joined_freshConnectionType=@"not";
                        }
                    }
                    else{
                        //connect error
                    }
                    
                });
                
                ////////////////
                
                
            });
        }
        //add more of the featured event
        else if(scrollView.contentOffset.y>PROFILE_ELEMENT_VIEW_HEIGHT*(([self.joined_blockViews count]/2+[self.joined_blockViews count]%2-1.5))){
            if ([self.joined_blockViews count]<7) {
                return;
            }
            //add the content add refresh indicator
            for(UIView *subview in [self.joined_refreshViewdown subviews]) {
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
            self.joined_refreshViewdown= [[UIView alloc] initWithFrame:CGRectMake(0,PROFILE_ELEMENT_VIEW_HEIGHT*([self.joined_blockViews count]/2+[self.joined_blockViews count]%2),EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT/2)];
            [self.joined_refreshViewdown removeFromSuperview];
            [self.joined_refreshViewdown addSubview:underloading];
            [self.joined_refreshViewdown addSubview:loading];
            [self.joinedScrollView addSubview:self.joined_refreshViewdown];
            self.joinedScrollView.contentSize =CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.joined_blockViews count]/2+[self.joined_blockViews count]%2+0.5)*PROFILE_ELEMENT_VIEW_HEIGHT);
            
            
            //set the freshConnectionType To @"Add"
            self.joined_freshConnectionType=@"Add";
            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                NSString *request_string=[NSString stringWithFormat:@"%@/invitations?page=%d&auth_token=%@",CONNECT_DOMIAN_NAME,self.joined_refresh_page_num,[defaults objectForKey:@"login_auth_token"]];
                NSLog(@"%@",request_string);
                NSURL *url=[NSURL URLWithString:request_string];
                ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
                
                [request setRequestMethod:@"GET"];
                [request startSynchronous];
                
                int code=[request responseStatusCode];
                NSLog(@"code:%d",code);
                ///////////////
                dispatch_async( dispatch_get_main_queue(),^{
                    //set the freshConnectionType to "not"
                    //self.freshConnectionType=@"not";
                    NSError *error;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    //after receive the new page, add the next request page number
                    self.joined_refresh_page_num++;
                    if ([json count]==0) {
                        //if the new received data is null, we know that this page is empty, no more data, so no need to add the next request page data.
                        self.joined_refresh_page_num--;
                        [self.joinedScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.joined_blockViews count]/2 + [self.joined_blockViews count]%2)*PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT)];
                    }
                    
                    //set the freshConnectionType to "not"
                    self.joined_freshConnectionType=@"not";
                    for (NSDictionary *event in json) {
                        //after receive the new page, add the next request page number
                        NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                        NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                        NSString *title=[event objectForKey:@"title"];
                        NSString *event_photo_url=[event objectForKey:@"photo_url"];
                        NSString *locationName=[event objectForKey:@"location"];
                        //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                        NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
                        NSString *longitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"longitude"]];
                        NSString *latitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"latitude"]];
                        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
                        
                        CLLocation *current_location = self.current_location_manager.location;
                        CLLocationDistance distance;
                        if ([latitude isEqualToString:@"<null>"] || [longitude isEqualToString:@"<null>"]) {
                            distance = -1;
                        } else {
                            distance = [current_location distanceFromLocation:location]*0.000621371;
                        }            if (!title) {
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
                                            [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                            ;
                                            //refresh the whole view
                                            NSLog(@"profile0:%@",event_id);
                                            [self joined_addMoreDataToTheMainScrollViewSUbviews];
                                        });
                                    }
                                }
                                else {
                                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                                    //NSLog(@"downloaded %@",url);
                                    if(imageData){
                                        dispatch_async( dispatch_get_main_queue(),^{
                                            [Cache addDataToCache:url withData:imageData];
                                            [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                            //refresh the whole view
                                            NSLog(@"profile0:%@",event_id);
                                            [self joined_addMoreDataToTheMainScrollViewSUbviews];
                                        });
                                    }
                                }
                            });
                        }
                        else {
                            dispatch_async( dispatch_get_main_queue(),^{
                                [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                //refresh the whole view
                                NSLog(@"profile1:%@",shared_event_id);
                                [self joined_addMoreDataToTheMainScrollViewSUbviews];
                            });
                        }
                        [self.joined_refreshViewdown removeFromSuperview];
                    }
                    
                    [self.joined_refreshViewdown removeFromSuperview];
                });
                
                ////////////////
                
                
            });
        }
    }
    
    

}

#pragma mark - refresh button action part
- (IBAction)refreshButtonClicked:(id)sender {
    //disable the button before the request is finshed
    [self.refreshButton setEnabled:NO];
    
    [self RefreshAction];
}

-(void)RefreshAction{
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
    else{
        //query the user profile information
        //add login auth_token
        defaults = [NSUserDefaults standardUserDefaults];
        ///////////////////////////////////////////////////////////////////////////
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/profile?auth_token=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.via]];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                    
                        self.lastReceivedJson_profile=json;
                        //only update the content when there is a content different
                        [self.creatorNameLabel setText:[json objectForKey:@"name"]];
                        [self.bookmarkNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_bookmarks"]]];
                        [self.followerNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followers"]]];
                        [self.followingNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followings"]]];
                        NSURL *url=[NSURL URLWithString:[json objectForKey:@"profile_url"]];
                        NSLog(@"%@",url);
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
                
            });
            
        });
        //---------->mainScrollView
        //quest the most recent 10 events
        //the next page that need to refresh is 2
        self.freshConnectionType=@"New";
        self.isViewAppearConnection=YES;
        
        //main scroll view refresh
        self.freshConnectionType=@"New";
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]];
            NSLog(@"%@",request_string);
            NSURL *url=[NSURL URLWithString:request_string];
            ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
            
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            //enable the button after the request is finshed
            [self.refreshButton setEnabled:YES];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            ///////////////
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //set the freshConnectionType to "not"
                    NSError *error;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    [self.mySegmentControl setTitle:[NSString stringWithFormat:@"%d COLLECTED",[json count]] forSegmentAtIndex:0];
                    NSLog(@"%@",[NSString stringWithFormat:@"%@",json]);
                    NSLog(@"%@",[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]);
                    //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                    //[[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]]
                    
                        for (UIView *view in [self.mainScrollView subviews]) {
                            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                        }
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
                            //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                                //for the image is null situation
                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
                                ;
                                [self refreshAllTheMainScrollViewSUbviews];
                            }
                            else{
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
                                                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                        [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                                        //refresh the whole view
                                        NSLog(@"profile1:%@",shared_event_id);
                                        [self refreshAllTheMainScrollViewSUbviews];
                                    });
                                }
                                [self.refreshViewdown removeFromSuperview];
                            }
                            
                            
                        }
                        self.freshConnectionType=@"not";
                    
                }
                else{
                    //connect error
                }
                
            });
        });
        //refresh part
        self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
        [self.mainScrollView addSubview:self.refreshView];
        
        //---------->joined ScrollView
        //quest the most recent 10 events
        //self.joined_refresh_page_num=2; //the next page that need to refresh is 2
        self.joined_freshConnectionType=@"New";
        self.joined_isViewAppearConnection=YES;
        
        //main scroll view refresh
        self.joined_freshConnectionType=@"New";
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *request_string=[NSString stringWithFormat:@"%@/invitations?auth_token=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"]];
            NSLog(@"%@",request_string);
            NSURL *url=[NSURL URLWithString:request_string];
            ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
            
            [request setRequestMethod:@"GET"];
            [request startSynchronous];
            //enable the button after the request is finshed
            [self.refreshButton setEnabled:YES];
            int code=[request responseStatusCode];
            NSLog(@"code:%d",code);
            ///////////////
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //set the freshConnectionType to "not"
                    NSError *error;
                    NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    [self.mySegmentControl setTitle:[NSString stringWithFormat:@"%d INVITED",[json count]] forSegmentAtIndex:1];
                    //after reget the newest 10 popular event, the next page that need to be retrait is page 2
                    //[[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark_joined]]

                    
                        for (UIView *view in [self.joinedScrollView subviews]) {
                            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                        }
                        self.joined_refresh_page_num=2;
                        self.lastReceivedJson_bookmark_joined=json;
                        //clean the page
                        for (UIView* subView in self.joinedScrollView.subviews) {
                            [subView removeFromSuperview];
                        }
                        [self.joined_blockViews removeAllObjects];
                        //set the freshConnectionType to "not"
                        self.joined_freshConnectionType=@"not";
                        for (NSDictionary *event in json) {
                            //after receive the new page, add the next request page number
                            NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
                            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
                            NSString *title=[event objectForKey:@"title"];
                            NSString *event_photo_url=[event objectForKey:@"photo_url"];
                            NSString *locationName=[event objectForKey:@"location"];
                            //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                                //for the image is null situation
                                [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                ;
                                [self joined_refreshAllTheMainScrollViewSUbviews];
                            }
                            else{
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
                                                    [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                                    ;
                                                    //refresh the whole view
                                                    NSLog(@"profile0:%@",event_id);
                                                    [self joined_refreshAllTheMainScrollViewSUbviews];
                                                });
                                            }
                                        }
                                        else {
                                            //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                                            //NSLog(@"downloaded %@",url);
                                            if(imageData){
                                                dispatch_async( dispatch_get_main_queue(),^{
                                                    [Cache addDataToCache:url withData:imageData];
                                                    [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                                    //refresh the whole view
                                                    NSLog(@"profile0:%@",event_id);
                                                    [self joined_refreshAllTheMainScrollViewSUbviews];
                                                });
                                            }
                                        }
                                    });
                                }
                                else {
                                    dispatch_async( dispatch_get_main_queue(),^{
                                        [self.joined_blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.joined_blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.joined_blockViews count]];
                                        //refresh the whole view
                                        NSLog(@"profile1:%@",shared_event_id);
                                        [self joined_refreshAllTheMainScrollViewSUbviews];
                                    });
                                }
                                [self.joined_refreshViewdown removeFromSuperview];
                            }
                            
                            
                        }
                        self.joined_freshConnectionType=@"not";
                    
                }
                else{
                    //connect error
                }
                
            });
            
            ////////////////
            
            
        });
        
        //refresh part
        self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
        [self.mainScrollView addSubview:self.refreshView];
        
        //refresh part
        self.joined_refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
        [self.joinedScrollView addSubview:self.joined_refreshView];
    }
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ViewEventDetail"]) {
        //if it's the segue to the view detail part, do this:
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        NSLog(@"%@ %@",self.tapped_event_id,self.tapped_shared_event_id);
        [detailVC preSetTheEventID:self.tapped_event_id andSetTheSharedEventID:self.tapped_shared_event_id andSetIsOwner:self.tapped_event_isOwner];
        [detailVC preSetServerLogViaParameter:VIA_MY_PROFILE];
        
        
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        //if it's the segue to the view detail part, do this:
//        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
//        [detailVC preSetTheEventID:self.tapped_event_id andSetTheSharedEventID:self.tapped_shared_event_id andSetIsOwner:[[NSString stringWithFormat:@"%@",[defaults objectForKey:@"user_id"]] isEqualToString:self.tapped_creator_id]];
    }
}

#pragma mark - get more data and show the more event
-(void)refreshAllTheMainScrollViewSUbviews{
    [self.refreshView removeFromSuperview];
    ProfileEventElement *Element=(ProfileEventElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EVENT_ELEMENT_CONTENT_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];
    if ([self.blockViews count]<5) {
        [self.mainScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, 2.2*PROFILE_ELEMENT_VIEW_HEIGHT)];
    }
    else{
        [self.mainScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, ([self.blockViews count]/2 + [self.blockViews count]%2)*PROFILE_ELEMENT_VIEW_HEIGHT+5)];
    }
    
}
-(void)joined_refreshAllTheMainScrollViewSUbviews{
    [self.joined_refreshView removeFromSuperview];
    ProfileEventElement *Element=(ProfileEventElement *)[self.joined_blockViews objectAtIndex:([self.joined_blockViews count]-1)];
    [self.joinedScrollView addSubview:Element.blockView];
    self.joined_refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EVENT_ELEMENT_CONTENT_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT)];
    [self.joinedScrollView addSubview:self.joined_refreshView];
    if ([self.joined_blockViews count]<5) {
        [self.joinedScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, 2.2*PROFILE_ELEMENT_VIEW_HEIGHT)];
    }
    else{
        [self.joinedScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, ([self.joined_blockViews count]/2 + [self.joined_blockViews count]%2)*PROFILE_ELEMENT_VIEW_HEIGHT+5)];
    }
    
}

//use to add more (than 10) from down side
-(void)addMoreDataToTheMainScrollViewSUbviews{
    ProfileEventElement *Element=(ProfileEventElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    
    if ([self.blockViews count]<5) {
        [self.mainScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, 2.2*PROFILE_ELEMENT_VIEW_HEIGHT)];
    }
    else{
        [self.mainScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, ([self.blockViews count]/2 + [self.blockViews count]%2)*PROFILE_ELEMENT_VIEW_HEIGHT+5)];
    }
}

-(void)joined_addMoreDataToTheMainScrollViewSUbviews{
    ProfileEventElement *Element=(ProfileEventElement *)[self.joined_blockViews objectAtIndex:([self.joined_blockViews count]-1)];
    [self.joinedScrollView addSubview:Element.blockView];
    
    if ([self.joined_blockViews count]<5) {
        [self.joinedScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, 2.2*PROFILE_ELEMENT_VIEW_HEIGHT)];
    }
    else{
        [self.joinedScrollView setContentSize:CGSizeMake(PROFILE_PAGEVC_VIEW_WIDTH, ([self.joined_blockViews count]/2 + [self.joined_blockViews count]%2)*PROFILE_ELEMENT_VIEW_HEIGHT+5)];
    }
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
        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
        if ([[NSString stringWithFormat:@"%@",json] isEqualToString:[NSString stringWithFormat:@"%@",self.lastReceivedJson_bookmark]]) {
            //do nothing here, if there is no diff
            self.refresh_page_num=2;
            self.freshConnectionType=@"not";
            //[self.refreshView removeFromSuperview];
            if (!self.isViewAppearConnection) {
                for (UIView *view in [self.mainScrollView subviews]) {
                    [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
                }
            }
        }
        else{
            for (UIView *view in [self.mainScrollView subviews]) {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y-EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
            }
            
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
                //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
                NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
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
                    //for the image is null situation
                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:nil tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
                    ;
                    [self refreshAllTheMainScrollViewSUbviews];
               }
                else{
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
                                        [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                        [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
                            //refresh the whole view
                            NSLog(@"profile1:%@",shared_event_id);
                            [self refreshAllTheMainScrollViewSUbviews];
                        });
                    }
                    [self.refreshViewdown removeFromSuperview];
                }
                
                
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
            //NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
            NSString *longitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"longitude"]];
            NSString *latitude = [NSString stringWithFormat:@"%@",[event objectForKey:@"latitude"]];
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
            
            CLLocation *current_location = self.current_location_manager.location;
            CLLocationDistance distance;
            if ([latitude isEqualToString:@"<null>"] || [longitude isEqualToString:@"<null>"]) {
                distance = -1;
            } else {
                distance = [current_location distanceFromLocation:location]*0.000621371;
            }            if (!title) {
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
                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:(float)distance withCategory:nil] atIndex:[self.blockViews count]];
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
                                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
                    [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count] eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withDistance:distance withCategory:nil] atIndex:[self.blockViews count]];
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
    if ([self.mySegmentControl selectedSegmentIndex]==0) {
        CGPoint touchPoint=[tapGR locationInView:[self mainScrollView]];
        //get the index of the touched block view
        int index_y=touchPoint.y/PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT;
        int index_x=touchPoint.x/160;
        ProfileEventElement* tapped_element=[self.blockViews objectAtIndex:index_y*2+index_x];
        self.tapped_event_id=tapped_element.event_id;
        self.tapped_shared_event_id=tapped_element.shared_event_id;
        
        NSLog(@"%@  %@",self.tapped_event_id,self.tapped_shared_event_id);
        self.tapped_event_isOwner=YES;
        //do some pre-segue stuff with event_id and shared_id
        [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
    }
    else if ([self.mySegmentControl selectedSegmentIndex]==1){
        CGPoint touchPoint=[tapGR locationInView:[self joinedScrollView]];
        //get the index of the touched block view
        int index_y=touchPoint.y/PROFILE_PAGEVC_BlOCK_VIEW_HEIGHT;
        int index_x=touchPoint.x/160;
        ProfileEventElement* tapped_element=[self.joined_blockViews objectAtIndex:index_y*2+index_x];
        self.tapped_event_id=tapped_element.event_id;
        self.tapped_shared_event_id=tapped_element.shared_event_id;
        self.tapped_event_isOwner=NO;
        //do some pre-segue stuff with event_id and shared_id
        [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
    }
        
    
 
}


@end
