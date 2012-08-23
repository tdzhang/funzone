//
//  ExploreBlockElement.h
//  Fun
//
//  Created by Tongda Zhang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Cache.h"
#import "GlobalConstant.h"

@interface ExploreBlockElement : NSObject
@property(nonatomic,strong) UIView *blockView;
@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong) UIView *creator;
@property (nonatomic,strong) UIImageView *blockElementHolderView;
@property(nonatomic,strong) UIImageView *backGroundImageView;
@property(nonatomic,strong) UIImageView *thumbNailImageView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *joinImageView;
@property(nonatomic,strong) UILabel *joinLabel;
@property(nonatomic,strong) UIImageView *favorImageView;
@property(nonatomic,strong) UILabel *favorLabel;
@property(nonatomic,strong) NSString *event_id;
@property(nonatomic,strong) NSString *shared_event_id;
@property (nonatomic,strong) UILabel *locationLabel;
@property (nonatomic,strong) NSString *creator_id;
@property (nonatomic,strong) NSString *event_category;
@property (nonatomic,strong) UIView *categorySection;
@property (nonatomic,strong) UILabel *categoryLabel;
@property (nonatomic,strong) UIImageView *categoryIcon;
@property (nonatomic,strong) UILabel *numDoItMyself;
@property (nonatomic,strong) UIView *numDoItMyselfSection;

//used to reset the fram information
-(void) resetFramWith:(CGFloat)position_y;

//generate a explore block element
+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)DIM_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id withLocationName:(NSString *)locationName withCreatorName:(NSString*)creator_name withCreatorPhoto:(NSString*)creator_photo withCreatorId:(NSString*)creator_id withEventCategory:(NSString *)event_category;
@end
