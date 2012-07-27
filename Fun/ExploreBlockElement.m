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

//reset the fram of a element's block view
-(void) resetFramWith:(CGFloat)position_y{
    self.blockView =[[UIView alloc] initWithFrame:CGRectMake(0,position_y, EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT)];
}

//generate a explore block element
+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id  withLocationName:(NSString *)locationName withCreatorName:(NSString*)creator_name withCreatorPhoto:(NSString*)creator_photo withCreatorId:(NSString*)creator_id{
    
    
    ExploreBlockElement* blockElement=[[ExploreBlockElement alloc] init];
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(0,position_y, EXPLORE_BLOCK_ELEMENT_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    
    //set the creator id
    blockElement.creator_id=creator_id;
    
    //create View
    blockElement.view=[[UIView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_SUB_VIEW_X,EXPLORE_BLOCK_ELEMENT_SUB_VIEW_Y, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_HEIGHT)];
    [blockElement.blockView addSubview:blockElement.view];
    
    //Backgroud Image
    blockElement.backGroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_SUB_VIEW_HEIGHT)];
    [blockElement.backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [blockElement.backGroundImageView setClipsToBounds:YES];
    [blockElement.backGroundImageView setAlpha:1.0];
    [blockElement.view addSubview:blockElement.backGroundImageView];
    
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
    [blockElement.view addSubview:mask];
    
    
    //Title Label
    blockElement.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_X, EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_Y, EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_WIDTH, EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT)];
    blockElement.titleLabel.text = title;
    blockElement.titleLabel.backgroundColor = [UIColor clearColor];
    blockElement.titleLabel.textColor = [UIColor whiteColor];
    blockElement.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    blockElement.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    blockElement.titleLabel.numberOfLines = 3;
    [blockElement.titleLabel setShadowColor:[UIColor blackColor]];
    [blockElement.titleLabel setShadowOffset:CGSizeMake(0, 1)]; 
    CGSize maximumLabelSize = CGSizeMake(EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_WIDTH,9999);    
    CGSize expectedLabelSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:15.0] constrainedToSize:maximumLabelSize lineBreakMode:UILineBreakModeWordWrap];
    CGRect newFrame = blockElement.titleLabel.frame;
    newFrame.origin.y -= expectedLabelSize.height - EXPLORE_BLOCK_ELEMENT_TITLE_TEXT_HEIGHT;
    newFrame.size.height = expectedLabelSize.height;
    blockElement.titleLabel.frame = newFrame;
    [blockElement.view addSubview:blockElement.titleLabel];
    
    //marker image
//    UIImageView* marker=[[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_MARKER_X, EXPLORE_BLOCK_ELEMENT_MARKER_Y, EXPLORE_BLOCK_ELEMENT_MARKER_WIDTH, EXPLORE_BLOCK_ELEMENT_MARKER_HEIGHT)];
//    [marker setAlpha:EXPLORE_BLOCK_ELEMENT_MARKER_ALPHA];
//    [marker setImage:[UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_MARKER_IMAGENAME]];
//    [marker setContentMode:UIViewContentModeScaleToFill];
//    [blockElement.view addSubview:marker];
    
    //location Label
//    blockElement.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_X, EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_Y, EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_WIDTH, EXPLORE_BLOCK_ELEMENT_LOCATION_LABEL_HEIGHT)];
//    blockElement.locationLabel.text = locationName;
//    blockElement.locationLabel.backgroundColor = [UIColor clearColor];
//    blockElement.locationLabel.textColor = [UIColor whiteColor];
//    blockElement.locationLabel.shadowColor=[UIColor darkTextColor];
//    blockElement.locationLabel.font = [UIFont boldSystemFontOfSize:12.0];
//    [blockElement.view addSubview:blockElement.locationLabel];
    
    //event view
    blockElement.creator = [[UIView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_EVENTVIEW_X,EXPLORE_BLOCK_ELEMENT_EVENTVIEW_Y, EXPLORE_BLOCK_ELEMENT_EVENTVIEW_WIDTH, EXPLORE_BLOCK_ELEMENT_EVENTVIEW_HEIGHT)];
    [blockElement.creator setBackgroundColor:[UIColor whiteColor]];
    [blockElement.blockView addSubview:blockElement.creator];
    
    
    //Thumbnail Image
    blockElement.thumbNailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_THUMBNAIL_X, EXPLORE_BLOCK_ELEMENT_THUMBNAIL_Y, EXPLORE_BLOCK_ELEMENT_THUMBNAIL_SIZE, EXPLORE_BLOCK_ELEMENT_THUMBNAIL_SIZE)];
    
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_NAME_LABEL_X, EXPLORE_BLOCK_ELEMENT_NAME_LABEL_Y, EXPLORE_BLOCK_ELEMENT_NAME_LABEL_WIDTH, EXPLORE_BLOCK_ELEMENT_NAME_LABEL_HEIGHT)];
    nameLabel.text = creator_name;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:nameLabel];
    
    //Joined Image
    blockElement.joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_INTEREST_X, EXPLORE_BLOCK_ELEMENT_INTEREST_Y, EXPLORE_BLOCK_ELEMENT_INTEREST_SIZE, EXPLORE_BLOCK_ELEMENT_INTEREST_SIZE)];
    blockElement.joinImageView.image = [UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_INTEREST_IMAGE];
    [blockElement.creator addSubview:blockElement.joinImageView];
    
    //Joined number label
    blockElement.joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_X, EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_Y, EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_WIDTH, EXPLORE_BLOCK_ELEMENT_INTEREST_LABEL_HEIGHT)];
    blockElement.joinLabel.text = join_label; /*****TODO*****/
    blockElement.joinLabel.backgroundColor = [UIColor clearColor];
    blockElement.joinLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:blockElement.joinLabel];
    
    //Favored Image
    blockElement.favorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_REPIN_X, EXPLORE_BLOCK_ELEMENT_REPIN_Y, EXPLORE_BLOCK_ELEMENT_REPIN_SIZE, EXPLORE_BLOCK_ELEMENT_REPIN_SIZE)];
    blockElement.favorImageView.image = [UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_REPIN_IMAGE];
    [blockElement.creator addSubview:blockElement.favorImageView];
    
    //Favored Label
    blockElement.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_X, EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_Y , EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_WIDTH, EXPLORE_BLOCK_ELEMENT_REPIN_LABEL_HEIGHT)];
    blockElement.favorLabel.text = favor_label; /*****TODO*****/
    blockElement.favorLabel.backgroundColor = [UIColor clearColor];   
    blockElement.favorLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:blockElement.favorLabel];
    
    //add seperator
    UIImageView* seperator=[[UIImageView alloc] initWithFrame:CGRectMake(EXPLORE_BLOCK_ELEMENT_SEPERATOR_X, EXPLORE_BLOCK_ELEMENT_SEPERATOR_Y, EXPLORE_BLOCK_ELEMENT_SEPERATOR_WIDTH, EXPLORE_BLOCK_ELEMENT_SEPERATOR_HEIGHT)];
    [seperator setAlpha:1];
    [seperator setImage:[UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_SEPERATOR_IMAGE]];
    [seperator setContentMode:UIViewContentModeScaleToFill];
    [blockElement.blockView addSubview:seperator];

    
    //set the event_id and shared_event_id
    blockElement.event_id=event_id;
    blockElement.shared_event_id=shared_event_id;
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}


@end
