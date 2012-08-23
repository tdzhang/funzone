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
@synthesize categoryIcon=_categoryIcon;
@synthesize categorySection=_categorySection;
@synthesize numDoItMyself=_numDoItMyself;
@synthesize numDoItMyselfSection=_numDoItMyselfSection;


//reset the fram of a element's block view
-(void) resetFramWith:(CGFloat)position_y{
    self.blockView =[[UIView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_VIEW_X,position_y, EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT)];
}

//generate a explore block element
+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)DIM_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id  withLocationName:(NSString *)locationName withCreatorName:(NSString*)creator_name withCreatorPhoto:(NSString*)creator_photo withCreatorId:(NSString*)creator_id withEventCategory:(NSString *)event_category{
    
    ExploreBlockElement* blockElement=[[ExploreBlockElement alloc] init];
    
    NSString *category_icon_file;
    UIColor *category_color;

    if ([event_category isEqualToString:@"0"]) {
        blockElement.event_category = @"OTHERS";
        category_icon_file = @"other.png";
        category_color = [UIColor colorWithRed:169/255.0 green:169/255.0 blue:169/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"1"]) {
        blockElement.event_category = @"FOOD";
        category_icon_file = @"food.png";
        category_color = [UIColor colorWithRed:134/255.0 green:156/255.0 blue:224/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"2"]) {
        blockElement.event_category = @"MOVIE";
        category_icon_file = @"movie.png";
        category_color = [UIColor colorWithRed:248/255.0 green:110/255.0 blue:116/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"3"]) {
        blockElement.event_category = @"SPORTS";
        category_icon_file = @"sports.png";
        category_color = [UIColor colorWithRed:110/255.0 green:199/255.0 blue:243/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"4"]) {
        blockElement.event_category = @"NIGHTLIFE";
        category_icon_file = @"party.png";
        category_color = [UIColor colorWithRed:241/255.0 green:144/255.0 blue:76/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"5"]) {
        blockElement.event_category = @"OUTDOOR";
        category_icon_file = @"outdoor.png";
        category_color = [UIColor colorWithRed:154/255.0 green:225/255.0 blue:100/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"6"]) {
        blockElement.event_category = @"ENTERTAIN";
        category_icon_file = @"music.png";
        category_color = [UIColor colorWithRed:223/255.0 green:188/255.0 blue:78/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"7"]) {
        blockElement.event_category = @"EVENTS";
        category_icon_file = @"event.png";
        category_color = [UIColor colorWithRed:160/255.0 green:114/255.0 blue:186/255.0 alpha:1];
    } else if ([event_category isEqualToString:@"8"]) {
        blockElement.event_category = @"SHOPPING";
        category_icon_file = @"shopping.png";
        category_color = [UIColor colorWithRed:220/255.0 green:92/255.0 blue:171/255.0 alpha:1];
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
    
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_VIEW_X, position_y, EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT)];
    blockElement.blockView.backgroundColor = [UIColor whiteColor];
    blockElement.blockView.layer.shadowColor = [[UIColor blackColor] CGColor];
    blockElement.blockView.layer.shadowOffset = CGSizeMake(0, 1);
    blockElement.blockView.layer.shadowRadius = 2.0f;
    blockElement.blockView.layer.shadowOpacity = 0.6f;
    blockElement.blockView.layer.cornerRadius = 2;
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
    
    //Category section
    blockElement.categorySection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    blockElement.categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 33, 30)];
    blockElement.categoryIcon.contentMode = UIViewContentModeScaleToFill;
    [blockElement.categoryIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", category_icon_file]]];
    [blockElement.categorySection addSubview:blockElement.categoryIcon];
    
    //blockElement.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_X, blockElement.titleLabel.frame.origin.y-15, 150, 15)];
    blockElement.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 150, 15)];
    blockElement.categoryLabel.text = blockElement.event_category;
    blockElement.categoryLabel.backgroundColor = [UIColor clearColor];
    blockElement.categoryLabel.textColor = [UIColor whiteColor];
    blockElement.categoryLabel.font = [UIFont boldSystemFontOfSize:12];
    [blockElement.categoryLabel setShadowColor:[UIColor blackColor]];
    [blockElement.categoryLabel setShadowOffset:CGSizeMake(0, 1)];
    CGSize expectedWidth1 = [blockElement.event_category sizeWithFont:[UIFont boldSystemFontOfSize:12] forWidth:150 lineBreakMode:UILineBreakModeTailTruncation];
    CGRect newframe = blockElement.categoryLabel.frame;
    newFrame.size.width = expectedWidth1.width;
    blockElement.categoryLabel.frame = newframe;
    [blockElement.categorySection addSubview:blockElement.categoryLabel];
    blockElement.categorySection.frame = CGRectMake(300-expectedWidth1.width-33-10, 50, expectedWidth1.width+33+10, 30);
    blockElement.categorySection.backgroundColor = [UIColor blackColor];
    blockElement.categorySection.alpha = 1;
    //[blockElement.blockView addSubview:blockElement.categorySection];
    
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
    blockElement.numDoItMyselfSection = [[UIView alloc] init];
    blockElement.numDoItMyselfSection.backgroundColor = [UIColor clearColor];
    [blockElement.blockView addSubview:blockElement.numDoItMyselfSection];
    
    UIView *numDoItMyselfBackground = [[UIView alloc] init];
    numDoItMyselfBackground.backgroundColor = [UIColor blackColor];
    numDoItMyselfBackground.layer.cornerRadius = 4;
    [numDoItMyselfBackground setAlpha:0.6];
    [blockElement.numDoItMyselfSection addSubview:numDoItMyselfBackground];
    
    blockElement.numDoItMyself = [[UILabel alloc] initWithFrame:CGRectMake(5, 4, 15, 20)];
    blockElement.numDoItMyself.text = DIM_label;
    [blockElement.numDoItMyself setBackgroundColor:[UIColor clearColor]];
    [blockElement.numDoItMyself setFont:[UIFont boldSystemFontOfSize:20]];
    [blockElement.numDoItMyself setTextColor:[UIColor colorWithRed:1 green:0.8 blue:0 alpha:1]];
    blockElement.numDoItMyself.shadowColor=[UIColor blackColor];
    [blockElement.numDoItMyself setShadowOffset:CGSizeMake(0, 1)];
    [blockElement.numDoItMyself setAlpha:1];
    [blockElement.numDoItMyselfSection addSubview:blockElement.numDoItMyself];
    CGSize expectedWidth = [blockElement.numDoItMyself.text sizeWithFont:[UIFont boldSystemFontOfSize:20] forWidth:100 lineBreakMode:UILineBreakModeClip];
    blockElement.numDoItMyself.frame = CGRectMake(5, 4, expectedWidth.width, 20);
    
    UILabel *numDIMLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(blockElement.numDoItMyself.frame.origin.x+blockElement.numDoItMyself.frame.size.width+5, 2, 45, 15)];
    numDIMLabel1.text = @"people";
    [numDIMLabel1 setTextColor:[UIColor whiteColor]];
    [numDIMLabel1 setFont:[UIFont systemFontOfSize:10]];
    [numDIMLabel1 setBackgroundColor:[UIColor clearColor]];
    [numDIMLabel1 setAlpha:1];
    [blockElement.numDoItMyselfSection addSubview:numDIMLabel1];
    
    UILabel *numDIMLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(blockElement.numDoItMyself.frame.origin.x+blockElement.numDoItMyself.frame.size.width+5, 12, 50, 15)];
    if ([DIM_label isEqualToString:@"0"] || [DIM_label isEqualToString:@"1"]) {
        numDIMLabel2.text = @"wants to try it";
    } else {
        numDIMLabel2.text = @"want to try it";
    }
    [numDIMLabel2 setTextColor:[UIColor whiteColor]];
    [numDIMLabel2 setFont:[UIFont systemFontOfSize:8]];
    [numDIMLabel2 setBackgroundColor:[UIColor clearColor]];
    [numDIMLabel2 setAlpha:1];
    [blockElement.numDoItMyselfSection addSubview:numDIMLabel2];
    
    int total_width = blockElement.numDoItMyself.frame.size.width+10+50+5+10;
    blockElement.numDoItMyselfSection.frame = CGRectMake(310-total_width, EXPLORE_BLOCK_ELEMENT_DIM_Y, blockElement.numDoItMyself.frame.size.width+10+55, EXPLORE_BLOCK_ELEMENT_DIM_HEIGHT);
    numDoItMyselfBackground.frame = CGRectMake(0, 0, blockElement.numDoItMyself.frame.size.width+10+55, EXPLORE_BLOCK_ELEMENT_DIM_HEIGHT);
    
    //set the event_id and shared_event_id
    blockElement.event_id=event_id;
    blockElement.shared_event_id=shared_event_id;
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}


@end
