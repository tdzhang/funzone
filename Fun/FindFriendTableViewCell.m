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
        }
        else{
            [self.actionButton setTitle:@"Follow" forState:UIControlStateNormal];
        }
    }
    else{
        [self.actionButton setTitle:@"Invite" forState:UIControlStateNormal];
    }
}

@end
