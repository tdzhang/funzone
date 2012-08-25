//
//  DiscussionViewController.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/17/12.
//
//

#import "DiscussionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface DiscussionViewController ()
//outlet
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextView *addCommentTextView;

//the information of the event and the invited people
@property (nonatomic,strong) NSString *event_id;
@property (nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) NSString *event_title;
@property (nonatomic,strong) NSString *event_time;
@property (nonatomic,strong) NSString *location_name;
@property (nonatomic,strong) NSMutableArray *invitee;
@property (nonatomic,strong) NSArray *comments;
@property (nonatomic) BOOL isEventOwner; //used to indicate whether it is a editable event (based on who is the owner)

@property (nonatomic,strong) NSMutableArray *garbageCollection;

//the structure of the view of the Scroll View
@property(nonatomic,strong) UIView *invitedPeopleSectionView;
@property (nonatomic,strong) UIView *commentSectionView;

//invited friend
@property (nonatomic,strong) NSMutableDictionary *invitedFriend;
@property (nonatomic,strong) NSMutableDictionary *invitedAddressBookFriend;
@property (nonatomic,strong) NSArray* invitedFriendLastReceivedJson;

@end

@implementation DiscussionViewController
@synthesize mainScrollView = _mainScrollView;
@synthesize addCommentTextView = _addCommentTextView;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize event_title=_event_title;
@synthesize event_time=_event_time;
@synthesize location_name=_location_name;
@synthesize invitee=_invitee;
@synthesize isEventOwner=_isEventOwner;
@synthesize comments=_comments;

@synthesize garbageCollection=_garbageCollection;

@synthesize invitedPeopleSectionView=_invitedPeopleSectionView;
@synthesize commentSectionView=_commentSectionView;

//used to invite inner friend(following)
@synthesize invitedFriend=_invitedFriend;
@synthesize invitedAddressBookFriend=_invitedAddressBookFriend;
@synthesize invitedFriendLastReceivedJson=_invitedFriendLastReceivedJson;

#pragma mark - self defined setter and getter
//used to invite inner friend(following)
-(NSMutableDictionary *)invitedFriend{
    if (!_invitedFriend) {
        _invitedFriend=[NSMutableDictionary dictionary];
    }
    return _invitedFriend;
}

-(NSMutableDictionary *)invitedAddressBookFriend{
    if (!_invitedAddressBookFriend) {
        _invitedAddressBookFriend=[NSMutableDictionary dictionary];
    }
    return _invitedAddressBookFriend;
}

-(NSArray *)invitedFriendLastReceivedJson{
    if (!_invitedFriendLastReceivedJson) {
        _invitedFriendLastReceivedJson=[NSArray array];
    }
    return _invitedFriendLastReceivedJson;
}

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
    [self startFetchingInviteAndCommentData];
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
    [self.mainScrollView setBackgroundColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1]];
}

- (void)viewDidUnload
{
    [self setMainScrollView:nil];
    [self setAddCommentTextView:nil];
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
    self.invitee=[invitee mutableCopy];
    self.isEventOwner=isOwner;
}

//get the inivtedFriend and Addressbook friend from the profileInfoelemanet array
-(void)getinvitedFriendAndAddressbookFriendFromProfileInfoElement{
    [self.invitedFriend removeAllObjects];
    [self.invitedAddressBookFriend removeAllObjects];
    for (ProfileInfoElement* person in self.invitee) {
        NSLog(@"%@",person.email);
        if (person.email&&([person.email length]>3)) {
            NSLog(@"%@",person.email);
            UserContactObject* friend=[[UserContactObject alloc] init];
            friend.lastName = person.user_name;
            friend.email=[NSArray arrayWithObjects:person.email, nil];
            [self.invitedAddressBookFriend  setObject:friend forKey:person.user_name];
        } else {
            InviteFriendObject* friend=[[InviteFriendObject alloc] init];
            friend.user_id=person.user_id;
            friend.user_name=person.user_name;
            friend.user_pic=person.user_pic;
            friend.facebook_id=person.facebook_id;
            friend.followed=person.followed;
            friend.alreadyInvited=friend.alreadyInvited;
            [self.invitedFriend  setObject:friend forKey:person.user_name];
        }
    }
}

