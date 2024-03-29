//
//  FeedBlockElement.m
//  OrangeParc
//
//  Created by Yizhou Zhu on 8/14/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "FeedBlockElement.h"
#import "Cache.h"

@implementation FeedBlockElement
@synthesize blockView=_blockView;
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
@synthesize categorySection=_categorySection;
@synthesize categoryIcon=_categoryIcon;
@synthesize categoryLabel=_categoryLabel;


//reset the fram of a element's block view
-(void) resetFramWith:(CGFloat)position_y{
    self.blockView =[[UIView alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_VIEW_X,position_y, FEED_BLOCK_ELEMENT_VIEW_WIDTH, FEED_BLOCK_ELEMENT_VIEW_HEIGHT)];
}

//generate a explore block element
+(FeedBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id  withLocationName:(NSString *)locationName withCreatorName:(NSString*)creator_name withCreatorPhoto:(NSString*)creator_photo withCreatorId:(NSString*)creator_id withEventCategory:(NSString *)event_category{
    
    FeedBlockElement* blockElement=[[FeedBlockElement alloc] init];
    
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
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_VIEW_X, position_y, FEED_BLOCK_ELEMENT_VIEW_WIDTH, FEED_BLOCK_ELEMENT_VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView setBackgroundColor:[UIColor whiteColor]];
    [blockElement.blockView addGestureRecognizer:tapGR];
    blockElement.blockView.layer.shadowColor = [[UIColor blackColor] CGColor];
    blockElement.blockView.layer.shadowOffset = CGSizeMake(0, 1);
    blockElement.blockView.layer.shadowRadius = 2.0f;
    blockElement.blockView.layer.shadowOpacity = 0.6f;
    blockElement.blockView.layer.cornerRadius = 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:blockElement.blockView.bounds];
    blockElement.blockView.layer.shadowPath = path.CGPath;
    
    //set the creator id
    blockElement.creator_id=creator_id;

    //Backgroud Image
    blockElement.backGroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 300, 120)];
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
    UIImageView* mask=[[UIImageView alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_MASK_X, FEED_BLOCK_ELEMENT_MASK_Y, FEED_BLOCK_ELEMENT_MASK_WIDTH, FEED_BLOCK_ELEMENT_MASK_HEIGHT)];
    [mask setAlpha:FEED_BLOCK_ELEMENT_MASK_ALPHA];
    [mask setImage:[UIImage imageNamed:FEED_BLOCK_ELEMENT_MASK_IMAGENAME]];
    [mask setContentMode:UIViewContentModeScaleToFill];
    [blockElement.blockView addSubview:mask];
    
    
    //Title Label
    blockElement.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_TITLE_TEXT_X, FEED_BLOCK_ELEMENT_TITLE_TEXT_Y, FEED_BLOCK_ELEMENT_TITLE_TEXT_WIDTH, FEED_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT)];
    blockElement.titleLabel.text = title;
    blockElement.titleLabel.backgroundColor = [UIColor clearColor];
    blockElement.titleLabel.textColor = [UIColor whiteColor];
    blockElement.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    blockElement.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    blockElement.titleLabel.numberOfLines = 2;
    [blockElement.titleLabel setShadowColor:[UIColor blackColor]];
    [blockElement.titleLabel setShadowOffset:CGSizeMake(0, 1)]; 
    CGSize maximumLabelSize = CGSizeMake(FEED_BLOCK_ELEMENT_TITLE_TEXT_WIDTH,50);    
    CGSize expectedLabelSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeTailTruncation];
    CGRect newFrame = blockElement.titleLabel.frame;
    newFrame.origin.y -= expectedLabelSize.height - FEED_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT;
    newFrame.size.height = expectedLabelSize.height;
    blockElement.titleLabel.frame = newFrame;
    [blockElement.blockView addSubview:blockElement.titleLabel];
    
    //Category Label
