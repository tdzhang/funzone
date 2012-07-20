//
//  ExploreViewController.m
//  Fun
//
//  Created by He Yang on 6/29/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
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
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSString *freshConnectionType;
@property (nonatomic) int refresh_page_num;
@property (nonatomic,strong) NSString *tapped_event_id;
@property (nonatomic,strong) NSString *tapped_shared_event_id;
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

#define VIEW_WIDTH 300
#define VIEW_HEIGHT 130
#define BlOCK_VIEW_HEIGHT 140


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
    

    //........towards left Gesture recogniser for swiping.....// used to change view
    UISwipeGestureRecognizer* leftRecognizer =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeHandle:)];
    leftRecognizer.direction =UISwipeGestureRecognizerDirectionLeft;[leftRecognizer setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftRecognizer]; 
    
    //refresh part
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -BlOCK_VIEW_HEIGHT, VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
    [self.refreshView setImage:[UIImage imageNamed:@"FreshBigArrow.png"]];
    [self.mainScrollView addSubview:self.refreshView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	_detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailPageNavigationController"];
    
    
    
    //quest the most recent 10 featured events
    self.refresh_page_num=2; //the next page that need to refresh is 2
    self.freshConnectionType=@"New";
    NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/tops"];
    NSLog(@"%@",request_string);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
    NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];
    self.mainScrollView.contentSize =CGSizeMake(VIEW_WIDTH, 5*BlOCK_VIEW_HEIGHT);
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
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
    if (scrollView.contentOffset.y<-BlOCK_VIEW_HEIGHT/3) {
        //remove the main views
        for (UIView *view in [self.mainScrollView subviews]) {
            [view setFrame:CGRectMake(10, view.frame.origin.y+BlOCK_VIEW_HEIGHT, view.frame.size.width, view.frame.size.height)];
            NSLog(@"put %f",view.frame.origin.y+BlOCK_VIEW_HEIGHT);
        }
        [self.blockViews removeAllObjects];
        
        //set the refresh view ahead
        NSLog(@"get most 10 popular pages called");
        [self.refreshView setFrame:CGRectMake(10, 0, VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
        for(UIView *subview in [self.refreshView subviews]) {
            [subview removeFromSuperview];
        }
        
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(0,0,VIEW_WIDTH,BlOCK_VIEW_HEIGHT)];
        loading.layer.cornerRadius =15;
        loading.opaque = NO;
        loading.backgroundColor =[UIColor colorWithWhite:0.0f alpha:0.3f];
        UILabel*loadLabel =[[UILabel alloc] initWithFrame:CGRectMake(120,25,80,40)];
        loadLabel.text =@"Loading";loadLabel.font =[UIFont boldSystemFontOfSize:18.0f];
        loadLabel.textAlignment =UITextAlignmentCenter;
        loadLabel.textColor =[UIColor colorWithWhite:1.0f alpha:1.0f];
        loadLabel.backgroundColor =[UIColor clearColor];
        [loading addSubview:loadLabel];
        UIActivityIndicatorView*spinning =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame =CGRectMake(120,80,80,80);
        [spinning startAnimating];[loading addSubview:spinning];
        [self.refreshView addSubview:loading];
        
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        //and then do the refresh process
        NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/tops"];
        NSLog(@"%@",request_string);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.freshConnectionType=@"New";
        [connection start];
    }
    //add more
    else if(scrollView.contentOffset.y>BlOCK_VIEW_HEIGHT*(([self.blockViews count]-2.5))){
        //add the content add refresh indicator
        for(UIView *subview in [self.refreshViewdown subviews]) {
            [subview removeFromSuperview];
        }
        UIView* underloading=[[UIView alloc] initWithFrame:CGRectMake(10,0,VIEW_WIDTH,BlOCK_VIEW_HEIGHT)];
        [underloading setBackgroundColor:[UIColor whiteColor]];
        UIView*loading =[[UIView alloc] initWithFrame:CGRectMake(10,0,VIEW_WIDTH,BlOCK_VIEW_HEIGHT)];
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
        NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/tops?page=%d",self.refresh_page_num];
        NSLog(@"%@",request_string);
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
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -BlOCK_VIEW_HEIGHT, VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
    [self.refreshView setImage:[UIImage imageNamed:@"FreshBigArrow.png"]];
    [self.mainScrollView addSubview:self.refreshView];
    [self.mainScrollView setContentSize:CGSizeMake(VIEW_WIDTH, [self.blockViews count]*BlOCK_VIEW_HEIGHT)];
}
//use to add more (than 10) from down side
-(void)addMoreDataToTheMainScrollViewSUbviews{
    ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:([self.blockViews count]-1)];
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
    //renew the 10 newest features!!!!
    if ([self.freshConnectionType isEqualToString:@"New"]) {
        //set the freshConnectionType to "not"
        self.freshConnectionType=@"not";  
        NSError *error;
        NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
        //after reget the newest 10 popular event, the next page that need to be retrait is page 2
        self.refresh_page_num=2;
        for (NSDictionary* event in json) {
            NSString *title=[event objectForKey:@"title"];
            NSString *description=[event objectForKey:@"description"];
            NSString *photo=[event objectForKey:@"photo_url"];
            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *locationName=[event objectForKey:@"location"];
            //NSLog(@"%@",title);
            //NSLog(@"%@",photo);
            //NSLog(@"%@",description);
            //NSLog(@"%@",num_pins);
            //NSLog(@"%@",num_views);
            if (!title) {
                continue;
            }
            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {
                continue;
            }
            NSURL *url=[NSURL URLWithString:photo];
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
                                [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName] atIndex:[self.blockViews count]];
                                
                                //refresh the whole view
                                [self refreshAllTheMainScrollViewSUbviews];
                                NSLog(@"123:   %d",[self.blockViews count]);
                            });
                        }
                    }
                    else {
                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                        //NSLog(@"downloaded %@",url);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:url withData:imageData];
                                
                                [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName]  atIndex:[self.blockViews count]];
                                //refresh the whole view
                                [self refreshAllTheMainScrollViewSUbviews];
                                NSLog(@"321:   %d",[self.blockViews count]);
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    
                    [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName] atIndex:[self.blockViews count]];
                    //refresh the whole view
                    [self refreshAllTheMainScrollViewSUbviews];
                });
            }
        
        }
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
            [self.mainScrollView setContentSize:CGSizeMake(VIEW_WIDTH, [self.blockViews count]*BlOCK_VIEW_HEIGHT)];
        }
        for (NSDictionary* event in json) {
            NSString *title=[event objectForKey:@"title"];
            NSString *description=[event objectForKey:@"description"];
            NSString *photo=[event objectForKey:@"photo_url"];
            NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
            NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
            NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
            NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
            NSString *locationName=[event objectForKey:@"location"];
            
            if (!title) {
                continue;
            }
            if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {
                continue;
            }
            NSURL *url=[NSURL URLWithString:photo];
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
                                [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id  withLocationName:locationName] atIndex:[self.blockViews count]];
                                
                                //refresh the whole view
                                [self addMoreDataToTheMainScrollViewSUbviews];
                                NSLog(@"123:   %d",[self.blockViews count]);
                            });
                        }
                    }
                    else {
                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                        //NSLog(@"downloaded %@",url);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:url withData:imageData];
                                
                                [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id  withLocationName:locationName] atIndex:[self.blockViews count]];
                                //refresh the whole view
                                [self addMoreDataToTheMainScrollViewSUbviews];
                                NSLog(@"321:   %d",[self.blockViews count]);
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    
                    [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_views withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName] atIndex:[self.blockViews count]];
                    //refresh the whole view
                    [self addMoreDataToTheMainScrollViewSUbviews];
                });
            }
            
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
}