#pragma mark - handle Invited People Part
//handle invited people section
-(void)startFetchingInviteAndCommentData{
    //clean the garbage view
    if (self.garbageCollection) {
        for (UIView* view in self.garbageCollection) {
            [view removeFromSuperview];
        }
        [self.garbageCollection removeAllObjects];
    }
#define DISCUSSION_INVITE_IMAGE_SIZE 50
#define DISCUSSION_INVITE_BLOCK_HEIGHT 75
    //-------------------------->invited people part<---------------------------------//
    int height=0;
    if ([self.invitee count]>0) {
        height=DISCUSSION_INVITE_BLOCK_HEIGHT*(([self.invitee count])/5+1)+30;
        self.invitedPeopleSectionView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, height)];
        self.invitedPeopleSectionView.backgroundColor = [UIColor whiteColor];
        self.invitedPeopleSectionView.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.invitedPeopleSectionView.layer.shadowOffset = CGSizeMake(0, 1);
        self.invitedPeopleSectionView.layer.shadowRadius = 1.0f;
        self.invitedPeopleSectionView.layer.shadowOpacity = 0.6f;
        self.invitedPeopleSectionView.layer.cornerRadius = 2;
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.invitedPeopleSectionView.bounds];
        self.invitedPeopleSectionView.layer.shadowPath = path.CGPath;
        
        [self.mainScrollView addSubview:self.invitedPeopleSectionView];
        
        [self.garbageCollection addObject:self.invitedPeopleSectionView];
        
        //---------->>add gesture(tap)
        self.invitedPeopleSectionView.userInteractionEnabled=YES;

        UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInviteBlock:)];
        //[self.invitedPeopleSectionView addGestureRecognizer:tapGR];
        
        //---------->>set number color
        UILabel* numOfInvites=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        [numOfInvites setFont:[UIFont boldSystemFontOfSize:14]];
        if ([self.invitee count] == 1) {
            [numOfInvites setText:[NSString stringWithFormat:@"1 friend invited"]];
        } else {
            [numOfInvites setText:[NSString stringWithFormat:@"%d friends invited",[self.invitee count]]];
        }
        [numOfInvites setTextColor:[UIColor darkGrayColor]];
        [numOfInvites setBackgroundColor:[UIColor clearColor]];
        [self.invitedPeopleSectionView addSubview:numOfInvites];
        [self.garbageCollection addObject:numOfInvites];
        
        //---------->>set invited people image
        int x_position_photo=10;
        int y_position_photo=32;

        for (int i=0; i<7&&i<([self.invitee count]); i++) {
            UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(x_position_photo, y_position_photo, DISCUSSION_INVITE_IMAGE_SIZE, DISCUSSION_INVITE_IMAGE_SIZE)];
            UILabel* userName=[[UILabel alloc] initWithFrame:CGRectMake(x_position_photo, y_position_photo+DISCUSSION_INVITE_IMAGE_SIZE, DISCUSSION_INVITE_IMAGE_SIZE, 20)];
            userName.lineBreakMode = UILineBreakModeTailTruncation;
            userName.numberOfLines = 1;
            [userName setFont:[UIFont boldSystemFontOfSize:10]];
            [userName setTextColor:[UIColor blackColor]];
            [userName setBackgroundColor:[UIColor clearColor]];
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
            userImageView.layer.cornerRadius = 4.0;
            userImageView.layer.masksToBounds = YES;
            [self.invitedPeopleSectionView addSubview:userImageView];
            [userImageView addGestureRecognizer:tapGR];
           
            x_position_photo+=DISCUSSION_INVITE_IMAGE_SIZE+10;
            if ((i+1)%5==0) {
                y_position_photo+=DISCUSSION_INVITE_BLOCK_HEIGHT;
                x_position_photo=10;
            }
        }
        
        //---------->>set edit button
        if (self.isEventOwner) {
            UIButton *editInvitedPeople = [UIButton buttonWithType:UIButtonTypeCustom];
            [editInvitedPeople setFrame:CGRectMake(([self.invitee count]%5)*(DISCUSSION_INVITE_IMAGE_SIZE+10)+10, 32+[self.invitee count]/5*DISCUSSION_INVITE_BLOCK_HEIGHT, 50, 50)];
            [editInvitedPeople setBackgroundImage:[UIImage imageNamed:@"DVC_Add.png"] forState:UIControlStateNormal];
            [editInvitedPeople addTarget:self action:@selector(editInvitedPeopleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            [self.invitedPeopleSectionView addSubview:editInvitedPeople];
            [self.garbageCollection addObject:editInvitedPeople];
        }
    }
    
    //-------------------------->comment part<----------------------------------------//
    int comment_y_start=height+20; // the conment start coordinate
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/messages/view?shared_event_id=%@&auth_token=%@",CONNECT_DOMIAN_NAME,self.shared_event_id,[defaults objectForKey:@"login_auth_token"]]];
        ASIFormDataRequest* request=[ASIFormDataRequest requestWithURL:url];
        NSLog(@"request: %@",url);
        [request setRequestMethod:@"GET"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        NSLog(@"code:%@",request.responseString);
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                
                //success
                NSError *error;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                NSDictionary *jsonDic=[NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                if ([jsonDic isKindOfClass:[NSDictionary class]]&&[[jsonDic objectForKey:@"response"] isEqualToString:@"error"]) {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil message:[jsonDic  objectForKey:@"message"] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    errorAlert.delegate=self;
                    [errorAlert show];

                } else {
                    self.comments=[DiscussionComment getDiscussionCommentArrayFromArray:json];
                    
                    //comment header view
//                    UIView *comments_header_view = [[UIView alloc] initWithFrame:CGRectMake(5, comment_y_start, 310, 30)];
//                    [comments_header_view setBackgroundColor:[UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1]];
//                    [self.mainScrollView addSubview:comments_header_view];
//                    
//                    [self.garbageCollection addObject:comments_header_view];
                    
                    //comment header label
//                    UILabel *comment_header_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
//                    NSString *comment_header;
//                    if ([self.comments count] == 0 || [self.comments count] == 1) {
//                        comment_header = [NSString stringWithFormat:@"%d Comment", [self.comments count]];
//                    }else {
//                        comment_header = [NSString stringWithFormat:@"%d Comments", [self.comments count]];
//                    }
//                    [comment_header_label setText:comment_header];
//                    [comment_header_label setBackgroundColor:[UIColor clearColor]];
//                    [comment_header_label setFont:[UIFont boldSystemFontOfSize:14]];
//                    [comment_header_label setTextColor:[UIColor darkGrayColor]];
//                    [comment_header_label setShadowColor:[UIColor whiteColor]];
//                    [comment_header_label setShadowOffset: CGSizeMake(0, 1)];
//                    [comments_header_view addSubview:comment_header_label];
                    
                    int height = comment_y_start;
                    
                    //add every single comment entry
                    for (int i = 0; i<[self.comments count]; i++) {
                        //if(i==5)break; //in this page, only present a few comments
                        DiscussionComment* comment=[self.comments objectAtIndex:i];
                        UIImageView *seperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
                        [seperator setImage:[UIImage imageNamed:@"seperator_line.png"]];
                        
                        UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, height, 320, 0)];
                        
                        
                        [commentView setBackgroundColor:[UIColor clearColor]];
                        [commentView addSubview:seperator];
                        
                        UIImageView* userImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
                        userImageView.layer.cornerRadius = 4;
                        userImageView.clipsToBounds = YES;
                        [userImageView setContentMode:UIViewContentModeScaleAspectFill];
                        userImageView.layer.borderColor = [[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5] CGColor];
                        userImageView.layer.borderWidth = 0.6;
                        
                        
                        
                        if (![Cache isURLCached:comment.user_picture_url]) {
                            //using high priority queue to fetch the image
                            dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
                                //get the image data
                                NSData * imageData = nil;
                                imageData = [[NSData alloc] initWithContentsOfURL: comment.user_picture_url];
                                
                                if ( imageData == nil ){
                                    //if the image data is nil, the image url is not reachable. using a default image to replace that
                                    //NSLog(@"downloaded %@ error, using a default image",url);
                                    UIImage *image=[UIImage imageNamed:@"smile_64.png"];
                                    imageData=UIImagePNGRepresentation(image);
                                    if(imageData){
                                        dispatch_async( dispatch_get_main_queue(),^{
                                            [Cache addDataToCache:comment.user_picture_url withData:imageData];
                                            [userImageView setImage:image];
                                        });
                                    }
                                }
                                else {
                                    //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                                    //NSLog(@"downloaded %@",url);
                                    if(imageData){
                                        dispatch_async( dispatch_get_main_queue(),^{
                                            [Cache addDataToCache:comment.user_picture_url withData:imageData];
                                            [userImageView setImage:[UIImage imageWithData:imageData]];
                                        });
                                    }
                                }
                            });
                        }
                        else {
                            dispatch_async( dispatch_get_main_queue(),^{
                                [userImageView setImage:[UIImage imageWithData:[Cache getCachedData:comment.user_picture_url]]];
                            });
                        }
                       
                        [commentView addSubview:userImageView];
                        
                        //comment user name label
                        //UILabel *comment_user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 20)];
                        UILabel *comment_user_name_label = [[UILabel alloc] initWithFrame:CGRectMake(60, 1, 100, 30)];
                        NSString *comment_user_name =[NSString stringWithFormat:@"%@",comment.user_name];
                        [comment_user_name_label setText:comment_user_name];
                        [comment_user_name_label setFont:[UIFont boldSystemFontOfSize:14]];
                        [comment_user_name_label setBackgroundColor:[UIColor clearColor]];
                        comment_user_name_label.lineBreakMode = UILineBreakModeTailTruncation;
                        comment_user_name_label.numberOfLines = 1;
                        
                        //comment timestamp
                        UILabel *comment_time = [[UILabel alloc] initWithFrame:CGRectMake(200, 1, 100, 30)];
                        comment_time.text = [NSString stringWithFormat:@"%@",comment.timestamp];
                        [comment_time setTextColor:[UIColor lightGrayColor]];
                        comment_time.textAlignment = UITextAlignmentRight;
                        [comment_time setFont:[UIFont systemFontOfSize:12]];
                        [comment_time setBackgroundColor:[UIColor clearColor]];
                        comment_time.numberOfLines = 1;
                        
                        //content part (also add the time stamp to the comment part)
                        UILabel *comment_content_label = [[UILabel alloc] initWithFrame:CGRectMake(60, 28, 260, 0)];
                        NSString *comment_content = [NSString stringWithFormat:@"%@",comment.content];
                        [comment_content_label setText:comment_content];
                        [comment_content_label setFont:[UIFont systemFontOfSize:13]];
                        [comment_content_label setBackgroundColor:[UIColor clearColor]];
                        comment_content_label.lineBreakMode = UILineBreakModeWordWrap;
                        comment_content_label.numberOfLines = 0;
                        [comment_content_label setTextColor:[UIColor darkGrayColor]];
            
                        
                        CGSize maximumLabelSize2 = CGSizeMake(260,9999);
                        CGSize expectedLabelSize2 = [comment_content sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:maximumLabelSize2 lineBreakMode: UILineBreakModeWordWrap];
                        
                        CGRect newFrame2 = comment_content_label.frame;
                        newFrame2.size.height = expectedLabelSize2.height;
                        comment_content_label.frame = newFrame2;
                        
                        [commentView addSubview:comment_content_label];
                        [commentView addSubview:comment_user_name_label];
                        [commentView addSubview:comment_time];
                        
                        CGRect newFrame3 = commentView.frame;
                        newFrame3.size.height = comment_content_label.bounds.size.height+35;
                        commentView.frame = newFrame3;
                        
                        [self.mainScrollView addSubview:commentView];
                        [self.garbageCollection addObject:commentView];
                        //distance between two comment view is 0px.
                        height = height + commentView.bounds.size.height;
                    }
                    //set the scroll view content size
                    //self.commentSectionView.frame = CGRectMake(0, height+15, 320, 200);
                    [self.mainScrollView setContentSize:CGSizeMake(320, height+5)];
                }
            }
            else{
                //connect error
#warning handle connection error
            }
            
        });
        
    });
    

    
}

