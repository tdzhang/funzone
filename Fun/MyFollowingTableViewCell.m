//
//  MyFollowingTableViewCell.m
//  Fun
//
//  Created by Tongda Zhang on 7/25/12.
//
//

#import "MyFollowingTableViewCell.h"

@implementation MyFollowingTableViewCell
@synthesize profileImageView;
@synthesize profileNameLabel;
@synthesize unfollowButton;

@synthesize user_id=_user_id;
@synthesize user_name=_user_name;
@synthesize user_pic=_user_pic;
@synthesize facebook_id=_facebook_id;

@synthesize delegate=_delegate;

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


- (IBAction)ProfileImageClicked:(id)sender {
    [self.delegate startSeeProfileWithUserId:self.user_id];
}




@end
