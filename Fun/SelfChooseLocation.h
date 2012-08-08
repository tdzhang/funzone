//
//  SelfChooseLocation.h
//  OrangeParc
//
//  Created by Tongda Zhang on 8/8/12.
//
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"
@class MapViewController;

@protocol SelfChooseLocation <NSObject>

-(void)UpdateLocation:(MKPointAnnotation*)annotation withLocationName:(NSString*)locationName withSnapShot:(UIImage*)image sendFrom:(MapViewController*)sender;

@end