//
//  ActivityTableViewCell.h
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import <UIKit/UIKit.h>

@interface ActivityTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;

@end
