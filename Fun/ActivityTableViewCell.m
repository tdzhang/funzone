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
    

    self.activityPicImageView.layer.cornerRadius = 10;
    self.activityPicImageView.clipsToBounds = YES;
    [self.activityPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.activityPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.activityPicImageView.layer.backgroundColor = [[UIColor colorWithRed:250/255.0 green:150/255.0 blue:20/255.0 alpha:1] CGColor];
    //self.activityPicImageView.layer.borderWidth = 1;
    
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
    
    self.userPicImageView.layer.cornerRadius = 4;
    self.userPicImageView.clipsToBounds = YES;
    [self.userPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.userPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.userPicImageView.layer.borderWidth = 1;
    
    self.eventPicImageView.layer.cornerRadius = 2;
    self.eventPicImageView.clipsToBounds = YES;
    [self.eventPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.eventPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.eventPicImageView.layer.borderWidth = 1;
    
    NSURL *eventUrl=[NSURL URLWithString:element.event_pic];
    //deal with the profile image
    if (![Cache isURLCached:eventUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: eventUrl];
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_PROFILE_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:eventUrl withData:imageData];
                        [self.eventPicImageView setImage:image];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
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
    
    if ([ [NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",INTEREST_EVENT]]) {
        // some one show interest on your event/////
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ joined your event.",self.user_name]];
        [self.activityPicImageView setImage:[UIImage imageNamed:@"like.png"]];
        self.eventPicImageView.hidden = NO;
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 193, 37);
        //[self.userNameLabel setText:@"Interested Event:"];
    }
    else if([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",FOLLOW_SOMEONE]]){
        //some one followed you
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ followed you.",self.user_name]];
        [self.activityPicImageView setImage:[UIImage imageNamed:@"follow.png"]];
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 246, 37);

        //[self.userNameLabel setText:@"Followed Event:"];
    }
    else if([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",COMMENT_EVENT]]){
        //some one comment on you event
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ commented on your event.",self.user_name]];
        
        self.eventPicImageView.hidden = NO;
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 193, 37);
        [self.activityPicImageView setImage:[UIImage imageNamed:@"comment.png"]];
        //[self.userNameLabel setText:@"Comment Event:"];
    }
    else if ([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",INVITED_TO_EVENT]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ invited you to an event.",self.user_name]];
        [self.activityPicImageView setImage:[UIImage imageNamed:@"invite.png"]];
        self.eventPicImageView.hidden = NO;
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 193, 37);
    }
    else if ([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",NEW_FRIEND_JOIN]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ just joined OrangeParc.",self.user_name]];
        self.activityDescriptionLabel.frame = CGRectMake(65, 8, 246, 37);

#warning need further other image
        self.activityPicImageView.hidden = YES;
        //[self.activityPicImageView setImage:[UIImage imageNamed:@"invite.png"]];
    }
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
    
    self.event_name=element.event_name;
    self.message=element.message;
    NSURL *imageUrl=[NSURL URLWithString:element.event_pic];
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
    
    self.userPicImageView.layer.cornerRadius = 4;
    self.userPicImageView.clipsToBounds = YES;
    [self.userPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.userPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.userPicImageView.layer.borderWidth = 1;
    
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
                        [self.activityPicImageView setImage:image];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:userPicUrl withData:imageData];
                        [self.activityPicImageView setImage:[UIImage imageWithData:imageData]];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            [self.activityPicImageView setImage:[UIImage imageWithData:[Cache getCachedData:userPicUrl]]];
        });
    }
    
    self.activityPicImageView.layer.cornerRadius = 2;
    self.activityPicImageView.clipsToBounds = YES;
    [self.activityPicImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.activityPicImageView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.activityPicImageView.layer.borderWidth = 1;
    [self.activityPicImageView setHidden:YES];

    self.user_name_label.frame = CGRectMake(64, 6, 246, 17);
    self.user_name_label.text = [NSString stringWithFormat:@"%@:",self.user_name];
    [self.user_name_label setFont:[UIFont boldSystemFontOfSize:12]];
    self.user_name_label.textColor = [UIColor darkGrayColor];
    self.user_name_label.lineBreakMode = UILineBreakModeTailTruncation;
    self.user_name_label.numberOfLines = 1;
    
        
    [self.activityDescriptionLabel setFont:[UIFont systemFontOfSize:12]];
    [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"\"%@\"",self.message]];
    self.activityDescriptionLabel.lineBreakMode = UILineBreakModeTailTruncation;
    self.activityDescriptionLabel.textColor = [UIColor darkGrayColor];
    self.activityDescriptionLabel.numberOfLines = 1;
    self.activityDescriptionLabel.frame = CGRectMake(64, 23, 246, 15);
    
    self.event_name_label.frame = CGRectMake(64, 39, 246, 15);
    self.event_name_label.text = [NSString stringWithFormat:@"via %@",self.event_name];
    self.event_name_label.textAlignment = UITextAlignmentRight;
    [self.event_name_label setFont:[UIFont italicSystemFontOfSize:10]];
    [self.event_name_label setTextColor:[UIColor lightGrayColor]];
    self.event_name_label.lineBreakMode = UILineBreakModeTailTruncation;
    self.event_name_label.numberOfLines = 1;

}

@end
