//
//  User.h
//  Fun
//
//  Created by Yizhou Zhu on 7/25/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * facebook_id;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSDate * last_login;
@property (nonatomic, retain) NSDate * last_logout;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * passwd;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * timestamps;

@end
