//
//  ActivityTableViewCell.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import "ActivityTableViewCell.h"
#import "QuartzCore/QuartzCore.h"



@implementation ActivityTableViewCell

@synthesize type=_type;
@synthesize user_id=_user_id;
@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;

@synthesize activityPicImageView = _activityPicImageView;
@synthesize event_name_label = _event_name_label;
@synthesize event_name=_event_name;
@synthesize message=_message;

@synthesize userPicImageView;
@synthesize activityDescriptionLabel;
@synthesize eventPicImageView = _eventPicImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)resetWithActivityObject:(activityElementObject*)element{
    self.type=element.type;
    self.user_id=element.user_id;
    self.user_name=element.user_name;
    self.user_pic=element.user_pic;
    self.event_id=element.event_id;
    self.shared_event_id=element.shared_event_id;
    
    [self.user_name_label setHidden:YES];
    [self.event_name_label setHidden:YES];
    
    [self.userPicImageView clipsToBounds];
    [self.userPicImageView setContentMode:UIViewContentModeScaleToFill];
    
    NSLog(@"%@",self.type);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",INTEREST_EVENT]);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",FOLLOW_SOMEONE]);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",COMMENT_EVENT]);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",INVITED_TO_EVENT]);
    

    //-------------------Activity Image View------------------//
    [self.activityPicImageView setFrame:CGRectMake(37, 30, 20, 20)];
    self.activityPicImageView.layer.cornerRadius = 10;
    self.activityPicImageView.clipsToBounds = YES;
    [self.activityPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.activityPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    
    //-------------------User Profile Image View------------------//
    [self.userPicImageView setFrame:CGRectMake(10, 7, 40, 40)];
    self.userPicImageView.layer.cornerRadius = 4;
    self.userPicImageView.clipsToBounds = YES;
    [self.userPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.userPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.userPicImageView.layer.borderWidth = 1;

    
    NSURL *imageUrl=[NSURL URLWithString:element.user_pic];
    //deal with the profile image
    if (![Cache isURLCached:imageUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: imageUrl];
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:imageUrl withData:imageData];
                        [self.userPicImageView setImage:image];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:imageUrl withData:imageData];
                        [self.userPicImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.userPicImageView setImage:[UIImage imageWithData:[Cache getCachedData:imageUrl]]];
        });
    }

    //-----------------------event picture display-----------------------//
    [self.eventPicImageView setFrame:CGRectMake(271, 7, 40, 40)];
    self.eventPicImageView.layer.cornerRadius = 4;
    self.eventPicImageView.clipsToBounds = YES;
    [self.eventPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.eventPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.eventPicImageView.layer.borderWidth = 1;

//    if ([[NSString stringWithFormat:@"%@",element.event_pic] isEqualToString:@"<null>"]) {
//        element.event_pic=DEFAULT_IMAGE_PLACEHOLDER;
//    }
    NSLog(@"-->%@",element.event_pic);
    NSURL *eventUrl=[NSURL URLWithString:element.event_pic];
    //deal with the profile image
    if (![Cache isURLCached:eventUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: eventUrl];
            if ( imageData == nil ){
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_PLACEHOLDER];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:eventUrl withData:imageData];
                        [self.eventPicImageView setImage:image];
                    });
                }
            }
            else {

                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:eventUrl withData:imageData];
                        [self.eventPicImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.eventPicImageView setImage:[UIImage imageWithData:[Cache getCachedData:eventUrl]]];
        });
    }
    self.eventPicImageView.layer.hidden = YES;
        
    //self.activityDescriptionLabel.frame = CGRectMake(65, 11, 210, 37);
    self.activityDescriptionLabel.numberOfLines = 2;
    [self.activityDescriptionLabel setFont:[UIFont boldSystemFontOfSize:12]];
    self.activityDescriptionLabel.textColor = [UIColor darkGrayColor];
    
    // Like
    if ([ [NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",INTEREST_EVENT]]) {
        
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ liked your event.",self.user_name]];
        [self.activityPicImageView setImage:[UIImage imageNamed:@"like.png"]];
        self.eventPicImageView.hidden = NO;
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 193, 37);
        //[self.userNameLabel setText:@"Interested Event:"];
    }
    
    // Follow
    else if([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",FOLLOW_SOMEONE]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ followed you.",self.user_name]];
        [self.activityPicImageView setImage:[UIImage imageNamed:@"follow.png"]];
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 246, 37);

        //[self.userNameLabel setText:@"Followed Event:"];
    }
    
    // Comment
    else if([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",COMMENT_EVENT]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ commented on your event.",self.user_name]];
        self.eventPicImageView.hidden = NO;
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 193, 37);
        [self.activityPicImageView setImage:[UIImage imageNamed:@"comment.png"]];
        //[self.userNameLabel setText:@"Comment Event:"];
    }
    
    // Invite
    else if ([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",INVITED_TO_EVENT]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ invited you to an event.",self.user_name]];
        [self.activityPicImageView setImage:[UIImage imageNamed:@"invite.png"]];
        self.eventPicImageView.hidden = NO;
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 193, 37);
    }
    
    // Joined your event
    else if ([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",NEW_FRIEND_JOIN]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ joined OrangeParc.",self.user_name]];
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 246, 37);
        self.activityPicImageView.hidden = YES;
