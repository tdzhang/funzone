//
//  movieAutoCCell.h
//  Fun
//
//  Created by Tongda Zhang on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface movieAutoCCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbNailImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelYear;
@property (weak, nonatomic) IBOutlet UILabel *labelRating;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;

@end
