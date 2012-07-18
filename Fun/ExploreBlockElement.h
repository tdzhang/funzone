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

@interface ExploreBlockElement : NSObject
@property(nonatomic,strong) UIView *blockView;
@property(nonatomic,strong) UIImageView *backGroundImageView;
@property(nonatomic,strong) UIImageView *thumbNailImageView;
@property(nonatomic,strong) UIView *titleView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UIImageView *joinImageView;
@property(nonatomic,strong) UILabel *joinLabel;
@property(nonatomic,strong) UIImageView *favorImageView;
@property(nonatomic,strong) UILabel *favorLabel;
@property(nonatomic,strong) NSString *event_id;
@property(nonatomic,strong) NSString *shared_event_id;

//used to reset the fram information
-(void) resetFramWith:(CGFloat)position_y;

+ (void)setUpStyle:(CALayer*)layer;

+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id;
@end





 