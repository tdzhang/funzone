//
//  ImageTableViewCell.h
//  GoogleImageAPIpractice
//
//  Created by Tongda Zhang on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContent;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;

@end