#pragma mark - Gesture handler

//handle when user tap a certain block view
-(void)tapBlock:(UITapGestureRecognizer *)tapGR {
    
    CGPoint touchPoint=[tapGR locationInView:[self mainScrollView]];
    //get the index of the touched block view
    int index=touchPoint.y/BlOCK_VIEW_HEIGHT;
    NSLog(@"%d",index);
    ExploreBlockElement* tapped_element=[self.blockViews objectAtIndex:index];
    self.tapped_event_id=tapped_element.event_id;
    self.tapped_shared_event_id=tapped_element.shared_event_id;
    //do some pre-segue stuff with event_id and shared_id
    [self performSegueWithIdentifier:@"ViewEventDetail" sender:self];
    
    /*
     self.detailViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
     [self presentViewController:self.detailViewController animated:YES completion:^{}];
     */
}

//the swipe gesture to change the view
-(void)leftSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer{
    //left swipe need to change to the right view
    // Get the views.
    int controllerIndex=1;
    UIView * fromView = self.tabBarController.selectedViewController.view;
    UIView * toView = [[self.tabBarController.viewControllers objectAtIndex:controllerIndex] view];
    // Get the size of the view area.
    CGRect viewSize = fromView.frame;
    // Add the to view to the tab bar view.
    [fromView.superview addSubview:toView];
    // Position it off screen.
    toView.frame = CGRectMake(320, viewSize.origin.y, 320, viewSize.size.height);
    [UIView animateWithDuration:0.4 
                     animations: ^{
                         // Animate the views on and off the screen. This will appear to slide.
                         fromView.frame =CGRectMake(-320, viewSize.origin.y, 320, viewSize.size.height);
                         toView.frame =CGRectMake(0, viewSize.origin.y, 320, viewSize.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             // Remove the old view from the tabbar view.
                             [fromView removeFromSuperview];
                             self.tabBarController.selectedIndex = controllerIndex;                
                         }
                     }];
}

@end