#pragma mark - segue related stuff
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"StartInviteFriend"]){
        [self getinvitedFriendAndAddressbookFriendFromProfileInfoElement];
        
        InviteTableViewController *peopleController=nil;
        peopleController = segue.destinationViewController;
        peopleController.delegate=self;
        peopleController.alreadySelectedContacts=[self.invitedFriend copy];
        peopleController.addressbook_alreadySelectedContacts=[self.invitedAddressBookFriend copy];
    }

}

#pragma mark - button action
-(void)editInvitedPeopleButtonClicked{
    [self performSegueWithIdentifier:@"StartInviteFriend" sender:self];
}

-(void)tapInviteBlock:(UITapGestureRecognizer *)tapGR {
    #warning need process the touch event of the discussion invited people
    /*
    if ([self.invitee count]==0) {
        return;
    }
    CGPoint touchPoint=[tapGR locationInView:[self invitedPeopleSectionView]];
    float touchPointY=touchPoint.y;
    float touchPointX=touchPoint.x;
    //get the index of the touched block view
    int index=(touchPointX-5)/40;
    if (index >= [self.invitee count]) {
        return;
    }
    ProfileInfoElement* tapped_element=[self.invitee objectAtIndex:index];
    self.tap_user_id=tapped_element.user_id;
    if(touchPointY>25&&index<7){
        self.next_page_profile_via=VIA_INVITED_PEOPLE;
        [self performSegueWithIdentifier:@"ViewJoinedPeopleProfile" sender:self];
    }
     */
}


