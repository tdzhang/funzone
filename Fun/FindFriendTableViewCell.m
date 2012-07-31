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

@synthesize actionCategory=_actionCategory;

@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize fb_id=_fb_id;
@synthesize registerd=_registerd;
@synthesize user_id=_user_id;
@synthesize followed=_followed;

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

-(void)resetWithSearchedFriend:(SearchedFriend *)friend{
    //get the user information in to the cell, used for the "followed/unfollow/invite button"
    self.user_id=friend.user_id;
    self.user_name=friend.user_name;
    self.user_pic=friend.user_pic;
    self.fb_id=friend.fb_id;
    self.registerd=friend.registerd;
    self.followed=friend.followed;
    
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
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
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

-(void)resetWithTopFriend:(SearchedFriend *)friend{
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
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
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
    }
    else{
        [self.actionButton setTitle:@"Follow" forState:UIControlStateNormal];
    }

}

- (IBAction)actionButtonClicke:(id)sender {
    if ([self.actionCategory isEqualToString:@"follow"]) {
        ;
    }
    else if ([self.actionCategory isEqualToString:@"unfollow"]) {
        ;
    }
    else if ([self.actionCategory isEqualToString:@"invite"]) {
        ;
    }
}

@end
