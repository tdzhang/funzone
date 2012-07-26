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