- (IBAction)CommentEnterButtonClicked:(id)sender {
    [self.addCommentTextView resignFirstResponder];
#warning strip white spaces
    if (self.addCommentTextView.text.length>0) {
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/messages/create",CONNECT_DOMIAN_NAME]];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
            
            //add login auth_token //add content
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [request setPostValue:[defaults objectForKey:@"login_auth_token"] forKey:@"auth_token"];
            [request setPostValue:self.shared_event_id forKey:@"shared_event_id"];
            [request setPostValue:self.addCommentTextView.text forKey:@"content"];
            [request setRequestMethod:@"POST"];
            [request startSynchronous];
            
            int code=[request responseStatusCode];
            NSLog(@"code:%@",request.responseString);
            
            dispatch_async( dispatch_get_main_queue(),^{
                if (code==200) {
                    //success
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                    if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        [self.addCommentTextView setText:@""];
                        [self startFetchingInviteAndCommentData];
                        //[self.navigationController popViewControllerAnimated:YES];
                    }
                    else{
                        UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:nil message:[NSString     stringWithFormat:@"We are sorry. Your message was not received by the server. Please try again."] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        notsuccess.delegate=self;
                        //[notsuccess show];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
                
            });
            
        });
    }
}



#pragma mark - implement UITextViewDelegate method
////////////////////////////////////////////////
//implement the Protocal UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    UIBarButtonItem *done =    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    
    self.navigationItem.rightBarButtonItem = done;
    [self animateTextView:textView up:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
    [self animateTextView:textView up:NO];
}

