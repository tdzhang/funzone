//
//  ExploreBlockElement.m
//  Fun
//
//  Created by Tongda Zhang on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ExploreBlockElement.h"

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


#define VIEW_WIDTH 320
#define VIEW_HEIGHT 158 

#define THUMB_X 10
#define THUMB_Y 4
#define THUMB_SIZE 50

#define BACKGROUND_Y 25
#define BACKGROUND_HEIGHT 137

#define TITLE_X 60
#define TITLE_Y 16
#define TITLE_WIDTH 260
#define TITLE_HEIGHT 36
#define TITLE_TEXT_OFFSET 8

#define ICON_SIZE 20
#define JOIN_X 13
#define FAVOR_X 263
#define ICON_Y 130

#define LABEL_WIDTH 24
#define JOIN_LABEL_X 40
#define FAVOR_LABEL_X 289



+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImage:(NSString *)backGroundImageName tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label{

    ExploreBlockElement* blockElement=[[ExploreBlockElement alloc] init];
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(0,position_y, VIEW_WIDTH, VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    //Backgroud Image
    blockElement.backGroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, BACKGROUND_Y, VIEW_WIDTH, BACKGROUND_HEIGHT)];
    blockElement.backGroundImageView.image=[UIImage imageNamed:backGroundImageName];
    [blockElement.blockView addSubview:blockElement.backGroundImageView];
    //Thumbnail Image
    blockElement.thumbNailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(THUMB_X, THUMB_Y, THUMB_SIZE, THUMB_SIZE)];
    blockElement.thumbNailImageView.image=[UIImage imageNamed:backGroundImageName];
    [blockElement.blockView addSubview:blockElement.thumbNailImageView];
    //Title View
    blockElement.titleView = [[UIView alloc] initWithFrame:CGRectMake(TITLE_X, TITLE_Y, TITLE_WIDTH, TITLE_HEIGHT)];
    blockElement.titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.56];
    [blockElement.blockView addSubview:blockElement.titleView];
    //Title Label
    blockElement.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_TEXT_OFFSET, 0, TITLE_WIDTH-2*TITLE_TEXT_OFFSET, TITLE_HEIGHT)];
    blockElement.titleLabel.text = title;
    blockElement.titleLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    blockElement.titleLabel.textColor = [UIColor whiteColor];
    blockElement.titleLabel.font = [UIFont fontWithName:@"Gurmukhi MN" size:14.0];
    [blockElement.titleView addSubview:blockElement.titleLabel];
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
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}


@end
