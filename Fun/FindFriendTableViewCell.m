//
//  FindFriendTableViewCell.m
//  Fun
//
//  Created by Tongda Zhang on 7/30/12.
//
//

#import "FindFriendTableViewCell.h"

@implementation FindFriendTableViewCell
@synthesize friendImageView;
@synthesize friendName;
@synthesize actionButton;
@synthesize delegate=_delegate;

@synthesize actionCategory=_actionCategory;

@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize fb_id=_fb_id;
@synthesize registerd=_registerd;
@synthesize user_id=_user_id;
@synthesize followed=_followed;

@synthesize via=_via;
@synthesize indexPath=_indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //self.actionButton.imageView.image = [UIImage imageNamed:@"button_comment.png"];
        //self.actionButton.imageView.frame.size = self.actionButton.frame.size;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetWithSearchedFriend:(SearchedFriend *)friend AtIndexPath:(NSIndexPath *)indexPath{
    //get the user information in to the cell, used for the "followed/unfollow/invite button"
    self.user_id=friend.user_id;
    self.user_name=friend.user_name;
    self.user_pic=friend.user_pic;
    self.fb_id=friend.fb_id;
    self.registerd=friend.registerd;
    self.followed=friend.followed;
    self.indexPath=indexPath;
    
    [self.friendName setText:friend.user_name];
    
    NSURL *backGroundImageUrl=[NSURL URLWithString:friend.user_pic];
    
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
                        [self.friendImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
            else {
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:backGroundImageUrl withData:imageData];
                        [self.friendImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.friendImageView setImage:[UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]]];
        });
    }
    
    if (friend.registerd) {
        if(friend.followed){
            [self.actionButton setTitle:@"Unfollow" forState:UIControlStateNormal];
            self.actionCategory=@"unfollow";
        }
        else{
            [self.actionButton setTitle:@"Follow" forState:UIControlStateNormal];
            self.actionCategory=@"follow";
        }
    }
    else{
        [self.actionButton setTitle:@"Invite" forState:UIControlStateNormal];
            self.actionCategory=@"invite";
    }
}

-(void)resetWithTopFriend:(SearchedFriend *)friend AtIndexPath:(NSIndexPath *)indexPath{
    self.user_id=friend.user_id;
    self.user_name=friend.user_name;
    self.user_pic=friend.user_pic;
    self.fb_id=friend.fb_id;
    self.registerd=friend.registerd;
    self.followed=friend.followed;
    self.indexPath=indexPath;
    
    [self.friendName setText:friend.user_name];
    
    NSURL *backGroundImageUrl=[NSURL URLWithString:friend.user_pic];
    
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
                        [self.friendImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
            else {
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:backGroundImageUrl withData:imageData];
                        [self.friendImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.friendImageView setImage:[UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]]];
        });
    }

    if(friend.followed){
        [self.actionButton setTitle:@"Unfollow" forState:UIControlStateNormal];
        self.actionCategory=@"unfollow";
    }
    else{
        [self.actionButton setTitle:@"Follow" forState:UIControlStateNormal];
       self.actionCategory=@"follow"; 
    }

}

-(void)iniviteByPostingOnOtherFacebookWall{
    //do sth about the facebook invite comment;
    NSLog(@"facebook invite friend.");
    FunAppDelegate *funAppdelegate=[[UIApplication sharedApplication] delegate];
    if (!funAppdelegate.facebook) funAppdelegate.facebook = [[Facebook alloc] initWithAppId:FACEBOOK_APP_ID andDelegate:(id)funAppdelegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        //if already login : start the action sheet
        funAppdelegate.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        funAppdelegate.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:@"OrangeParc event" forKey:@"name"];
    [params setObject:@"new OrangeParc event" forKey:@"description"];
    [params setObject:[NSString stringWithFormat:@"Hi, %@. I am using OrangeParc to find and create event, you should definitely try it. Find detail at http://www.orangeparc.com",self.user_name] forKey:@"message"];
    
    if ([funAppdelegate.facebook isSessionValid]) {
        [funAppdelegate.facebook requestWithGraphPath:[NSString stringWithFormat:@"%@/feed",self.fb_id]
                                            andParams:params
                                        andHttpMethod:@"POST"
                                          andDelegate:self];
    }
    else{
        //if not login, do it
//        NSArray *permissions = [[NSArray alloc] initWithObjects:
//                                @"publish_stream",
//                                @"read_stream",@"create_event",@"email",
//                                nil];
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"publish_stream",
                                @"email",
                                nil];
        [funAppdelegate.facebook authorize:permissions];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceBookLoginFinished) name:@"faceBookLoginFinished" object:nil];
    }
}

- (IBAction)actionButtonClicke:(id)sender {
    [self.actionButton setEnabled:NO];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([self.actionCategory isEqualToString:@"follow"]) {
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/follow?auth_token=%@&followee_id=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.user_id,self.via]];
        NSLog(@"%@",url);
        
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
                    NSString *responseString = [request responseString];
                    NSLog(@"%@",responseString);
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                    
                    if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        [self.actionButton setTitle:@"Unfollow" forState:UIControlStateNormal];
                        self.actionCategory=@"unfollow";
                        self.followed=YES;
                        [self.delegate changeTheFollowStateAtIndex:self.indexPath];
                    }
                    else {
                        UIAlertView *unsuccess = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"We are sorry. Something went wrong. %@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        unsuccess.delegate=self;
                        [unsuccess show];
                    }
                    [self.actionButton setEnabled:YES];
                }
                
            });
            
        });
    }
    else if ([self.actionCategory isEqualToString:@"unfollow"]) {
        NSURL* url=[NSURL URLWithString:[NSString stringWithFormat:@"%@/users/unfollow?auth_token=%@&&followee_id=%@&via=%d",CONNECT_DOMIAN_NAME,[defaults objectForKey:@"login_auth_token"],self.user_id,self.via]];

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
                    NSString *responseString = [request responseString];
                    NSLog(@"%@",responseString);
                    NSError *error;
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[request responseData] options:kNilOptions error:&error];
                    
                    if ([[json objectForKey:@"response"] isEqualToString:@"ok"]) {
                        [self.actionButton setTitle:@"Follow" forState:UIControlStateNormal];
                        self.actionCategory=@"follow";
                        self.followed=NO;
                        [self.delegate changeTheFollowStateAtIndex:self.indexPath];
                    }
                    else {
                        UIAlertView *unsuccess = [[UIAlertView alloc] initWithTitle:nil message: [NSString stringWithFormat:@"We are sorry. Something went wrong. %@",[json objectForKey:@"message"]] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        unsuccess.delegate=self;
                        [unsuccess show];
                    }
                    [self.actionButton setEnabled:YES];
                }
                
            });
            
        });
    }
    else if ([self.actionCategory isEqualToString:@"invite"]) {
        [self iniviteByPostingOnOtherFacebookWall];
    }
}


#pragma mark - facebook related protocal implement
-(void)faceBookLoginFinished{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self iniviteByPostingOnOtherFacebookWall];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@", [error localizedDescription]);
    NSLog(@"Err details: %@", [error description]);
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    NSLog(@"%@",result);
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Facebook" message: [NSString stringWithFormat:@"You have successfully sent the invitation to your friend."] delegate:self  cancelButtonTitle:@"OK" otherButtonTitles:nil];
    success.delegate=self;
    [success show];
}



@end
