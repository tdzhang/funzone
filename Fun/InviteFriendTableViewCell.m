//
//  InviteFriendTableViewCell.m
//  OrangeParc
//
//  Created by Tongda Zhang on 8/5/12.
//
//

#import "InviteFriendTableViewCell.h"

@implementation InviteFriendTableViewCell
@synthesize user_profile_imageview;
@synthesize user_name_label;

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

@end
