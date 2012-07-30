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

+(ProfileEventElement *)initialWithPositionY:(CGFloat)position_y eventImageURL:(NSString *)eventImageURL tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id withLocationName:(NSString *)locationName withDistance:(float)distance{
    ProfileEventElement* blockElement=[[ProfileEventElement alloc] init];
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(5,position_y, PROFILE_ELEMENT_VIEW_WIDTH, PROFILE_ELEMENT_VIEW_HEIGHT)];
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
    [blockElement.distanceLabel setText:[NSString stringWithFormat:@"%f", distance]];
    blockElement.distanceLabel.numberOfLines = 1;
    blockElement.distanceLabel.lineBreakMode = UILineBreakModeClip;
    [blockElement.distanceLabel setFont:[UIFont systemFontOfSize:12]];
    [blockElement.distanceLabel setTextColor:[UIColor lightGrayColor]];
    CGSize maximumLabelSize2 = CGSizeMake(120,9999);
    CGSize expectedLabelSize2 = [[NSString stringWithFormat:@"%f", distance] sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:maximumLabelSize2 lineBreakMode:UILineBreakModeClip];
    CGRect newFrame2 = blockElement.distanceLabel.frame;
    newFrame2.size.height = expectedLabelSize2.height;
    newFrame2.origin.y = 150 - 5 - expectedLabelSize2.height;
    blockElement.distanceLabel.frame = newFrame2;
    [blockElement.blockHolderView addSubview:blockElement.distanceLabel];
    
    //add heart image
    blockElement.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 135, 10, 10)];
    [blockElement.heartImageView setImage:[UIImage imageNamed:@"29-heart.png"]];
    [blockElement.blockHolderView addSubview:blockElement.heartImageView];
    
    //add heart label
    blockElement.heartNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 135, 10, 21)];
    [blockElement.heartNumberLabel setText:favor_label];
    [blockElement.heartNumberLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [blockElement.blockHolderView addSubview:blockElement.heartNumberLabel];
    return  blockElement;
}
@end