#warning need further other image
        [self.activityPicImageView setImage:[UIImage imageNamed:@"invite.png"]];
    }
    
    // No activity found
    else{
        //[self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ has done something you may be interested.",self.user_name]];
        NSLog(@"ActivityTableViewcell:activity type not found.");
    }
}

-(void)resetWithConversationActivityObject:(activityElementObject*)element{
    self.type=element.type;
    self.user_id=element.user_id;
    self.user_name=element.user_name;
    self.user_pic=element.user_pic;
    self.event_id=element.event_id;
    self.shared_event_id=element.shared_event_id;
    self.isViewed=element.isViewed;
    
    self.event_name=element.event_name;
    self.message=element.message;
    NSURL *imageUrl=[NSURL URLWithString:element.event_pic];

    //------------deal with the event image; REUSE user image frame here.
    [self.eventPicImageView setFrame:CGRectMake(10, 7, 40, 40)];
    self.eventPicImageView.layer.cornerRadius = 4;
    self.eventPicImageView.clipsToBounds = YES;
    [self.eventPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.eventPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.eventPicImageView.layer.borderWidth = 1;
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRect:self.eventPicImageView.bounds];
    self.eventPicImageView.layer.shadowPath = path1.CGPath;
    
    if (![Cache isURLCached:imageUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: imageUrl];
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_PLACEHOLDER];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:imageUrl withData:imageData];
                        [self.eventPicImageView setImage:image];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:imageUrl withData:imageData];
                        [self.eventPicImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.eventPicImageView setImage:[UIImage imageWithData:[Cache getCachedData:imageUrl]]];
        });
    }
    
    
    //--------user profile image display
    [self.userPicImageView setFrame:CGRectMake(37, 30, 20, 20)];
    self.userPicImageView.layer.cornerRadius = 2;
    self.userPicImageView.clipsToBounds = YES;
    [self.userPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.userPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.userPicImageView.layer.borderWidth = 1;
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRect:self.eventPicImageView.bounds];
    self.userPicImageView.layer.shadowPath = path2.CGPath;
    [self.userPicImageView setHidden:YES];
    
    NSURL *userPicUrl=[NSURL URLWithString:element.user_pic];
    NSLog(@"%@",userPicUrl);
    //deal with the profile image
    if (![Cache isURLCached:userPicUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: userPicUrl];
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:userPicUrl withData:imageData];
                        [self.userPicImageView setImage:image];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:userPicUrl withData:imageData];
                        [self.userPicImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.userPicImageView setImage:[UIImage imageWithData:[Cache getCachedData:userPicUrl]]];
        });
    }
    
    

    //--------display username--------//

    self.user_name_label.frame = CGRectMake(62, 6, 246, 17);
    self.user_name_label.text = [NSString stringWithFormat:@"%@:",self.user_name];
    [self.user_name_label setFont:[UIFont boldSystemFontOfSize:12]];
    self.user_name_label.textColor = [UIColor blackColor];
    self.user_name_label.lineBreakMode = UILineBreakModeTailTruncation;
    self.user_name_label.numberOfLines = 1;
    
        
    [self.activityDescriptionLabel setFont:[UIFont systemFontOfSize:12]];
    [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@",self.message]];
    self.activityDescriptionLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.activityDescriptionLabel.textColor = [UIColor darkGrayColor];
    self.activityDescriptionLabel.numberOfLines = 1;
    self.activityDescriptionLabel.frame = CGRectMake(62, 23, 246, 15);
    
    self.event_name_label.frame = CGRectMake(64, 39, 246, 15);
    self.event_name_label.text = [NSString stringWithFormat:@"via %@",self.event_name];
    self.event_name_label.textAlignment = UITextAlignmentRight;
    [self.event_name_label setFont:[UIFont italicSystemFontOfSize:10]];
    [self.event_name_label setTextColor:[UIColor lightGrayColor]];
    self.event_name_label.lineBreakMode = UILineBreakModeTailTruncation;
    self.event_name_label.numberOfLines = 1;

}

@end
