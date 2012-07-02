//
//  ImageTableViewCell.m
//  GoogleImageAPIpractice
//
//  Created by Tongda Zhang on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageTableViewCell.h"

@implementation ImageTableViewCell
@synthesize imageViewContent;
@synthesize labelTitle;


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
