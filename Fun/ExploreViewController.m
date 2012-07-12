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
@property (nonatomic,strong) NSMutableData *data;
@end

@implementation ExploreViewController
@synthesize refreshView=_refreshView;
@synthesize detailViewController = _detailViewController;
@synthesize blockViews = _blockViews;
@synthesize currentY = _currentY;
@synthesize mainScrollView = _mainScrollView;
@synthesize data=_data;

#define VIEW_WIDTH 320
#define View_HEIGHT 367
#define BlOCK_VIEW_HEIGHT 168 


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
    
    //test/////////////////////////////////////////////////////////////
    //refresh part
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -BlOCK_VIEW_HEIGHT, VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
    [self.refreshView setImage:[UIImage imageNamed:@"FreshBigArrow.png"]];
    [self.mainScrollView addSubview:self.refreshView];
    
    //main part
    for (int i=0; i<5; i++) {
        [self.blockViews addObject:[ExploreBlockElement initialWithPositionY:BlOCK_VIEW_HEIGHT*i backGroundImageUrl:[NSURL URLWithString:@"XXX"] tabActionTarget:self withTitle:@"World Ocean's Day Celebration" withFavorLabelString:@"15" withJoinLabelString:@"25"]];
        
        ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:i];
        [self.mainScrollView addSubview:Element.blockView];
        [Element.blockView removeFromSuperview];
        [self.mainScrollView addSubview:Element.blockView];
    }
    NSLog(@"%d",[self.blockViews count]);
    
    self.mainScrollView.contentSize =CGSizeMake(VIEW_WIDTH, 5*BlOCK_VIEW_HEIGHT);
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil];
	_detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailPageNavigationController"];
    
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
    if (scrollView.contentOffset.y<-BlOCK_VIEW_HEIGHT/2) {
        //set the refresh view ahead
        NSLog(@"called");
        [self.refreshView setFrame:CGRectMake(0, 0, VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
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
        //relocate the main views
        for (int i=0;i<[self.blockViews count];i++) {
            ExploreBlockElement* element = [self.blockViews objectAtIndex:i];
            [element.blockView setFrame:CGRectMake(0, BlOCK_VIEW_HEIGHT*(i+1), VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
        }
        [self.mainScrollView setContentSize:CGSizeMake(VIEW_WIDTH, BlOCK_VIEW_HEIGHT*([self.blockViews count]+1))];
        [self.mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        //and then do the refresh process
        //test json
        NSString *request_string=[NSString stringWithFormat:@"http://www.funnect.me/events/view?event_id=3&shared_event_id=2"];
        NSLog(@"%@",request_string);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:request_string]];
        NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
    }
}

#pragma mark - already load the new data, refresh the whole view
-(void)refreshAllTheMainScrollViewSUbviews{
    
    
    [self.refreshView removeFromSuperview];
    ExploreBlockElement *Element=(ExploreBlockElement *)[self.blockViews objectAtIndex:0];
    [self.mainScrollView addSubview:Element.blockView];
    self.refreshView=[[UIImageView alloc] initWithFrame:CGRectMake(0, -BlOCK_VIEW_HEIGHT, VIEW_WIDTH, BlOCK_VIEW_HEIGHT)];
    [self.refreshView setImage:[UIImage imageNamed:@"FreshBigArrow.png"]];
    [self.mainScrollView addSubview:self.refreshView];
    
    /*for (UIView *view in [self.mainScrollView subviews]) {
        [view removeFromSuperview];
    }*/
    /*
    NSLog(@"%d",[self.blockViews count]);
   
    ExploreBlockElement* blockElement=[self.blockViews objectAtIndex:0];
    [blockElement resetFramWith:0];
    [self.mainScrollView addSubview:blockElement.blockView];
  
    
    self.mainScrollView.contentSize =CGSizeMake(VIEW_WIDTH, BlOCK_VIEW_HEIGHT*([self.blockViews count]));
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    [self.mainScrollView reloadInputViews];
    */
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
    
    //deal with one data first
     NSError *error;
    
     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
     NSString *title=[json objectForKey:@"title"];
     NSString *photo=[json objectForKey:@"photo_url"];
    NSLog(@"%@",title);
    NSLog(@"%@",photo);
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
                    [Cache addDataToCache:url withData:imageData];
                    [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:BlOCK_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:@"15" withJoinLabelString:@"25"] atIndex:0];
                    //refresh the whole view
                    [self refreshAllTheMainScrollViewSUbviews];
                    NSLog(@"%d",[self.blockViews count]);
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    [Cache addDataToCache:url withData:imageData];
                    [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:0 backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:@"15" withJoinLabelString:@"25"] atIndex:0];
                    //refresh the whole view
                    [self refreshAllTheMainScrollViewSUbviews];
                }
            }
        });
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
