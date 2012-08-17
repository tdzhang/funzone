//
//  FourSquarePlace.m
//  MapViewPractice
//
//  Created by Tongda Zhang on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
// 

#import "FourSquarePlace.h"

@implementation FourSquarePlace
@synthesize name=_name;
@synthesize phone=_phone;
@synthesize formattedPhone=_formattedPhone;
@synthesize address=_address;
@synthesize crossStreet=_crossStreet;
@synthesize latitude=_latitude;
@synthesize longitude=_longitude;
@synthesize distance=_distance;
@synthesize city=_city;
@synthesize state=_state;
@synthesize country=_country;
@synthesize categories_shortName=_categories_shortName;
@synthesize selfDefineName=_selfDefineName;
@synthesize google_reference=_google_reference;

//use google api
+(FourSquarePlace *)initializeWithSelfDefine:(NSString *)venueName{
    FourSquarePlace *place=[[FourSquarePlace alloc] init];
    
    //name
    NSString *name=[NSString stringWithFormat:@"Tap to add '%@'",venueName];
    place.name=name;
    place.selfDefineName=venueName;
    
    //location information
    place.latitude=nil;
    place.longitude=nil;
    place.crossStreet=nil;
    
    return place;
}


//use google api
+(FourSquarePlace *)initializeWithGoogleNSDictionary:(NSDictionary *)venue withOrigin:(CLLocationCoordinate2D)userCoordinate{
    FourSquarePlace *place=[[FourSquarePlace alloc] init];
    
    //name
    NSString *name=[venue objectForKey:@"name"];
    place.name=name;
    place.google_reference=[venue objectForKey:@"reference"];
    //location information
    NSDictionary *location = [[venue objectForKey:@"geometry"] objectForKey:@"location"];
    NSNumber *latitude = [location objectForKey:@"lat"];
    NSNumber *longitude = [location objectForKey:@"lng"];
    place.latitude=latitude;
    place.longitude=longitude;
    NSString *crossStreet=[venue objectForKey:@"vicinity"];
    place.crossStreet=crossStreet;
    
    //type
    NSArray *categories=[venue objectForKey:@"types"];
    int i=[categories count];
    NSLog(@"%d",i);
    if ([categories count]>0) {
        NSString *categories_shortName = [categories objectAtIndex:0];
        place.categories_shortName=categories_shortName;
    }
    
    //calculate the distance
    CLLocationCoordinate2D destination;
    destination.latitude=[place.latitude doubleValue];
    destination.longitude=[place.longitude doubleValue];
    MKMapPoint p1 = MKMapPointForCoordinate(userCoordinate);
    MKMapPoint p2 = MKMapPointForCoordinate(destination);
    CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
    place.distance=[NSNumber numberWithFloat:dist];
    
    return place;
}

//use google text searcg api
+(FourSquarePlace *)initializeWithGoogleTextNSDictionary:(NSDictionary *)venue withOrigin:(CLLocationCoordinate2D)userCoordinate{
    FourSquarePlace *place=[[FourSquarePlace alloc] init];
    
    //name
    NSString *name=[venue objectForKey:@"name"];
    place.name=name;
    place.google_reference=[venue objectForKey:@"reference"];
    //location information
    NSDictionary *location = [[venue objectForKey:@"geometry"] objectForKey:@"location"];
    NSNumber *latitude = [location objectForKey:@"lat"];
    NSNumber *longitude = [location objectForKey:@"lng"];
    place.latitude=latitude;
    place.longitude=longitude;
    NSString *crossStreet=[venue objectForKey:@"formatted_address"];
    place.crossStreet=crossStreet;
    
    //type
    NSArray *categories=[venue objectForKey:@"types"];
    int i=[categories count];
    NSLog(@"%d",i);
    if ([categories count]>0) {
        NSString *categories_shortName = [categories objectAtIndex:0];
        place.categories_shortName=categories_shortName;
    }
    
    //calculate the distance
    CLLocationCoordinate2D destination;
    destination.latitude=[place.latitude doubleValue];
    destination.longitude=[place.longitude doubleValue];
    MKMapPoint p1 = MKMapPointForCoordinate(userCoordinate);
    MKMapPoint p2 = MKMapPointForCoordinate(destination);
    CLLocationDistance dist = MKMetersBetweenMapPoints(p1, p2);
    place.distance=[NSNumber numberWithFloat:dist];
    
    return place;
}

//use foursquare api
+(FourSquarePlace *)initializeWithNSDictionary:(NSDictionary *)venue{
    FourSquarePlace *place=[[FourSquarePlace alloc] init];
    
    NSString *name=[venue objectForKey:@"name"];
    place.name=name;
    NSDictionary *contact=[venue objectForKey:@"contact"];
    NSString *phone=[contact objectForKey:@"phone"];
    place.phone=phone;
    NSString *formattedPhone=[contact objectForKey:@"formattedPhone"];
    place.formattedPhone=formattedPhone;
    NSDictionary *location = [venue objectForKey:@"location"];
    NSString *address = [location objectForKey:@"address"];
    place.address=address;
    NSString *crossStreet = [location objectForKey:@"crossStreet"];
    place.crossStreet=crossStreet;
    NSNumber *latitude = [location objectForKey:@"lat"];
    NSNumber *longitude = [location objectForKey:@"lng"];
    NSNumber *distance = [location objectForKey:@"distance"];
    place.latitude=latitude;
    place.longitude=longitude;
    place.distance=distance;
    NSString *city = [location objectForKey:@"city"];
    place.city=city;
    NSString *state = [location objectForKey:@"state"];
    place.state=state;
    NSString *country = [location objectForKey:@"country"];
    place.country=country;
    NSArray *categories=[venue objectForKey:@"categories"];
    
    int i=[categories count];
    NSLog(@"%d",i);
    if ([categories count]>0) {
        NSDictionary *category = [categories objectAtIndex:0];
        NSString *categories_shortName= [category objectForKey:@"shortName"];
        place.categories_shortName=categories_shortName;
    }
    return place;
}

//the sorting compare method for FourSquarePlace object array
- (NSComparisonResult)compare:(FourSquarePlace *)otherObject {
    return [self.distance compare:otherObject.distance];
}


@end





/*
 [
 {
 id: "42911d00f964a520f5231fe3"
 name: "New York Penn Station"
 contact: {
 phone: "2126306401"
 formattedPhone: "(212) 630-6401"
 }
 location: {
 address: "1 Penn Plaza"
 crossStreet: "btwn 31st & 33rd St."
 lat: 40.750794799423865
 lng: -73.99357639021292
 distance: 5680
 postalCode: "10001"
 city: "New York"
 state: "NY"
 country: "United States"
 }
 categories: [
 {
 id: "4bf58dd8d48988d129951735"
 name: "Train Station"
 pluralName: "Train Stations"
 shortName: "Train Station"
 icon: {
 prefix: "https://foursquare.com/img/categories_v2/travel/trainstation_"
 suffix: ".png"
 }
 primary: true
 }
 ]
 verified: false
 stats: {
 checkinsCount: 485540
 usersCount: 105998
 tipCount: 1072
 }
 likes: {
 count: 0
 groups: [ ]
 }
 specials: {
 count: 0
 items: [ ]
 }
 hereNow: {
 count: 87
 groups: [
 {
 type: "others"
 name: "Other people here"
 count: 87
 items: [ ]
 }
 ]
 }
 }
 */