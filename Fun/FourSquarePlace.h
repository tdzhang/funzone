//
//  FourSquarePlace.h
//  MapViewPractice
//
//  Created by Tongda Zhang on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
// 用于存储由foursquare得到的地点信息的类

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FourSquarePlace : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *selfDefineName;
@property(nonatomic,strong) NSString *phone;
@property(nonatomic,strong) NSString *formattedPhone;
@property(nonatomic,strong) NSString *address;
@property(nonatomic,strong) NSString *crossStreet;
@property(nonatomic,strong) NSNumber *latitude;
@property(nonatomic,strong) NSNumber *longitude;
@property(nonatomic,strong) NSNumber *distance;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *state;
@property(nonatomic,strong) NSString *country;
@property(nonatomic,strong) NSString *categories_shortName;
@property(nonatomic,strong) NSStream *google_reference;
+(FourSquarePlace *)initializeWithSelfDefine:(NSString *)venueName;
+(FourSquarePlace *)initializeWithGoogleNSDictionary:(NSDictionary *)venue withOrigin:(CLLocationCoordinate2D)userCoordinate;
+(FourSquarePlace *)initializeWithNSDictionary:(NSDictionary *)venue;
+(FourSquarePlace *)initializeWithGoogleTextNSDictionary:(NSDictionary *)venue withOrigin:(CLLocationCoordinate2D)userCoordinate;
- (NSComparisonResult)compare:(FourSquarePlace *)otherObject;
@end
