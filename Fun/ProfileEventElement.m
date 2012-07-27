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
@synthesize eventTitleLabel=_eventTitleLabel;
@synthesize locationNameLabel=_locationNameLabel;
@synthesize eventImageView=_eventImageView;
@synthesize heartImageView=_heartImageView;
@synthesize heartNumberLabel=_heartNumberLabel;

@synthesize event_id=_event_id;
@synthesize shared_event_id=_shared_event_id;

+(ProfileEventElement *)initialWithPositionY:(CGFloat)position_y eventImageURL:(NSString *)eventImageURL tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id withLocationName:(NSString *)locationName{
    ProfileEventElement* blockElement=[[ProfileEventElement alloc] init];
    //initial the blockElement frame
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(0,position_y, PROFILE_ELEMENT_VIEW_WIDTH, PROFILE_ELEMENT_VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    
    //set event_id and shared_event_id
    blockElement.event_id = event_id;
    blockElement.shared_event_id=shared_event_id;
    
    //Event Image
    blockElement.eventImageView=[[UIImageView alloc] initWithFrame:CGRectMake(PROFILE_ELEMENT_EVENT_IMAGE_X, PROFILE_ELEMENT_EVENT_IMAGE_Y, PROFILE_ELEMENT_EVENT_IMAGE_SIZE, PROFILE_ELEMENT_EVENT_IMAGE_SIZE)];
    [blockElement.eventImageView setContentMode:UIViewContentModeScaleAspectFill];
    [blockElement.eventImageView setClipsToBounds:YES];
    [blockElement.blockView addSubview:blockElement.eventImageView];
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
                        [blockElement.blockView addSubview:blockElement.eventImageView];
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
                        [blockElement.blockView addSubview:blockElement.eventImageView];
                    });
                }
            }
        });
    }
    else {
        dispatch_async( dispatch_get_main_queue(),^{
            blockElement.eventImageView.image=[UIImage imageWithData:[Cache getCachedData:url]];
            [blockElement.blockView addSubview:blockElement.eventImageView];
        });
    }
    
    
    //add event title
    blockElement.eventTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(55, 0, 200, 30)];
    blockElement.eventTitleLabel.numberOfLines = 2;
    [blockElement.eventTitleLabel setText:title];
    [blockElement.eventTitleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [blockElement.blockView addSubview:blockElement.eventTitleLabel];
    
    //add location label
    blockElement.locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 28, 150, 21)];
    [blockElement.locationNameLabel setText:locationName];
    [blockElement.locationNameLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [blockElement.locationNameLabel setTextColor:[UIColor lightGrayColor]];
    [blockElement.blockView addSubview:blockElement.locationNameLabel];
    
    //add heart image
    blockElement.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(278, 22, 14, 14)];
    [blockElement.heartImageView setImage:[UIImage imageNamed:@"29-heart.png"]];
    [blockElement.blockView addSubview:blockElement.heartImageView];
    
    //add heart label
    blockElement.heartNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(296, 18, 21, 21)];
    [blockElement.heartNumberLabel setText:favor_label];
    [blockElement.heartNumberLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [blockElement.blockView addSubview:blockElement.heartNumberLabel];
    return  blockElement;
}
@end
