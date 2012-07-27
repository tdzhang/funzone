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
@property (nonatomic,retain) DetailViewController *detailViewController;
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
@end

@implementation ExploreViewController
@synthesize refreshView=_refreshView;
@synthesize refreshViewdown=_refreshViewdown;
@synthesize detailViewController = _detailViewController;
@synthesize blockViews = _blockViews;
@synthesize currentY = _currentY;
@synthesize mainScrollView = _mainScrollView;
@synthesize data=_data;
@synthesize freshConnectionType=_freshConnectionType;
@synthesize refresh_page_num=_refresh_page_num;
@synthesize tapped_event_id=_tapped_event_id;
@synthesize tapped_shared_event_id=_tapped_shared_event_id;
@synthesize garbageCollection=_garbageCollection;
@synthesize tapped_creator_id=_tapped_creator_id;
@synthesize antiTouchMaskView=_antiTouchMaskView;




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

- (DetailViewController *)detailViewController {
    if (_detailViewController == nil) {
        _detailViewController = [[DetailViewController alloc] init];
    }
    return _detailViewController;
}


#pragma mark - View Life circle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //refresh part
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EXPLORE_PART_SCROLLVIEW_REFRESH_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Navigation Bar Style
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Back" style:UIBarButtonItemStylePlain
                                   target:nil action:nil];
    backButton.tintColor = [UIColor colorWithRed:0.84111 green:0.5373 blue:0.1 alpha:1];
    [self.navigationItem setBackBarButtonItem:backButton];
    
    
    //init the detail page for later segue
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	_detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailPageNavigationController"];
    
    //quest the most recent 10 featured events
    self.refresh_page_num=2; //the next page that need to refresh is 2
    self.freshConnectionType=@"New";
    NSString *request_string=[NSString stringWithFormat:@"%@/explore",CONNECT_DOMIAN_NAME];
    NSLog(@"request %@",request_string);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    
    //set mainScrollView layout styles
    self.mainScrollView.contentSize = CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, 0);
    [self.mainScrollView setContentOffset:CGPointMake(EXPLORE_PART_SCROLLVIEW_CONTENT_OFFSET_X, EXPLORE_PART_SCROLLVIEW_CONTENT_OFFSET_Y)];
}


- (void)viewDidUnload
{
    [self setMainScrollView:nil];
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
    if (scrollView.contentOffset.y<-EVENT_ELEMENT_CONTENT_HEIGHT/3) {
        //remove the main views
        self.garbageCollection=[NSMutableArray array];
        for (UIView *view in [self.mainScrollView subviews]) {
            [view setFrame:CGRectMake(0, view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2, view.frame.size.width, view.frame.size.height)];
            //NSLog(@"put %f",view.frame.origin.y+EVENT_ELEMENT_CONTENT_HEIGHT/2);
            [self.garbageCollection addObject:view];
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
        loading.backgroundColor =[UIColor colorWithWhite:1.0f alpha:0.3f];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(120,10,80,40)];
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
        NSString *request_string=[NSString stringWithFormat:@"%@/explore",CONNECT_DOMIAN_NAME];
        NSLog(@"ExploreViewController request1: %@",request_string);
        NSURLRequest *request = [NSURLRequest  requestWithURL:[NSURL URLWithString:request_string] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.0];
        //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.freshConnectionType=@"New";
        [connection start];
    }
    //add more of the featured event
    else if(scrollView.contentOffset.y>EVENT_ELEMENT_CONTENT_HEIGHT*(([self.blockViews count]-2.5))){
        //add the content add refresh indicator
        for(UIView *subview in [self.refreshViewdown subviews]) {
            [subview removeFromSuperview];
        }
        UIView* underloading=[[UIView alloc] initWithFrame:CGRectMake(10,0,EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT)];
        [underloading setBackgroundColor:[UIColor whiteColor]];
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT)];
        loading.layer.cornerRadius =15;
        loading.opaque = NO;
        loading.backgroundColor =[UIColor clearColor];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(120,10,80,40)];
        loadLabel.text =@"Adding More";loadLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment =UITextAlignmentCenter;
        loadLabel.textColor =[UIColor colorWithWhite:0.4f alpha:1.0f];
        loadLabel.backgroundColor =[UIColor clearColor];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinning.frame =CGRectMake(120,20,80,80);
        [spinning startAnimating];[loading addSubview:spinning];
        self.refreshViewdown= [[UIView alloc] initWithFrame:CGRectMake(0,EVENT_ELEMENT_CONTENT_HEIGHT*([self.blockViews count]),EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH,EVENT_ELEMENT_CONTENT_HEIGHT/2)];
        [self.refreshViewdown removeFromSuperview];
        [self.refreshViewdown addSubview:underloading];
        [self.refreshViewdown addSubview:loading];
        [self.mainScrollView addSubview:self.refreshViewdown];
        self.mainScrollView.contentSize =CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, ([self.blockViews count]+0.5)*EVENT_ELEMENT_CONTENT_HEIGHT);
        
        //NSLog(@"add more");
        NSString *request_string=[NSString stringWithFormat:@"%@/explore?page=%d",CONNECT_DOMIAN_NAME,self.refresh_page_num];
        NSLog(@"ExploreViewController request2:%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        //set the freshConnectionType To @"Add"
        self.freshConnectionType=@"Add";
        [connection start];         
    }
}

