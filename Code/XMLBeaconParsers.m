//
//  XMLBeaconParsers.m
//  exposup
//
//  Created by Kevin on 13/05/16.
//
//

#import "XMLBeaconParsers.h"

@implementation XMLBeaconParsers

@synthesize currentProperty, currentID, currentName, mapIDtoName, names, ids, error, errors, zones, currentZone, mapZonetoID;



- (Boolean)parseIndex{
    error = false;
    errors = [[NSString alloc] init];
    NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: @"indexWithZone.xml" contentFile: NO] ];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = %@", @"index.xml");
        [XMLParser setState: FILE_EMPTY];
        return false;
    }
    else NSLog(@"Data created from file content.");
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: data];
    
    [xmlParser setDelegate: self];
    [xmlParser setShouldProcessNamespaces: NO];
    [xmlParser setShouldReportNamespacePrefixes: NO];
    [xmlParser setShouldResolveExternalEntities: NO];
    
    [xmlParser parse];
    
    NSError *parseError = [xmlParser parserError];
    if(parseError) {
        error = true;
        NSLog(@"XmlParser - error parsing data : %@", [parseError localizedDescription]);
        errors = [parseError localizedDescription];
        [XMLParser setLastErrorFilePath:@"index.html"];
        [XMLParser setLastErrorDescription:[parseError localizedDescription]];
        [XMLParser setState: PARSING_ERROR];
        return false;
    }
    return true;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    mapIDtoName = [NSDictionary dictionary];
    mapZonetoID = [[NSMutableDictionary alloc] init];
    ids = [[NSMutableArray alloc] init];
    names = [[NSMutableArray alloc] init];
    zones = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString: @"entry"]) {
        currentName = nil;
        currentID = nil;
        currentZone = nil;
        currentName = [[NSString alloc] init];
        currentID = [[NSString alloc] init];
        
    }
    else if ([elementName isEqualToString: @"id"] || [elementName isEqualToString: @"name"] || [elementName isEqualToString: @"zone"]) {
        currentProperty = nil;
        currentProperty = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString: @"index"]) {
        mapIDtoName = [NSDictionary dictionaryWithObjects:names forKeys:ids];
        //mapZonetoID = [NSDictionary dictionaryWithObjects:ids forKeys:zones];
    }
    else if([elementName isEqualToString:@"entry"]) {
        [names addObject: currentName];
        [ids addObject: currentID];
        //[zones addObject: currentZone];
        
    }
    else if([elementName isEqualToString:@"id"]) {
        currentID = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"name"]) {
        currentName = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"zone"]) {
        currentZone = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([mapZonetoID objectForKey:currentZone] == nil){
            [mapZonetoID setValue:[[NSMutableArray alloc] init] forKey:currentZone];
            [zones addObject: currentZone];
        }
        [mapZonetoID[currentZone] addObject:currentID ];
            
    }
}

+(XMLBeaconParsers*)instance {
    static XMLBeaconParsers *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMLBeaconParsers alloc] init];
        [instance parseIndex];
    });
    return instance;
}



@end
