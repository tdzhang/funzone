//
//  ActivityTableViewCell.h
//  OrangeParc
//
//  Created by Tongda Zhang on 7/31/12.
//
//

#import <UIKit/UIKit.h>
#import "activityElementObject.h"
#import "GlobalConstant.h"
#import "Cache.h"

@interface ActivityTableViewCell : UITableViewCell
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSString* user_id;
@property (nonatomic,strong) NSString* user_name;
@property (nonatomic,strong) NSString* user_pic;
@property (nonatomic,strong) NSString* event_id;
@property (nonatomic,strong) NSString* shared_event_id;

@property (nonatomic,strong) NSString* event_name;
@property (nonatomic,strong) NSString* message;

@property (weak, nonatomic) IBOutlet UIImageView *userPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;

-(void)resetWithConversationActivityObject:(activityElementObject*)element;
-(void)resetWithActivityObject:(activityElementObject*)element;
@end
