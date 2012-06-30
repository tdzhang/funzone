//
//  UserContactObject.h
//  SimpleChoosePage
//
//  Created by Tongda Zhang on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserContactObject : NSObject
@property(nonatomic,strong) NSString *firstName;
@property(nonatomic,strong) NSString *lastName;
@property(nonatomic,strong) NSArray *email;
@property(nonatomic,strong) NSArray *phone;
@end
