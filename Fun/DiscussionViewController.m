//
//  DiscussionViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/17/12.
//
//

#import "DiscussionViewController.h"

@interface DiscussionViewController ()
//outlet
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

//the information of the event and the invited people
@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) NSString *event_title;
@property (nonatomic,strong) NSString *event_time;
@property (nonatomic,strong) NSString *location_name;
@property (nonatomic,strong) NSMutableArray *invitee;
@property (nonatomic) BOOL isEventOwner; //used to indicate whether it is a editable event (based on who is the owner)

@property (nonatomic,strong) NSMutableArray *garbageCollection;

//the structure of the view of the Scroll View
@property(nonatomic,strong) UIView* invitedPeopleSectionView;
@property (nonatomic,strong) UIView *commentSectionView;

@end

@implementation DiscussionViewController
@synthesize mainScrollView = _mainScrollView;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize event_title=_event_title;
@synthesize event_time=_event_time;
@synthesize location_name=_location_name;
@synthesize invitee=_invitee;
@synthesize isEventOwner=_isEventOwner;

@synthesize garbageCollection=_garbageCollection;

@synthesize invitedPeopleSectionView=_invitedPeopleSectionView;
@synthesize commentSectionView=_commentSectionView;

#pragma mark - self defined setter and getter
-(NSMutableArray *)invitee{
    if (!_invitee) {
        _invitee=[NSMutableArray array];
    }
    return _invitee;
}

-(NSMutableArray *)garbageCollection{
    if (!_garbageCollection) {
        _garbageCollection=[NSMutableArray array];
    }
    return _garbageCollection;
}


#pragma mark - View Life Circle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleInvitedPeoplePart];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - self defined method
//pre segue parameters setting
-(void)preSetTheEventID:(NSString *)event_id andSetTheSharedEventID:(NSString *)shared_event_id withEventTitle:(NSString *)event_title withEventTime:(NSString*)event_time withLocationName:(NSString*)location_name withInvitees:(NSMutableArray*)invitee andSetIsOwner:(BOOL)isOwner{
    self.event_id=event_id;
    self.shared_event_id=shared_event_id;
    self.event_title=event_title;
    self.event_time=event_time;
    self.location_name=location_name;
    self.invitee=invitee;
    self.isEventOwner=isOwner;
}

#pragma mark - handle Invited People Part
//handle invited people section
-(void)handleInvitedPeoplePart{
//    //clean the garbage view
//    if (self.garbageCollection) {
//        for (UIView* view in self.garbageCollection) {
//            [view removeFromSuperview];
//        }
//        [self.garbageCollection removeAllObjects];
//    }
//    self.garbageCollection=[NSMutableArray array];
    
    int height=0;
    if ([self.invitee count]>0) {
        height=50*[self.invitee count]/4;
        self.invitedPeopleSectionView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, height)];
        [self.mainScrollView addSubview:self.invitedPeopleSectionView];
        
        //---------->>add gesture(tap)
        self.invitedPeopleSectionView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInviteBlock:)];
        [self.invitedPeopleSectionView addGestureRecognizer:tapGR];
        
        //---------->>set background color
        [self.invitedPeopleSectionView setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        
        //---------->>set number color
        UILabel* numOfInvites=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 40)];
        if ([self.invitee count] == 1) {
            [numOfInvites setText:[NSString stringWithFormat:@"1 friend invited"]];
        } else {
            [numOfInvites setText:[NSString stringWithFormat:@"%d friends invited",[self.invitee count]]];
        }
        [numOfInvites setFont:[UIFont boldSystemFontOfSize:19]];
        [numOfInvites setTextColor:[UIColor darkGrayColor]];
        [numOfInvites setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
        [self.invitedPeopleSectionView addSubview:numOfInvites];
        //[self.garbageCollection addObject:numOfInterests];
        
        //---------->>set invited people image
        int x_position_photo=5;
        int y_position_photo=42;
#define DISCUSSION_INVITE_IMAGE_SIZE 55
        for (int i=0; i<7&&i<([self.invitee count]); i++) {
            UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x_position_photo+5, y_position_photo, DISCUSSION_INVITE_IMAGE_SIZE, DISCUSSION_INVITE_IMAGE_SIZE)];
            UILabel* userName=[[UILabel alloc] initWithFrame:CGRectMake(x_position_photo, y_position_photo+DISCUSSION_INVITE_IMAGE_SIZE, DISCUSSION_INVITE_IMAGE_SIZE+25, 20)];
            [userName setFont:[UIFont boldSystemFontOfSize:10]];
            [userName setTextColor:[UIColor darkGrayColor]];
            [userName setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
            ProfileInfoElement* element=[self.invitee objectAtIndex:i];
            [userName setText:element.user_name];
            [self.invitedPeopleSectionView addSubview:userName];
            NSURL* backGroundImageUrl=[NSURL URLWithString:element.user_pic];
            if (![Cache isURLCached:backGroundImageUrl]) {
                //using high priority queue to fetch the image
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                    //get the image data
                    NSData * imageData = nil;
                    imageData = [[NSData alloc] initWithContentsOfURL: backGroundImageUrl];
                    if (imageData == nil ){
                        //if the image data is nil, the image url is not reachable. using a default image to replace that
                        //NSLog(@"downloaded %@ error, using a default image",url);
                        UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                        imageData=UIImagePNGRepresentation(image);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:backGroundImageUrl withData:imageData];
                                userImageView.image=[UIImage imageWithData:imageData];
                            });
                        }
                    }
                    else {
                        //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                        //NSLog(@"downloaded %@",url);
                        if(imageData){
                            dispatch_async( dispatch_get_main_queue(),^{
                                [Cache addDataToCache:backGroundImageUrl withData:imageData];
                                userImageView.image=[UIImage imageWithData:imageData];
                            });
                        }
                    }
                });
            }
            else {
                dispatch_async( dispatch_get_main_queue(),^{
                    userImageView.image=[UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]];
                });
            }
            [self.invitedPeopleSectionView addSubview:userImageView];
            x_position_photo+=DISCUSSION_INVITE_IMAGE_SIZE+25;
        }
    }
}

@end
