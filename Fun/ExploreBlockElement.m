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


#define VIEW_WIDTH 320
#define VIEW_HEIGHT 160 

#define SUB_VIEW_X 10
#define SUB_VIEW_Y 10
#define SUB_VIEW_WIDTH 300
#define SUB_VIEW_HEIGHT 110

#define THUMB_X 0
#define THUMB_Y 5
#define THUMB_SIZE 30

#define BACKGROUND_Y 51
#define BACKGROUND_HEIGHT 74

#define TITLE_TEXT_X 8
#define TITLE_TEXT_Y 67 
#define TITLE_TEXT_WIDTH 251
#define TITLE_TEXT_HEIGHT 24


#define ICON_SIZE 15
#define JOIN_X 260
#define FAVOR_X 222
#define ICON_Y 15



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

+(ExploreBlockElement *)initialWithPositionY:(CGFloat)position_y backGroundImageUrl:(NSURL *)backGroundImageUrl tabActionTarget:(id)tap_target withTitle:(NSString *)title withFavorLabelString:(NSString *)favor_label withJoinLabelString:(NSString *)join_label withEventID:(NSString *)event_id withShared_Event_ID:(NSString *)shared_event_id  withLocationName:(NSString *)locationName withCreatorName:(NSString*)creator_name withCreatorPhoto:(NSString*)creator_photo{

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
    blockElement.blockView =[[UIView alloc] initWithFrame:CGRectMake(0,position_y, VIEW_WIDTH, VIEW_HEIGHT)];
    //add gesture(tap) to the blockView
    blockElement.blockView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:tap_target action:@selector(tapBlock:)];
    [blockElement.blockView addGestureRecognizer:tapGR];
    
    
    //create View
    blockElement.view=[[UIView alloc] initWithFrame:CGRectMake(SUB_VIEW_X,SUB_VIEW_Y, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)];
    [blockElement.blockView addSubview:blockElement.view];
    
    //Backgroud Image
    blockElement.backGroundImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SUB_VIEW_WIDTH, SUB_VIEW_HEIGHT)];
    blockElement.backGroundImageView.image=[backGroundImage copy];
    [blockElement.backGroundImageView setContentMode:UIViewContentModeScaleAspectFill];
    [blockElement.backGroundImageView setClipsToBounds:YES];
    [blockElement.view addSubview:blockElement.backGroundImageView];
    
    //mask on the backgroud Image
    UIImageView* mask=[[UIImageView alloc] initWithFrame:CGRectMake(0, 30, 300, 80)];
    [mask setAlpha:0.7];
    [mask setImage:[UIImage imageNamed:@"mask.png"]];
    [mask setContentMode:UIViewContentModeScaleToFill];
    [blockElement.view addSubview:mask];
    
    
    //Title Label
    blockElement.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(TITLE_TEXT_X, TITLE_TEXT_Y, TITLE_TEXT_WIDTH, TITLE_TEXT_HEIGHT)];
    blockElement.titleLabel.text = title;
    blockElement.titleLabel.backgroundColor = [UIColor clearColor];
    blockElement.titleLabel.textColor = [UIColor whiteColor];
    blockElement.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [blockElement.view addSubview:blockElement.titleLabel];
    
    //marker image
    UIImageView* marker=[[UIImageView alloc] initWithFrame:CGRectMake(7, 90, 12, 12)];
    [marker setAlpha:0.7];
    [marker setImage:[UIImage imageNamed:@"Marker.png"]];
    [marker setContentMode:UIViewContentModeScaleToFill];
    [blockElement.view addSubview:marker];
    
    //location Label
    blockElement.locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(21, 85, 227, 21)];
    blockElement.locationLabel.text = locationName;
    blockElement.locationLabel.backgroundColor = [UIColor clearColor];
    blockElement.locationLabel.textColor = [UIColor whiteColor];
    blockElement.locationLabel.shadowColor=[UIColor darkTextColor];
    blockElement.locationLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.view addSubview:blockElement.locationLabel];
    
    //event view
    blockElement.creator = [[UIView alloc] initWithFrame:CGRectMake(10,119, 300, 31)];
    [blockElement.creator setBackgroundColor:[UIColor whiteColor]];
    [blockElement.blockView addSubview:blockElement.creator];
    
    
    //Thumbnail Image
    blockElement.thumbNailImageView=[[UIImageView alloc] initWithFrame:CGRectMake(THUMB_X, THUMB_Y, THUMB_SIZE, THUMB_SIZE)];
    
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
                UIImage *image=[UIImage imageNamed:@"monterey.jpg"];
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
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 6, 100, 30)];
    nameLabel.text = creator_name;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:nameLabel];

    
    //Joined Image
    blockElement.joinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(JOIN_X, ICON_Y, ICON_SIZE, ICON_SIZE)];
    blockElement.joinImageView.image = [UIImage imageNamed:@"bookmark_64.png"];
    [blockElement.creator addSubview:blockElement.joinImageView];
    
    //Joined number label
    blockElement.joinLabel = [[UILabel alloc] initWithFrame:CGRectMake(279, 7, 21, 31)];
    blockElement.joinLabel.text = join_label; /*****TODO*****/
    blockElement.joinLabel.backgroundColor = [UIColor clearColor];
    blockElement.joinLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:blockElement.joinLabel];
    
    //Favored Image
    blockElement.favorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(FAVOR_X, ICON_Y, ICON_SIZE, ICON_SIZE)];
    blockElement.favorImageView.image = [UIImage imageNamed:@"29-heart.png"];
    [blockElement.creator addSubview:blockElement.favorImageView];
    
    //Favored Label
    blockElement.favorLabel = [[UILabel alloc] initWithFrame:CGRectMake(242, 7 , 18, 31)];
    blockElement.favorLabel.text = favor_label; /*****TODO*****/
    blockElement.favorLabel.backgroundColor = [UIColor clearColor];   
    blockElement.favorLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [blockElement.creator addSubview:blockElement.favorLabel];
    
    //add seperator
    UIImageView* seperator=[[UIImageView alloc] initWithFrame:CGRectMake(0, 159, 320, 1)];
    [seperator setAlpha:1];
    [seperator setImage:[UIImage imageNamed:@"seperator.png"]];
    [seperator setContentMode:UIViewContentModeScaleToFill];
    [blockElement.blockView addSubview:seperator];
    
    //add some style of the views
    //[ExploreBlockElement setUpStyle:blockElement.blockView.layer];
    //[ExploreBlockElement setUpStyle:blockElement.titleView.layer];
    
    //set the event_id and shared_event_id
    blockElement.event_id=event_id;
    blockElement.shared_event_id=shared_event_id;
    //return the already initialized ExploreBlcokElement
    return  blockElement;
}


@end
