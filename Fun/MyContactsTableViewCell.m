//
//  MyContactsTableViewCell.m
//  SimpleChoosePage
//
//  Created by Tongda Zhang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyContactsTableViewCell.h"

@implementation MyContactsTableViewCell
@synthesize userName=_userName;
@synthesize userEmail=_userEmail;


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
    if (self.selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }else
    {
        self.accessoryType=UITableViewCellAccessoryNone;
    }
    // Configure the view for the selected state
}

@end