#pragma mark - already load the new data, refresh the whole view/ or add more on the down side
-(void)refreshAllTheMainScrollViewSUbviews{
    [self.refreshView removeFromSuperview];
    ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -EVENT_ELEMENT_CONTENT_HEIGHT, EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, EVENT_ELEMENT_CONTENT_HEIGHT)];
    [self.mainScrollView addSubview:self.refreshView];
    [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*EVENT_ELEMENT_CONTENT_HEIGHT)];
}
//use to add more (than 10) from down side
-(void)addMoreDataToTheMainScrollViewSUbviews{
    ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
    [self.mainScrollView addSubview:Element.blockView];
    [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*EVENT_ELEMENT_CONTENT_HEIGHT)];
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
            NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *locationName=[event objectForKey:@"location"];
            NSString *creator_name=[event objectForKey:@"creator_name"];
            NSString *creator_pic=[event objectForKey:@"creator_pic"];
            NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
            
            
            if (!title) {continue;}
            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
            NSURL *url=[NSURL URLWithString:photo];
            [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*EVENT_ELEMENT_CONTENT_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id] atIndex:[self.blockViews count]];
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
            [self.mainScrollView setContentSize:CGSizeMake(EXPLORE_PART_SCROLLVIEW_CONTENT_WIDTH, [self.blockViews count]*EVENT_ELEMENT_CONTENT_HEIGHT)];
        }
        for (NSDictionary* event in json) {
            NSString *title=[event objectForKey:@"title"];
            //NSString *description=[event objectForKey:@"description"];
            NSString *photo=[event objectForKey:@"photo_url"];
            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *locationName=[event objectForKey:@"location"];
            NSString *creator_name=[event objectForKey:@"creator_name"];
            NSString *creator_pic=[event objectForKey:@"creator_pic"];
            NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
            
            if (!title) {continue;}
            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {continue;}
            
            NSURL *url=[NSURL URLWithString:photo];
            [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*EVENT_ELEMENT_CONTENT_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id  withLocationName:locationName  withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id] atIndex:[self.blockViews count]];
            
            //refresh the whole view
            [self addMoreDataToTheMainScrollViewSUbviews];

        }
        
        [self.refreshViewdown removeFromSuperview];
    }
    
}
#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ViewEventDetail"]) {
        //if it's the segue to the view detail part, do this:
        DetailViewController *detailVC = (DetailViewController *)segue.destinationViewController;
        [detailVC preSetTheEventID:self.tapped_event_id andSetTheSharedEventID:self.tapped_shared_event_id];
    }
    else if([segue.identifier isEqualToString:@"ViewOthersProfile"]){
        OtherProfilePageViewController* OPPVC=segue.destinationViewController;
        OPPVC.creator_id=self.tapped_creator_id;
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
    float tempTouchPointX=touchPoint.x;
    if ([self.freshConnectionType isEqualToString:@"New"]) {
        tempTouchPointY-=EVENT_ELEMENT_CONTENT_HEIGHT/2;
    }
    //get the index of the touched block view
    int index=tempTouchPointY/EVENT_ELEMENT_CONTENT_HEIGHT;
    //NSLog(@"%d",index);
    //NSLog(@"click_position:%f,%f",touchPoint.x,touchPoint.y-index*BlOCK_VIEW_HEIGHT);
    float x=tempTouchPointX;
    float y=tempTouchPointY-index*EVENT_ELEMENT_CONTENT_HEIGHT;
    ExploreBlockElement* tapped_element=[self.blockViews objectAtIndex:index];
    self.tapped_event_id=tapped_element.event_id;
    self.tapped_shared_event_id=tapped_element.shared_event_id;
    self.tapped_creator_id=tapped_element.creator_id;
    if((x>=10&&x<=120)&&(y>=125&&y<=157)){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *myid=[defaults objectForKey:@"user_id"];
        if ([myid isEqualToString:tapped_element.creator_id]) {
            [self performSegueWithIdentifier:@"ViewProfile" sender:self];
        }
        else {
            [self performSegueWithIdentifier:@"ViewOthersProfile" sender:self];
        }
    }
    else {
        [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
    }
    
    //do some pre-segue stuff with event_id and shared_id
    /*
     self.detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:self.detailViewController animated:YES completion:^{}];
     */
}

@end
