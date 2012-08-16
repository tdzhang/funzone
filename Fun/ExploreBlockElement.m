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
@synthesize blockElementHolderView = _blockElementHolderView;
@synthesize view=_view;
@synthesize creator=_creator;
@synthesize backGroundImageView=_backGroundImageView;
@synthesize thumbNailImageView=_thumbNailImageView;
@synthesize titleLabel=_titleLabel;
@synthesize joinLabel=_joinLabel;
@synthesize joinImageView=_joinImageView;
@synthesize favorImageView=_favorImageView;
@synthesize favorLabel=_favorLabel;
@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;
@synthesize locationLabel=_locationLabel;
@synthesize creator_id=_creator_id;
@synthesize event_category=_event_category;
@synthesize categoryLabel=_categoryLabel;
@synthesize numDoItMyself=_numDoItMyself;


//reset the fram of a element's block view
-(void) resetFramWith:(CGFloat)position_y{
    self.blockView =[[UIView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_VIEW_X,position_y, EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT)];
}

//generate a explore block element
+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)DIM_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id  withLocationName:(NSString *)locationName withCreatorName:(NSString*)creator_name withCreatorPhoto:(NSString*)creator_photo withCreatorId:(NSString*)creator_id withEventCategory:(NSString *)event_category{
    
    ExploreBlockElement* blockElement=[[ExploreBlockElement alloc] init];

    if ([event_category isEqualToString:@"0"]) {
        blockElement.event_category = @"OTHERS";
    } else if ([event_category isEqualToString:@"1"]) {
        blockElement.event_category = @"FOOD";
    } else if ([event_category isEqualToString:@"2"]) {
        blockElement.event_category = @"MOVIE";
    } else if ([event_category isEqualToString:@"3"]) {
        blockElement.event_category = @"SPORTS";
    } else if ([event_category isEqualToString:@"4"]) {
        blockElement.event_category = @"NIGHTLIFE";
    } else if ([event_category isEqualToString:@"5"]) {
        blockElement.event_category = @"OUTDOOR";
    } else if ([event_category isEqualToString:@"6"]) {
        blockElement.event_category = @"ENTERTAINMENT";
    } else if ([event_category isEqualToString:@"7"]) {
        blockElement.event_category = @"EVENTS";
    } else if ([event_category isEqualToString:@"8"]) {
        blockElement.event_category = @"SHOPPING";
    }
    
    //choose the default image when facing others
    NSString *DEFAULT_IMAGE_REPLACEMENT=nil;
    if ([event_category isEqualToString:FOOD]) {
        DEFAULT_IMAGE_REPLACEMENT=FOOD_REPLACEMENT;
    }
    else if([event_category isEqualToString:MOVIE]){
        DEFAULT_IMAGE_REPLACEMENT=MOVIE_REPLACEMENT;
    }
    else if([event_category isEqualToString:SPORTS]){
        DEFAULT_IMAGE_REPLACEMENT=SPORTS_REPLACEMENT;
    }
    else if([event_category isEqualToString:NIGHTLIFE]){
        DEFAULT_IMAGE_REPLACEMENT=NIGHTLIFE_REPLACEMENT;
    }
    else if([event_category isEqualToString:OUTDOOR]){
        DEFAULT_IMAGE_REPLACEMENT=OUTDOOR_REPLACEMENT;
    }
    else if([event_category isEqualToString:ENTERTAIN]){
        DEFAULT_IMAGE_REPLACEMENT=ENTERTAIN_REPLACEMENT;
    }
    else if([event_category isEqualToString:SHOPPING]){
        DEFAULT_IMAGE_REPLACEMENT=SHOPPING_REPLACEMENT;
    }
    else if([event_category isEqualToString:OTHERS]){
        DEFAULT_IMAGE_REPLACEMENT=OTHERS_REPLACEMENT;
    }
    
//    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_VIEW_X, position_y, EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT)];
    blockElement.blockView.backgroundColor = [UIColor whiteColor];
    blockElement.blockView.layer.shadowColor = [[UIColor blackColor] CGColor];
    blockElement.blockView.layer.shadowOffset = CGSizeMake(0, 1);
    blockElement.blockView.layer.shadowRadius = 1.0f;
    blockElement.blockView.layer.shadowOpacity = 0.6f;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:blockElement.blockView.bounds];
    blockElement.blockView.layer.shadowPath = path.CGPath;
    
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    
    //set the creator id
    blockElement.creator_id=creator_id;
    
    //Backgroud Image
    blockElement.backGroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_SUB_VIEW_X, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_Y, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_HEIGHT)];
    [blockElement.backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [blockElement.backGroundImageView setClipsToBounds:YES];
    [blockElement.backGroundImageView setAlpha:1.0];
    [blockElement.blockView addSubview:blockElement.backGroundImageView];
    
    if (![Cache isURLCached:backGroundImageUrl]) {
        //using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: backGroundImageUrl];
            if (imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:backGroundImageUrl withData:imageData];
                        blockElement.backGroundImageView.image=[UIImage imageWithData:imageData];
                    });
                }
            }
            else {
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:backGroundImageUrl withData:imageData];
                        blockElement.backGroundImageView.image=[UIImage imageWithData:imageData];
                });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            blockElement.backGroundImageView.image=[UIImage imageWithData:[Cache getCachedData:backGroundImageUrl]];
        });
    }    
    
    //mask on the backgroud Image
    UIImageView* mask=[[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_MASK_X, EXPLORE_BLOCK_ELEMENT_MASK_Y, EXPLORE_BLOCK_ELEMENT_MASK_WIDTH, EXPLORE_BLOCK_ELEMENT_MASK_HEIGHT)];
    [mask setAlpha:EXPLORE_BLOCK_ELEMENT_MASK_ALPHA];
    [mask setImage:[UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_MASK_IMAGENAME]];
    [mask setContentMode:UIViewContentModeScaleToFill];
    [blockElement.blockView addSubview:mask];
    
    
    //Title Label
    blockElement.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_X, EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_Y, EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_WIDTH, EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT)];
    blockElement.titleLabel.text = title;
    blockElement.titleLabel.backgroundColor = [UIColor clearColor];
    blockElement.titleLabel.textColor = [UIColor whiteColor];
    blockElement.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    blockElement.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    blockElement.titleLabel.numberOfLines = 2;
    [blockElement.titleLabel setShadowColor:[UIColor blackColor]];
    [blockElement.titleLabel setShadowOffset:CGSizeMake(0, 1)]; 
    CGSize maximumLabelSize = CGSizeMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_WIDTH,50);    
    CGSize expectedLabelSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeTailTruncation];
    CGRect newFrame = blockElement.titleLabel.frame;
    newFrame.origin.y -= expectedLabelSize.height - EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT;
    newFrame.size.height = expectedLabelSize.height;
    blockElement.titleLabel.frame = newFrame;
    [blockElement.blockView addSubview:blockElement.titleLabel];
    
    //Category Label
    blockElement.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_X, blockElement.titleLabel.frame.origin.y-15, 150, 15)];
    blockElement.categoryLabel.text = blockElement.event_category;
    blockElement.categoryLabel.backgroundColor = [UIColor clearColor];
    blockElement.categoryLabel.textColor = [UIColor colorWithRed:95/255.0 green:210/255.0 blue:181/255.0 alpha:1];
    blockElement.categoryLabel.font = [UIFont boldSystemFontOfSize:12];
    [blockElement.categoryLabel setShadowColor:[UIColor blackColor]];
    [blockElement.categoryLabel setShadowOffset:CGSizeMake(0, 1)];
    [blockElement.blockView addSubview:blockElement.categoryLabel];
    
    if (![locationName isEqualToString:@""]) {
    //marker image
    UIImageView* marker=[[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_MARKER_X, EXPLORE_BLOCK_ELEMENT_MARKER_Y, EXPLORE_BLOCK_ELEMENT_MARKER_WIDTH, EXPLORE_BLOCK_ELEMENT_MARKER_HEIGHT)];
    [marker setAlpha:EXPLORE_BLOCK_ELEMENT_MARKER_ALPHA];
    [marker setImage:[UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_MARKER_IMAGENAME]];
    [marker setContentMode:UIViewContentModeScaleToFill];
    [blockElement.blockView addSubview:marker];
    
    //location Label
    blockElement.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_X, EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_Y, EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_WIDTH, EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_HEIGHT)];
    blockElement.locationLabel.text = locationName;
    blockElement.locationLabel.backgroundColor = [UIColor clearColor];
    blockElement.locationLabel.textColor = [UIColor lightGrayColor];
    blockElement.locationLabel.shadowColor=[UIColor blackColor];
    [blockElement.locationLabel setShadowOffset:CGSizeMake(0, 1)];
    blockElement.locationLabel.font = [UIFont boldSystemFontOfSize:11.0];
    [blockElement.blockView addSubview:blockElement.locationLabel];
    }
    
    //people want to do this section
    blockElement.numDoItMyself = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_DIM_X, EXPLORE_BLOCK_ELEMENT_DIM_Y, EXPLORE_BLOCK_ELEMENT_DIM_WIDTH, EXPLORE_BLOCK_ELEMENT_DIM_HEIGHT)];
    blockElement.numDoItMyself.text = DIM_label;
    [blockElement.numDoItMyself setFont:[UIFont boldSystemFontOfSize:14]];
    [blockElement.numDoItMyself setTextColor:[UIColor colorWithRed:100/255.0 green:83/255.0 blue:0 alpha:1]];
    blockElement.numDoItMyself.shadowColor=[UIColor blackColor];
    [blockElement.numDoItMyself setShadowOffset:CGSizeMake(0, 1)];
    [blockElement.blockView addSubview:blockElement.numDoItMyself];
    
    //set the event_id and shared_event_id
    blockElement.event_id=event_id;
    blockElement.shared_event_id=shared_event_id;
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}


@end
