//
//  XMLParserDelegate.m
//  Cookie
//
//  Created by He Yang on 6/1/12.
//  Copyright (c) 2012 Stanford University. All rights reserved.
//

#import "XMLParserDelegate.h"
#import "Event.h"
#import "DictDataConverter.h"

@interface XMLParserDelegate()
@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) id currentObj;
@property (nonatomic, strong) Event * event;
@property (nonatomic, strong) NSString *currentElementValue;
@property (nonatomic, strong) DictDataConverter *converter;
@end

@implementation XMLParserDelegate
@synthesize event = _event;
@synthesize context = _context;
//@synthesize currentObj = _currentObj;
@synthesize currentElementValue = _currentElementValue;
@synthesize converter = _converter;

- (XMLParserDelegate *) initWithContext:(NSManagedObjectContext *)context {
    self = [super init];
    self.context = context;
    return self;
}

- (void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName
     attributes:(NSDictionary *)attributeDict {
    NSLog(@"%@",elementName);
    if ([elementName isEqualToString:@"event"]) {
        _event = [NSEntityDescription insertNewObjectForEntityForName:@"Event" inManagedObjectContext:self.context];
        
    } else {
        self.currentElementValue = elementName;
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    //NSLog(@"%@",elementName);
    if ([_currentElementValue isEqualToString:@"event_id"]) {
        _event.event_id = [NSNumber numberWithInt:string.integerValue];
    } else if ([_currentElementValue isEqualToString:@"creator_id"]) {
        _event.creator_id = [NSNumber numberWithInt:string.integerValue];
    } else if ([_currentElementValue isEqualToString:@"title"]) {
         _event.title = string;
    } else if ([_currentElementValue isEqualToString:@"location"]) {
        _event.location = string;
    } else if ([_currentElementValue isEqualToString:@"intro"]) {
        _event.intro = string;
    } else if ([_currentElementValue isEqualToString:@"price"]) {
        _event.price = [NSNumber numberWithInt:string.integerValue];
    } else if ([_currentElementValue isEqualToString:@"img_url"]) {
        _event.img_url = string;
    }          
}

- (void) parser:(NSXMLParser *)parser
  didEndElement:(NSString *)elementName
   namespaceURI:(NSString *)namespaceURI
  qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"event"]) {
        _event = nil;
    } else {
        self.currentElementValue = nil;
    }
}





@end
