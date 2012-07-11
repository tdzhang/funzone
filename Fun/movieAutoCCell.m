//
//  movieAutoCCell.m
//  Fun
//
//  Created by Tongda Zhang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "movieAutoCCell.h"

@implementation movieAutoCCell
@synthesize thumbNailImageView;
@synthesize labelTitle;
@synthesize labelYear;
@synthesize labelRating;
@synthesize labelScore;

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
