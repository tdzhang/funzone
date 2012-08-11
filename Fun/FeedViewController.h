//
//  FeedViewController.h
//  Fun
//
//  Created by He Yang on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExploreBlockElement.h"
#import "Cache.h"
#import "OtherProfilePageViewController.h"
#import "GlobalConstant.h"
#import "ProfilePageViewController.h"

@interface FeedViewController : UIViewController<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *instructionView;

@end

/////
/*
 NSError *error;
 NSArray *json = [NSJSONSerialization JSONObjectWithData:self.data options:kNilOptions error:&error];
 NSLog(@"%@",json);
 //clean the page
 for (UIView *subView in self.garbageCollection) {
 [subView removeFromSuperview];
 }
 for (UIView* subView in self.mainScrollView.subviews) {
 [subView removeFromSuperview];
 }
 [self.blockViews removeAllObjects];
 //after reget the newest 10 popular event, the next page that need to be retrait is page 2
 self.refresh_page_num=2;
 for (NSDictionary* event in json) {
 NSString *title=[event objectForKey:@"title"];
 //NSString *description=[event objectForKey:@"description"];
 NSString *photo=[event objectForKey:@"photo_url"];
 NSString *num_likes=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_likes"]];
 NSString *num_pins=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_pins"]];
 //NSString *num_views=[NSString stringWithFormat:@"%@",[event objectForKey:@"num_views"]];
 NSString *event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"event_id"]];
 NSString *shared_event_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"shared_event_id"]];
 NSString *locationName=[event objectForKey:@"location"];
 NSString *creator_name=[event objectForKey:@"creator_name"];
 NSString *creator_pic=[event objectForKey:@"creator_pic"];
 NSString *creator_id=[NSString stringWithFormat:@"%@",[event objectForKey:@"creator_id"]];
 NSString *event_category=[NSString stringWithFormat:@"%@",[event objectForKey:@"category_id"]];
 if (!title) {
 continue;
 }
 if ([[NSString stringWithFormat:@"%@",photo] isEqualToString:@"<null>"]) {
 continue;
 }
 NSURL *url=[NSURL URLWithString:photo];
 [self.blockViews insertObject:[ExploreBlockElement initialWithPositionY:[self.blockViews count]*EXPLORE_BLOCK_ELEMENT_VIEW_HEIGHT backGroundImageUrl:url tabActionTarget:self withTitle:title withFavorLabelString:num_likes withJoinLabelString:num_pins withEventID:event_id withShared_Event_ID:shared_event_id withLocationName:locationName withCreatorName:creator_name withCreatorPhoto:creator_pic withCreatorId:creator_id withEventCategory:event_category] atIndex:[self.blockViews count]];
 //check for whether show the instruction
 [self checkForWhetherShowInstruction];
 //refresh the whole view
 [self refreshAllTheMainScrollViewSUbviews];
 
 }
*/