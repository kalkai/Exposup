//
//  XMLBeaconParsers.m
//  exposup
//
//  Created by Kevin on 13/05/16.
//
//

#import "XMLBeaconConfigParser.h"

@implementation XMLBeaconConfigParser

@synthesize currentProperty, currentZone, currentMajor, mapMajortoZone, minors, majors, error, errors, zones, currentMinor;



- (Boolean)parseIndex{
    error = false;
    errors = [[NSString alloc] init];
    NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: @"beaconConfig.xml" contentFile: NO] ];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = %@", @"beaconConfig.xml");
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
    mapMajortoZone = [NSDictionary dictionary];
    minors = [[NSMutableArray alloc] init];
    majors = [[NSMutableArray alloc] init];
    zones = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString: @"entry"]) {
        currentMinor = nil;
        currentMajor = nil;
        currentZone = nil;
        currentMajor = [[NSString alloc] init];
        currentMinor = [[NSString alloc] init];
        currentZone = [[NSString alloc] init];

    }
    else if ([elementName isEqualToString: @"major"] || [elementName isEqualToString: @"minor"] || [elementName isEqualToString: @"zone"]) {
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
        mapMajortoZone = [NSDictionary dictionaryWithObjects:zones forKeys:majors];
        //mapZonetoID = [NSDictionary dictionaryWithObjects:ids forKeys:zones];
    }
    else if([elementName isEqualToString:@"entry"]) {
        [zones addObject: currentZone];
        [majors addObject: currentMajor];
        //[zones addObject: currentZone];
        
    }
    else if([elementName isEqualToString:@"major"]) {
        currentMajor = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"minor"]) {
        currentMinor = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"zone"]) {
        currentZone = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }
}

+(XMLBeaconConfigParser*)instance {
    static XMLBeaconConfigParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMLBeaconConfigParser alloc] init];
        [instance parseIndex];
    });
    return instance;
}



@end
