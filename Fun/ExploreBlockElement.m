//
//  ExploreBlockElement.m
//  Fun
//
//  Created by Tongda Zhang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExploreBlockElement.h"
#import "Cache.h"

@implementation ExploreBlockElement
@synthesize blockView=_blockView;
@synthesize backGroundImageView=_backGroundImageView;
@synthesize thumbNailImageView=_thumbNailImageView;
@synthesize titleView=_titleView;
@synthesize titleLabel=_titleLabel;
@synthesize joinLabel=_joinLabel;
@synthesize joinImageView=_joinImageView;
@synthesize favorImageView=_favorImageView;
@synthesize favorLabel=_favorLabel;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;


#define VIEW_WIDTH 300
#define VIEW_HEIGHT 125 

#define THUMB_X 8
#define THUMB_Y 9
#define THUMB_SIZE 37

#define BACKGROUND_Y 51
#define BACKGROUND_HEIGHT 74

#define TITLE_X 0
#define TITLE_Y 0
#define TITLE_WIDTH 300
#define TITLE_HEIGHT 53
#define TITLE_TEXT_OFFSET 8

#define TITLE_TEXT_X 58
#define TITLE_TEXT_Y 7 
#define TITLE_TEXT_WIDTH 227
#define TITLE_TEXT_HEIGHT 24


#define ICON_SIZE 20
#define JOIN_X 13
#define FAVOR_X 230
#define ICON_Y 100

#define LABEL_WIDTH 24
#define JOIN_LABEL_X 40
#define FAVOR_LABEL_X 255

-(void) resetFramWith:(CGFloat)position_y{
    self.blockView =[[UIView alloc] initWithFrame:CGRectMake(0,position_y, VIEW_WIDTH, VIEW_HEIGHT)];
}

+ (void)setUpStyle:(CALayer*)layer {
    layer.cornerRadius = 5;
    layer.masksToBounds = YES;
    layer.borderWidth = .2;
    layer.borderColor = [[UIColor lightGrayColor] CGColor];
    layer.shadowColor = [[UIColor lightGrayColor] CGColor];
    layer.shadowOffset = CGSizeMake(2.f, 3.f);
}

+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id{

    //get the backgroud image from the cache
    UIImage *backGroundImage = nil;
    if ([Cache isURLCached:backGroundImageUrl]) {
        backGroundImage = [UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]];
    }
    else {
        backGroundImage = [UIImage imageNamed:@"monterey.jpg"];
    }
    
    
    ExploreBlockElement* blockElement=[[ExploreBlockElement alloc] init];
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(10,position_y, VIEW_WIDTH, VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    
    //Backgroud Image
    blockElement.backGroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, BACKGROUND_Y, VIEW_WIDTH, BACKGROUND_HEIGHT)];
    blockElement.backGroundImageView.image=[backGroundImage copy];
    [blockElement.backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [blockElement.backGroundImageView setClipsToBounds:YES];
    
    [blockElement.blockView addSubview:blockElement.backGroundImageView];
    
    //Title View
    blockElement.titleView = [[UIView alloc] initWithFrame:CGRectMake(TITLE_X, TITLE_Y, TITLE_WIDTH, TITLE_HEIGHT)];
    blockElement.titleView.backgroundColor = [UIColor colorWithRed:0.3 green:1 blue:0.8 alpha:1.0];
    [blockElement.blockView addSubview:blockElement.titleView];
    
    //Title Label
    blockElement.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_TEXT_X, TITLE_TEXT_Y, TITLE_TEXT_WIDTH, TITLE_TEXT_HEIGHT)];
    blockElement.titleLabel.text = title;
    blockElement.titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    blockElement.titleLabel.textColor = [UIColor blackColor];
    blockElement.titleLabel.font = [UIFont fontWithName:@"Gurmukhi MN" size:14.0];
    [blockElement.titleView addSubview:blockElement.titleLabel];
    
    //Thumbnail Image
    blockElement.thumbNailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(THUMB_X, THUMB_Y, THUMB_SIZE, THUMB_SIZE)];
    blockElement.thumbNailImageView.image=[backGroundImage copy];
    [blockElement.blockView addSubview:blockElement.thumbNailImageView];
    //Joined Image
    blockElement.joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(JOIN_X, ICON_Y, ICON_SIZE, ICON_SIZE)];
    blockElement.joinImageView.image = [UIImage imageNamed:@"join.png"];
    [blockElement.blockView addSubview:blockElement.joinImageView];
    //Joined number label
    blockElement.joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(JOIN_LABEL_X, ICON_Y, LABEL_WIDTH, ICON_SIZE)];
    blockElement.joinLabel.text = join_label; /*****TODO*****/
    blockElement.joinLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    blockElement.joinLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    blockElement.joinLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [blockElement.blockView addSubview:blockElement.joinLabel];
    //Favored Image
    blockElement.favorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(FAVOR_X, ICON_Y, ICON_SIZE, ICON_SIZE)];
    blockElement.favorImageView.image = [UIImage imageNamed:@"heart-white.png"];
    [blockElement.blockView addSubview:blockElement.favorImageView];
    
    //Favored Label
    blockElement.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(FAVOR_LABEL_X, ICON_Y , LABEL_WIDTH, ICON_SIZE)];
    blockElement.favorLabel.text = favor_label; /*****TODO*****/
    blockElement.favorLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    blockElement.favorLabel.textColor = [UIColor colorWithWhite:1 alpha:1.0];
    blockElement.favorLabel.font = [UIFont boldSystemFontOfSize:13.0];
    [blockElement.blockView addSubview:blockElement.favorLabel];
    
    //add some style of the views
    [ExploreBlockElement setUpStyle:blockElement.blockView.layer];
    [ExploreBlockElement setUpStyle:blockElement.titleView.layer];
    
    //set the event_id and shared_event_id
    blockElement.event_id=event_id;
    blockElement.shared_event_id=shared_event_id;
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}


@end
