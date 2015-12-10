//
//  XMLIndexParser.m
//  ExpoSup
//
//  Created by Jean Richelle on 9/09/13.
//
//

#import "XMLIndexParser.h"

@implementation XMLIndexParser


@synthesize currentProperty, currentID, currentName, map, names, ids, error, errors;



- (Boolean)parseIndex{
    error = false;
    errors = [[NSString alloc] init];
    NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: @"index.xml" contentFile: NO] ];
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
    map = [NSDictionary dictionary];
    ids = [[NSMutableArray alloc] init];
    names = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString: @"entry"]) {
        currentName = nil;
        currentID = nil;
        currentName = [[NSString alloc] init];
        currentID = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString: @"id"] || [elementName isEqualToString: @"name"]) {
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
        map = [NSDictionary dictionaryWithObjects:names forKeys:ids];
    }
    else if([elementName isEqualToString:@"entry"]) {
        [names addObject: currentName];
        [ids addObject: currentID];
    }
    else if([elementName isEqualToString:@"id"]) {
        currentID = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"name"]) {
        currentName = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

+(XMLIndexParser*)instance {
    static XMLIndexParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMLIndexParser alloc] init];
        [instance parseIndex];
    });
    return instance;
}



@end
