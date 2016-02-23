//
//  XMLDictionaryParser.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/04/13.
//
//

#import "XMLDictionaryParser.h"

@implementation XMLDictionaryParser

@synthesize currentProperty, currentDefinition,currentWord, words, definitions;



- (Boolean)parseXMLDictionary {

    NSString *filePath = [[LanguageManagement instance] pathForFile: @"dictionary.xml" contentFile: NO];
    
    NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from dictionary. Path = %@", filePath);
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showDictionaryNotFoundAlert:self];
        [XMLParser setState: FILE_EMPTY];
        return false;
    }
    else {
        NSLog(@"Data created from file content. Dictionary.");
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: data];
        
        [xmlParser setDelegate: self];
        [xmlParser setShouldProcessNamespaces: NO];
        [xmlParser setShouldReportNamespacePrefixes: NO];
        [xmlParser setShouldResolveExternalEntities: NO];
        
        [xmlParser parse];
        
        NSError *parseError = [xmlParser parserError];
        if(parseError) {
            NSLog(@"XmlParser - error parsing data : %@", [parseError localizedDescription]);
            //Alerts *alert = [[Alerts alloc] init];
            //[alert errorParsingAlert:self file: filePath error:[parseError localizedDescription]];
            [XMLParser setLastErrorFilePath:filePath];
            [XMLParser setLastErrorDescription:[parseError localizedDescription]];
            [XMLParser setState: PARSING_ERROR];
            return false;
        }
    }
    return true;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    words = [[NSMutableArray alloc] init];
    definitions = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"entry"]) {
        
            currentWord = nil;

            currentDefinition = nil;

        currentWord= [[NSMutableString alloc] init];
        currentDefinition = [[NSMutableString alloc] init];

    }
    else if([elementName isEqualToString: @"word"] || [elementName isEqualToString: @"definition"]) {
        currentProperty = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"entry"]) {
        [words addObject: [currentWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        [definitions addObject: [currentDefinition stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
    }
    else if ([elementName isEqualToString:@"word"])
        currentWord = currentProperty;
    else if ([elementName isEqualToString:@"definition"])
        currentDefinition = currentProperty;
}


+(XMLDictionaryParser*)instance {
    static XMLDictionaryParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XMLDictionaryParser alloc] init];
        [instance parseXMLDictionary];
    });
    return instance;
}



@end