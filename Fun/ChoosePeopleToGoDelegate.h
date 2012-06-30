//
//  FeedBackToCreateActivityChange.h
//  SimpleChoosePage
//
//  Created by Tongda Zhang on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserContactObject.h"

@protocol ChoosePeopleToGoDelegate <NSObject>
@optional
//the method for choosing activity
-(void)UserSetupOnePropertyFrom:(UIButton*)sender
           WithPropertyCategory:(NSString*)kind
WithContent:(NSString*)content;

-(void)UserSetupUserDefinedPropertyFrom:(UIButton*)sender
           WithPropertyCategory:(NSString*)kind
                    WithContent:(NSString*)content;
//the methods for choosing people to go out with
-(void)AddContactInformtionToPeopleList:(UserContactObject*)person;
-(void)DeleteContactInformtionToPeopleList:(UserContactObject*)person;
@end