//    blockElement.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_TITLE_TEXT_X, blockElement.titleLabel.frame.origin.y-15, 150, 15)];
//    blockElement.categoryLabel.text = blockElement.event_category;
//    blockElement.categoryLabel.backgroundColor = [UIColor clearColor];
//    blockElement.categoryLabel.textColor = [UIColor colorWithRed:95/255.0 green:210/255.0 blue:181/255.0 alpha:1];
//    blockElement.categoryLabel.font = [UIFont boldSystemFontOfSize:12];
//    [blockElement.categoryLabel setShadowColor:[UIColor blackColor]];
//    [blockElement.categoryLabel setShadowOffset:CGSizeMake(0, 1)];
//    [blockElement.blockView addSubview:blockElement.categoryLabel];
    
    //Category section
    blockElement.categorySection = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    
    UIView *categorySectionBackground = [[UIView alloc] init];
    categorySectionBackground.backgroundColor = [UIColor blackColor];
    categorySectionBackground.layer.cornerRadius = 4;
    [categorySectionBackground setAlpha:0.6];
    [blockElement.categorySection addSubview:categorySectionBackground];
    
    blockElement.categoryIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 0, 33, 30)];
    blockElement.categoryIcon.contentMode = UIViewContentModeScaleToFill;
    [blockElement.categoryIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", category_icon_file]]];
    [blockElement.categorySection addSubview:blockElement.categoryIcon];

    //blockElement.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_X, blockElement.titleLabel.frame.origin.y-15, 150, 15)];
    blockElement.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 150, 15)];
    blockElement.categoryLabel.text = blockElement.event_category;
    blockElement.categoryLabel.backgroundColor = [UIColor clearColor];
    blockElement.categoryLabel.textColor = [UIColor whiteColor];
    blockElement.categoryLabel.font = [UIFont boldSystemFontOfSize:10];
    [blockElement.categoryLabel setShadowColor:[UIColor blackColor]];
    [blockElement.categoryLabel setShadowOffset:CGSizeMake(0, 1)];
    CGSize expectedWidth1 = [blockElement.event_category sizeWithFont:[UIFont boldSystemFontOfSize:12] forWidth:150 lineBreakMode:UILineBreakModeTailTruncation];
    CGRect newframe = blockElement.categoryLabel.frame;
    newFrame.size.width = expectedWidth1.width;
    blockElement.categoryLabel.frame = newframe;
    [blockElement.categorySection addSubview:blockElement.categoryLabel];
    blockElement.categorySection.frame = CGRectMake(300-expectedWidth1.width-33, 10, expectedWidth1.width+33, 30);
    categorySectionBackground.frame = CGRectMake(0, 0, expectedWidth1.width+33, 30);
    blockElement.categorySection.backgroundColor = [UIColor clearColor];
    blockElement.categorySection.alpha = 1;
    [blockElement.blockView addSubview:blockElement.categorySection];
    
    //creator view
    blockElement.creator = [[UIView alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_EVENTVIEW_X,FEED_BLOCK_ELEMENT_EVENTVIEW_Y, FEED_BLOCK_ELEMENT_EVENTVIEW_WIDTH, FEED_BLOCK_ELEMENT_EVENTVIEW_HEIGHT)];
    [blockElement.creator setBackgroundColor:[UIColor clearColor]];
    [blockElement.blockView addSubview:blockElement.creator];
    
    
    //Thumbnail Image
    blockElement.thumbNailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_THUMBNAIL_X, FEED_BLOCK_ELEMENT_THUMBNAIL_Y, FEED_BLOCK_ELEMENT_THUMBNAIL_SIZE, FEED_BLOCK_ELEMENT_THUMBNAIL_SIZE)];
    
    //get the Thumbnail image from cache
    NSURL *url=[NSURL URLWithString:creator_photo];
    if (![Cache isURLCached:url]) {
        //if not cached, using high priority queue to fetch the image
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0),^{  
            //get the image data
            NSData * imageData = nil;
            imageData = [[NSData alloc] initWithContentsOfURL: url];
            
            if ( imageData == nil ){
                //if the image data is nil, the image url is not reachable. using a default image to replace that
                //NSLog(@"downloaded %@ error, using a default image",url);
                UIImage *image=[UIImage imageNamed:DEFAULT_IMAGE_REPLACEMENT];
                imageData=UIImagePNGRepresentation(image);
                
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:url withData:imageData];
                        //refresh the whole view
                        blockElement.thumbNailImageView.image=[UIImage imageWithData:imageData];
                        [blockElement.creator addSubview:blockElement.thumbNailImageView];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:url withData:imageData];
                        blockElement.thumbNailImageView.image=[UIImage imageWithData:imageData];
                        [blockElement.creator addSubview:blockElement.thumbNailImageView];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            blockElement.thumbNailImageView.image=[UIImage imageWithData:[Cache getCachedData:url]];
            [blockElement.creator addSubview:blockElement.thumbNailImageView];
        });
    }
    
    //name label
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_NAME_LABEL_X, FEED_BLOCK_ELEMENT_NAME_LABEL_Y, FEED_BLOCK_ELEMENT_NAME_LABEL_WIDTH, FEED_BLOCK_ELEMENT_NAME_LABEL_HEIGHT)];
    nameLabel.text = creator_name;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:nameLabel];
    
    //Joined number label, do it myself
    blockElement.joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_INTEREST_LABEL_X, FEED_BLOCK_ELEMENT_INTEREST_LABEL_Y, FEED_BLOCK_ELEMENT_INTEREST_LABEL_WIDTH, FEED_BLOCK_ELEMENT_INTEREST_LABEL_HEIGHT)];
    blockElement.joinLabel.text = join_label;
    blockElement.joinLabel.backgroundColor = [UIColor clearColor];
    blockElement.joinLabel.font = [UIFont boldSystemFontOfSize:12.0];
    CGSize expectedWidth2 = [join_label sizeWithFont:[UIFont boldSystemFontOfSize:12] forWidth:100 lineBreakMode:UILineBreakModeClip];
    CGRect newFrame1 = blockElement.joinLabel.frame;
    newFrame1.origin.x = 295 - expectedWidth2.width;
    newFrame1.size.width = expectedWidth2.width;
    blockElement.joinLabel.frame = newFrame1;
    [blockElement.creator addSubview:blockElement.joinLabel];
    
    //Joined Image
    blockElement.joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(blockElement.joinLabel.frame.origin.x - 5 - FEED_BLOCK_ELEMENT_INTEREST_SIZE, FEED_BLOCK_ELEMENT_INTEREST_Y, FEED_BLOCK_ELEMENT_INTEREST_SIZE, FEED_BLOCK_ELEMENT_INTEREST_SIZE)];
    blockElement.joinImageView.image = [UIImage imageNamed:FEED_BLOCK_ELEMENT_INTEREST_IMAGE];
    [blockElement.creator addSubview:blockElement.joinImageView];
    
    //Favored Label,likes
    blockElement.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(FEED_BLOCK_ELEMENT_REPIN_LABEL_X, FEED_BLOCK_ELEMENT_REPIN_LABEL_Y , FEED_BLOCK_ELEMENT_REPIN_LABEL_WIDTH, FEED_BLOCK_ELEMENT_REPIN_LABEL_HEIGHT)];
    blockElement.favorLabel.text = favor_label;
    blockElement.favorLabel.backgroundColor = [UIColor clearColor];   
    blockElement.favorLabel.font = [UIFont boldSystemFontOfSize:12.0];
    CGSize expectedWidth3 = [favor_label sizeWithFont:[UIFont boldSystemFontOfSize:12] forWidth:100 lineBreakMode:UILineBreakModeClip];
    CGRect newFrame2 = blockElement.favorLabel.frame;
    newFrame2.origin.x = blockElement.joinImageView.frame.origin.x - 5 - expectedWidth3.width;
    newFrame2.size.width = expectedWidth3.width;
    blockElement.favorLabel.frame = newFrame2;
    [blockElement.creator addSubview:blockElement.favorLabel];
    
    //Favored Image
    blockElement.favorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(blockElement.favorLabel.frame.origin.x-5-FEED_BLOCK_ELEMENT_REPIN_SIZE, FEED_BLOCK_ELEMENT_REPIN_Y, FEED_BLOCK_ELEMENT_REPIN_SIZE, FEED_BLOCK_ELEMENT_REPIN_SIZE)];
    blockElement.favorImageView.image = [UIImage imageNamed:FEED_BLOCK_ELEMENT_REPIN_IMAGE];
    [blockElement.creator addSubview:blockElement.favorImageView];
    
    //set the event_id and shared_event_id
    blockElement.event_id=event_id;
    blockElement.shared_event_id=shared_event_id;
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}
@end

