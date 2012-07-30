//
//  ProfileEventElement.h
//  Fun
//
//  Created by Tongda Zhang on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cache.h"
#import "GlobalConstant.h"

@interface ProfileEventElement : NSObject
@property(nonatomic,strong)UIView *blockView;
@property(nonatomic,strong)UIImageView *blockHolderView;
@property(nonatomic,strong)UILabel *eventTitleLabel;
@property(nonatomic,strong)UILabel *distanceLabel;
@property(nonatomic,strong)UIImageView *eventImageView;
@property(nonatomic,strong)UIImageView *heartImageView;
@property(nonatomic,strong)UILabel *heartNumberLabel;

@property(nonatomic,strong)NSString *event_id;
@property(nonatomic,strong)NSString *shared_event_id;


+(ProfileEventElement *)initialWithPositionY:(CGFloat)position_y eventImageURL:(NSString *)eventImageURL tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id withLocationName:(NSString *)locationName withDistance: (float)distance;
@end