//deal with when user pressed the "done" button
- (void)leaveEditMode {
    [self.addCommentTextView resignFirstResponder];
}
//To compensate for the showing up keyboard
- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    const int movementDistance = 215; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)startInviteFriendWithEventID{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/events/invite?event_id=%@&shared_event_id=%@&auth_token=%@",CONNECT_DOMIAN_NAME,self.event_id,self.shared_event_id,[defaults objectForKey:@"login_auth_token"]]];
    NSLog(@"request:%@",url);
    
    //organize registered users
    NSString *user_ids=@"";
    for (NSString* key in [self.invitedFriend allKeys]) {
        InviteFriendObject* person =[self.invitedFriend objectForKey:key];
        if ([user_ids isEqualToString:@""]) {
            user_ids=[user_ids stringByAppendingFormat:@"%@",person.user_id];
        } else {
            user_ids=[user_ids stringByAppendingFormat:@",%@",person.user_id];
        }
    }
    
    //organize addressbook users
    NSString *emails=@"";
    for (NSString* key in [self.invitedAddressBookFriend allKeys]) {
        UserContactObject* person=[self.invitedAddressBookFriend objectForKey:key];
        NSString* name=[key stringByReplacingOccurrencesOfString:@"," withString:@""];
        if ([emails isEqualToString:@""]) {
            emails=[emails stringByAppendingFormat:@"%@ <%@>",name,[person.email objectAtIndex:0]];
        } else {
            emails=[emails stringByAppendingFormat:@", %@ <%@>",name,[person.email objectAtIndex:0]];
        }
    }
    NSLog(@"%@",emails);
    ///////////////////////////////////////////////////////////////////////////
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:url];
        [request setPostValue:user_ids forKey:@"user_ids"];
        [request setPostValue:emails forKey:@"emails"];
        [request setRequestMethod:@"POST"];
        [request startSynchronous];
        
        int code=[request responseStatusCode];
        NSLog(@"code:%d",code);
        
        dispatch_async( dispatch_get_main_queue(),^{
            if (code==200) {
                //success
                NSError *error;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:request.responseData options:kNilOptions error:&error];
                if (![[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                    UIAlertView *notsuccess = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"Error: %@",error.description ] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    notsuccess.delegate=self;
                    [notsuccess show];
                }
            }
            
        });
        
    });
}

