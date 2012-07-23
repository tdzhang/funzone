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
#define BlOCK_VIEW_HEIGHT 60

@interface OtherProfilePageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) DetailViewController *detailViewController;
@property (weak, nonatomic) IBOutlet UIImageView *creatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *creatorNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bookmarkNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerNumLabel;
@property (nonatomic,retain) NSMutableArray *blockViews;
@property (nonatomic,retain) UIView *refreshViewdown;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *freshConnectionType;
@property (nonatomic) int refresh_page_num;
@property (nonatomic,strong) NSString *tapped_event_id;
@property (nonatomic,strong) NSString *tapped_shared_event_id;
@property (nonatomic,strong) NSMutableArray *garbageCollection;

@end

@implementation OtherProfilePageViewController
@synthesize mainScrollView;
@synthesize refreshViewdown=_refreshViewdown;
@synthesize detailViewController = _detailViewController;
@synthesize creatorImageView = _creatorImageView;
@synthesize creatorNameLabel = _creatorNameLabel;
@synthesize bookmarkNumLabel = _bookmarkNumLabel;
@synthesize followingNumLabel = _followingNumLabel;
@synthesize followerNumLabel = _followerNumLabel;
@synthesize blockViews = _blockViews;
@synthesize data=_data;
@synthesize freshConnectionType=_freshConnectionType;
@synthesize refresh_page_num=_refresh_page_num;
@synthesize tapped_event_id=_tapped_event_id;
@synthesize tapped_shared_event_id=_tapped_shared_event_id;
@synthesize garbageCollection=_garbageCollection;
@synthesize creator_id=_creator_id;

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

- (DetailViewController *)detailViewController {
    if (_detailViewController == nil) {
        _detailViewController = [[DetailViewController alloc] init];
    }
    return _detailViewController;
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
    
    //init the detail page for later segue
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	_detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailPageNavigationController"];
    
    //query the user profile information
    
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/profile",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [block_request responseString];
        NSLog(@"%@",responseString);
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[block_request responseData] options:kNilOptions error:&error];
        [self.creatorNameLabel setText:[json objectForKey:@"name"]];
        [self.bookmarkNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_bookmarks"]]];
        [self.followerNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followers"]]];
        [self.followingNumLabel setText:[NSString stringWithFormat:@"%@",[json objectForKey:@"num_followings"]]];
        
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
                    UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
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
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Get User Profile Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        notsuccess.delegate=self;
        [notsuccess show];
    }];
    //add login auth_token
    defaults = [NSUserDefaults standardUserDefaults];
    [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
    [request setPostValue:self.creator_id forKey:@"user_id"];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
    
    //quest the most recent 10 events
    self.refresh_page_num=2; //the next page that need to refresh is 2
    self.freshConnectionType=@"new";
    NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?auth_token=%@&user_id=%@",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.creator_id];
    NSLog(@"%@",request_string);
    NSURLRequest* URLrequest = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:URLrequest delegate:self];
    [connection start];
    self.mainScrollView.contentSize =CGSizeMake(VIEW_WIDTH, 5*BlOCK_VIEW_HEIGHT);
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //........towards left Gesture recogniser for swiping.....// used to change view
    /*
     UISwipeGestureRecognizer* leftRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
     leftRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;[leftRecognizer setNumberOfTouchesRequired:1];
     [self.view addGestureRecognizer:leftRecognizer]; 
     */
    
    //Navigation Bar Style
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStylePlain
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.84111 green:0.5373 blue:0.1 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [self setCreatorImageView:nil];
    [self setCreatorNameLabel:nil];
    [self setBookmarkNumLabel:nil];
    [self setFollowingNumLabel:nil];
    [self setFollowerNumLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - button action
- (IBAction)startFollowAction:(id)sender {
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/follow",CONNECT_DOMIAN_NAME]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    __block ASIFormDataRequest *block_request=request;
    [request setCompletionBlock:^{
        // Use when fetching text data
        //NSString *responseString = [block_request responseString];
        //NSLog(@"%@",responseString);
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[block_request responseData] options:kNilOptions error:&error];
        if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Follow Success." message: [NSString stringWithFormat:@"You have successfully followed the person you choose."] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
            success.delegate=self;
            [success show];        
        }
        else {
            UIAlertView *unsuccess = [[UIAlertView alloc] initWithTitle:@"Follow not Success." message: [NSString stringWithFormat:@"Some thing went wrong."] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
            unsuccess.delegate=self;
            [unsuccess show];
        }
        
       
    
    }];
    [request setFailedBlock:^{
        NSError *error = [block_request error];
        NSLog(@"%@",error.description);
        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:@"Get User Profile Error!" message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"Ok, Got it." otherButtonTitles:nil];
        notsuccess.delegate=self;
        [notsuccess show];
    }];
    //add login auth_token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
    [request setPostValue:self.creator_id forKey:@"followee_id"];
    [request setRequestMethod:@"GET"];
    [request startAsynchronous];
}


