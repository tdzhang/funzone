//
//  ActivityTableViewCell.m
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import "ActivityTableViewCell.h"


@implementation ActivityTableViewCell

@synthesize type=_type;
@synthesize user_id=_user_id;
@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;

@synthesize userPicImageView;
@synthesize userNameLabel;
@synthesize activityDescriptionLabel;

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
    
    
    [self.userNameLabel setText:@""];
    NSLog(@"%@",self.type);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",INTEREST_EVENT]);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",FOLLOW_SOMEONE]);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",COMMENT_EVENT]);
    NSLog(@"%@",[NSString stringWithFormat:@"%d",INVITED_TO_EVENT]);
    [self.activityDescriptionLabel setFont:[UIFont systemFontOfSize:13]];
    if ([ [NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",INTEREST_EVENT]]) {
        // some one show interest on your event/////
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ joined your event.",self.user_name]];
        //[self.userNameLabel setText:@"Interested Event:"];
    }
    else if([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",FOLLOW_SOMEONE]]){
        //some one followed you
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ followed you.",self.user_name]];
        //[self.userNameLabel setText:@"Followed Event:"];
    }
    else if([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",COMMENT_EVENT]]){
        //some one comment on you event
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ commented on your event.",self.user_name]];
        //[self.userNameLabel setText:@"Comment Event:"];
    }
    else if ([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",INVITED_TO_EVENT]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ invited you to an event.",self.user_name]];
    }
    else if ([[NSString stringWithFormat:@"%@",self.type] isEqualToString:[NSString stringWithFormat:@"%d",NEW_FRIEND_JOIN]]){
        [self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ just joined OrangeParc.",self.user_name]];
    }
    else{
        //[self.activityDescriptionLabel setText:[NSString stringWithFormat:@"%@ has done something you may be interested.",self.user_name]];
        NSLog(@"ActivityTableViewcell:activity type not found.");
    }
    
    NSURL *imageUrl=[NSURL URLWithString:self.user_pic];
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
}

@end