#pragma mark - self defined protocal <FeedBackToCreateActivityChange> method implementation
////////////////////////////////////////////////
//implement the method for the adding or delete contacts that will be go out with
-(void)AddContactInformtionToPeopleList:(InviteFriendObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSString * key=person.user_name;
    [self.invitedFriend setObject:(id)person forKey:key];
    ProfileInfoElement* newElement=[[ProfileInfoElement alloc] init];
    newElement.user_name=person.user_name;
    newElement.user_id=person.user_id;
    newElement.user_pic=person.user_pic;
    newElement.facebook_id=person.facebook_id;
    newElement.followed=person.followed;
    [self.invitee addObject:newElement];
}

-(void)AddAddressBookContactInformtionToPeopleList:(UserContactObject*)person{
    //NSLog(@"input person:%@",person.firstName);
    NSString *nameText=@"";
    if (person.firstName) {
        nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
        if (person.lastName) {
            nameText=[nameText stringByAppendingFormat:@" %@",person.lastName];
        }
    }
    else if(person.lastName){
        nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
    }
    NSString * key=nameText;
    [self.invitedAddressBookFriend setObject:(id)person forKey:key];
    
    ProfileInfoElement* newElement=[[ProfileInfoElement alloc] init];
    newElement.user_name=key;
    newElement.email=[person.email objectAtIndex:1];
    [self.invitee addObject:newElement];
}

-(void)DeleteContactInformtionToPeopleList:(InviteFriendObject*)person{
    NSString * key=person.user_name;
    [self.invitedFriend removeObjectForKey:key];
    
    for (ProfileInfoElement* element in self.invitee) {
        if ([element.user_id isEqualToString:person.user_id]&&[element.user_name isEqualToString:person.user_name]) {
            //find matched contact, delete it
            [self.invitee removeObject:element];
            break;
        }
    }
}

-(void)DeleteAddressBookContactInformtionToPeopleList:(UserContactObject *)person{
    NSString *nameText=@"";
    if (person.firstName) {
        nameText=[nameText stringByAppendingFormat:@"%@",person.firstName];
        if (person.lastName) {
            nameText=[nameText stringByAppendingFormat:@" %@",person.lastName];
        }
    }
    else if(person.lastName){
        nameText=[nameText stringByAppendingFormat:@"%@",person.lastName];
    }
    NSString * key=nameText;
    [self.invitedAddressBookFriend removeObjectForKey:key];
    
    for (ProfileInfoElement* element in self.invitee) {
        if ([element.user_name isEqualToString:key]) {
            //find matched contact, delete it
            [self.invitee removeObject:element];
            break;
        }
    }
}

-(void)UpdateLastReceivedInviteFriendJson:(NSArray *)lastReceivedJson{
    self.invitedFriendLastReceivedJson=[lastReceivedJson copy];
}


@end