#pragma mark - implement the UIScrollViewDelegate
//when the scrolling over 最上方，need refresh process
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"end here x=%f, y=%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    
    //if there already has a connection, donot create a new one, just return
    if (![self.freshConnectionType isEqualToString:@"not"]) {
        return;
    }
    
    //add more
    if(scrollView.contentOffset.y>BlOCK_VIEW_HEIGHT*(([self.blockViews count]-2.5))){
        
        //add the content add refresh indicator
        for(UIView *subview in [self.refreshViewdown subviews]) {
            [subview removeFromSuperview];
        }
        UIView* underloading=[[UIView alloc] initWithFrame:CGRectMake(10,0,VIEW_WIDTH,BlOCK_VIEW_HEIGHT)];
        [underloading setBackgroundColor:[UIColor whiteColor]];
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,VIEW_WIDTH,BlOCK_VIEW_HEIGHT)];
        loading.layer.cornerRadius =15;
        loading.opaque = NO;
        loading.backgroundColor =[UIColor colorWithWhite:0.0f alpha:0.3f];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(120,25,80,40)];
        loadLabel.text =@"Adding More";loadLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment =UITextAlignmentCenter;
        loadLabel.textColor =[UIColor colorWithWhite:1.0f alpha:1.0f];
        loadLabel.backgroundColor =[UIColor clearColor];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame =CGRectMake(120,80,80,80);
        [spinning startAnimating];[loading addSubview:spinning];
        self.refreshViewdown= [[UIView alloc] initWithFrame:CGRectMake(0,BlOCK_VIEW_HEIGHT*([self.blockViews count]),VIEW_WIDTH,BlOCK_VIEW_HEIGHT)];
        [self.refreshViewdown removeFromSuperview];
        [self.refreshViewdown addSubview:underloading];
        [self.refreshViewdown addSubview:loading];
        [self.mainScrollView addSubview:self.refreshViewdown];
        self.mainScrollView.contentSize =CGSizeMake(VIEW_WIDTH, ([self.blockViews count]+1)*BlOCK_VIEW_HEIGHT);
        
        //NSLog(@"add more");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *request_string=[NSString stringWithFormat:@"%@/bookmarks?page=%d&auth_token=%@",CONNECT_DOMIAN_NAME,self.refresh_page_num,[defaults objectForKey:@"login_auth_token"]];
        NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        //set the freshConnectionType To @"Add"
        self.freshConnectionType=@"Add";
        [connection start];         
    }
}

#pragma mark - get more data and show the more event
//use to add more (than 10) from down side
-(void)addMoreDataToTheMainScrollViewSUbviews{
    ProfileEventElement *Element=(ProfileEventElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    [self.mainScrollView setContentSize:CGSizeMake(VIEW_WIDTH, [self.blockViews count]*BlOCK_VIEW_HEIGHT)];
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
    if ([self.freshConnectionType isEqualToString:@"new"]) {
        //that means all the block view need to be reset
        for (ProfileEventElement* event in self.blockViews) {
            [event.blockView removeFromSuperview];
        }
        [self.blockViews removeAllObjects];
    }
    
    NSError *error;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
    NSLog(@"%@",json);
    self.refresh_page_num++;
    if ([json count]==0) {
        //if the new received data is null, we know that this page is empty, no more data, so no need to add the next request page data.
        self.refresh_page_num--;
        [self.mainScrollView setContentSize:CGSizeMake(VIEW_WIDTH, [self.blockViews count]*BlOCK_VIEW_HEIGHT)];
    }
    for (NSDictionary *event in json) {
        //set the freshConnectionType to "not"
        
        //after receive the new page, add the next request page number
        NSString *event_id= [NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
        NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
        NSString *title=[event objectForKey:@"title"];
        NSString *event_photo_url=[event objectForKey:@"photo_url"];
        NSString *locationName=[event objectForKey:@"location"];
        NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
        
        NSLog(@"event_id=%@",event_id);
        NSLog(@"photo_url=%@",event_photo_url);
        
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
                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName] atIndex:[self.blockViews count]];
                            ;
                            //refresh the whole view
                            NSLog(@"profile0:%d",[self.blockViews count]);
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
                            [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName] atIndex:[self.blockViews count]];
                            //refresh the whole view
                            NSLog(@"profile1:%d",[self.blockViews count]);
                            [self addMoreDataToTheMainScrollViewSUbviews];
                        });
                    }
                }
            });
        }
        else {
            dispatch_async( dispatch_get_main_queue(),^{
                [self.blockViews insertObject:[ProfileEventElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT eventImageURL:event_photo_url tabActionTarget:self withTitle:title withFavorLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName] atIndex:[self.blockViews count]];
                //refresh the whole view
                NSLog(@"profile2:%d",[self.blockViews count]);
                [self addMoreDataToTheMainScrollViewSUbviews];
            });
        }
        [self.refreshViewdown removeFromSuperview];
    }
}

#pragma mark - Gesture handler

//handle when user tap a certain block view
-(void)tapBlock:(UITapGestureRecognizer *)tapGR {
    
    CGPoint touchPoint=[tapGR locationInView:[self mainScrollView]];
    //get the index of the touched block view
    int index=touchPoint.y/BlOCK_VIEW_HEIGHT;
    NSLog(@"%d",index);
    /*
     ExploreBlockElement* tapped_element=[self.blockViews objectAtIndex:index];
     self.tapped_event_id=tapped_element.event_id;
     self.tapped_shared_event_id=tapped_element.shared_event_id;
     //do some pre-segue stuff with event_id and shared_id
     [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
     
     
     self.detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:self.detailViewController animated:YES completion:^{}];
     */
}

@end
