//
//  ProfileEventElement.m
//  Fun
//
//  Created by Tongda Zhang on 7/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileEventElement.h"

@implementation ProfileEventElement
@synthesize blockView=_blockView;
@synthesize blockHolderView=_blockHolderView;
@synthesize eventTitleLabel=_eventTitleLabel;
@synthesize distanceLabel=_distanceLabel;
@synthesize eventImageView=_eventImageView;
@synthesize heartImageView=_heartImageView;
@synthesize heartNumberLabel=_heartNumberLabel;

@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;

+(ProfileEventElement *)initialWithPositionY:(int)index eventImageURL:(NSString *)eventImageURL tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id withLocationName:(NSString *)locationName withDistance:(float)distance withCategory:(NSString *)event_category{
    
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
    else if(!event_category){
        DEFAULT_IMAGE_REPLACEMENT=NILL_REPLACEMENT;
    }

    ProfileEventElement* blockElement=[[ProfileEventElement alloc] init];
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(5 + 155*(index%2),(index/2)*PROFILE_ELEMENT_VIEW_HEIGHT, PROFILE_ELEMENT_VIEW_WIDTH, PROFILE_ELEMENT_VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    
    //set event_id and shared_event_id
    blockElement.event_id = event_id;
    blockElement.shared_event_id=shared_event_id;
    
    //set block view holder
    blockElement.blockHolderView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"form.png"]];
    [blockElement.blockHolderView setFrame:CGRectInset(blockElement.blockView.bounds, 5, 5)];
    [blockElement.blockView addSubview:blockElement.blockHolderView];
    
    //Event Image
    blockElement.eventImageView=[[UIImageView alloc] initWithFrame:CGRectMake(PROFILE_ELEMENT_EVENT_IMAGE_X, PROFILE_ELEMENT_EVENT_IMAGE_Y, PROFILE_ELEMENT_EVENT_IMAGE_WIDTH, PROFILE_ELEMENT_EVENT_IMAGE_HEIGHT)];
    [blockElement.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
    [blockElement.eventImageView setClipsToBounds:YES];
    [blockElement.blockHolderView addSubview:blockElement.eventImageView];
    ////////////////SET THE IMAGE HERE
    //get the image from cache
    NSURL *url=[NSURL URLWithString:eventImageURL];
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
                        blockElement.eventImageView.image=[UIImage imageWithData:imageData];
                        [blockElement.blockHolderView addSubview:blockElement.eventImageView];
                    });
                }
            }
            else {
                //else, the image date getting finished, directlhy put it in the cache, and then reload the table view data.
                //NSLog(@"downloaded %@",url);
                if(imageData){
                    dispatch_async( dispatch_get_main_queue(),^{
                        [Cache addDataToCache:url withData:imageData];
                        blockElement.eventImageView.image=[UIImage imageWithData:imageData];
                        [blockElement.blockHolderView addSubview:blockElement.eventImageView];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            blockElement.eventImageView.image=[UIImage imageWithData:[Cache getCachedData:url]];
            [blockElement.blockHolderView addSubview:blockElement.eventImageView];
        });
    }
    
    
    //add event title
    blockElement.eventTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 95, 135, 35)];
    blockElement.eventTitleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    blockElement.eventTitleLabel.numberOfLines = 2;
    [blockElement.eventTitleLabel setText:title];
    [blockElement.eventTitleLabel setFont:[UIFont boldSystemFontOfSize:14]];
//    CGSize maximumLabelSize1 = CGSizeMake(135,9999);
//    CGSize expectedLabelSize1 = [title sizeWithFont:[UIFont boldSystemFontOfSize:12] constrainedToSize:maximumLabelSize1 lineBreakMode:UILineBreakModeWordWrap];
//    CGSize expectedWidth1 = [title sizeWithFont:[UIFont boldSystemFontOfSize:12] forWidth:135 lineBreakMode:UILineBreakModeWordWrap];
//    CGRect newFrame1 = blockElement.eventTitleLabel.frame;
//    newFrame1.size.height = (expectedLabelSize1.height > 35)?35:expectedLabelSize1.height;
//    newFrame1.size.width = expectedWidth1.width;
//    blockElement.eventTitleLabel.frame = newFrame1;
    [blockElement.blockHolderView addSubview:blockElement.eventTitleLabel];
    
    //add distance label
    blockElement.distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 130, 120, 20)];
    [blockElement.distanceLabel setText:[NSString stringWithFormat:@"%.1f mi", distance]];
    blockElement.distanceLabel.numberOfLines = 1;
    blockElement.distanceLabel.lineBreakMode = UILineBreakModeClip;
    [blockElement.distanceLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [blockElement.distanceLabel setTextColor:[UIColor lightGrayColor]];
    [blockElement.blockHolderView addSubview:blockElement.distanceLabel];
    
    //add heart image
    blockElement.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(115, 130 + blockElement.distanceLabel.frame.size.height/2 - 5, 10, 10)];
    [blockElement.heartImageView setImage:[UIImage imageNamed:EXPLORE_BLOCK_ELEMENT_REPIN_IMAGE]];
    [blockElement.blockHolderView addSubview:blockElement.heartImageView];
    
    //add heart label
    blockElement.heartNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 130, 10, 20)];
    [blockElement.heartNumberLabel setText:favor_label];
    [blockElement.heartNumberLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [blockElement.blockHolderView addSubview:blockElement.heartNumberLabel];
    [blockElement.blockHolderView addSubview:blockElement.heartNumberLabel];
    
    return  blockElement;
}
@end
