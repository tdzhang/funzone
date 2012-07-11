//
//  ExploreBlockElement.h
//  Fun
//
//  Created by Tongda Zhang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


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

+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImage:(NSString *)backGroundImageName tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label;
@end





 