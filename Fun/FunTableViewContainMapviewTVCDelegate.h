//
//  FunTableViewContainMapviewTVCDelegate.h
//  Fun
//
//  Created by Tongda Zhang on 7/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FunTableViewContainMapviewTVCDelegate <NSObject>

-(void)selectWithAnnotation:(MKPointAnnotation*)annotation DrawMapInTheRegion:(MKCoordinateRegion)region;

@end
