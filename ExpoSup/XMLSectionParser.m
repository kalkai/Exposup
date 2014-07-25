#import "XMLSectionParser.h"

@implementation XMLSectionParser

@synthesize currentType, currentFile, currentProperty, files, types, currentName, names, title,error,subtitles, locations, currentLocation, currentSubtitle;



- (void)parseXMLFileAtPath:(NSString *)path {
    error = FALSE;
    self.path = path;
    NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: path contentFile: NO]];
    if(data == nil)
        NSLog(@"Error during creation of data from file. Path = %@", path);
    else NSLog(@"Section - Data created from file content. Name = %@", [[LanguageManagement instance] pathForFile: path contentFile: NO]);
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData: data];
    
    [xmlParser setDelegate: self];
    [xmlParser setShouldProcessNamespaces: NO];
    [xmlParser setShouldReportNamespacePrefixes: NO];
    [xmlParser setShouldResolveExternalEntities: NO];
    
    [xmlParser parse];
    
    NSError *parseError = [xmlParser parserError];
    if(parseError) {
        NSLog(@"XmlParser - error parsing data : %@", [parseError localizedDescription]);
        Alerts *alert = [[Alerts alloc] init];
        [alert errorParsingAlert:self file:path error:[parseError localizedDescription]];

    }
    
    if(types.count==0 || files.count==0 || names.count==0) {
 
        error = TRUE;
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    types = [[NSMutableArray alloc] init];
    files = [[NSMutableArray alloc] init];
    names = [[NSMutableArray alloc] init];
    title = [[NSString alloc] init];
    subtitles = [[NSMutableArray alloc] init];
    locations = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString: @"subsection"]) {
        currentFile = nil;
        currentName = nil;
        currentType = nil;
        currentType = [[NSString alloc] init];
        currentName = [[NSString alloc] init];
        currentFile = [[NSString alloc] init];
    }
    else if ([elementName isEqualToString: @"type"] || [elementName isEqualToString: @"name"] || [elementName isEqualToString: @"file"] || [elementName isEqualToString: @"title"] || [elementName isEqualToString: @"location"] || [elementName isEqualToString: @"content"]) {
        currentProperty = nil;
        currentProperty = [[NSMutableString alloc] init];
    } else if ([elementName isEqualToString:@"subtitle"]) {
        currentLocation = nil;
        currentSubtitle = nil;
        
        currentSubtitle = [[NSMutableString alloc] init];
        currentLocation = [[NSMutableString alloc] init];
    }
        
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"subsection"]) {
        [names addObject: currentName];
        [files addObject: currentFile];
        [types addObject: currentType];
    }
    else if([elementName isEqualToString:@"type"]) {
        currentType = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"name"]) {
        currentName = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"file"]) {
        currentFile = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"title"]) {
        title = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"subtitle"]) {
        [types addObject: @"subtitle"];
        [names addObject: @"subtitle"];
        [files addObject: @"subtitle"];
        
        [subtitles addObject:[currentSubtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [locations addObject:[currentLocation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else if([elementName isEqualToString:@"location"]) {
        NSString *value = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([value isEqualToString:@"gauche"]) {
            currentLocation = @"gauche";
        }
        else if ([value isEqualToString:@"droite"]) {
            currentLocation = @"droite";
        }
        else currentLocation = @"centre";
    }
    else if([elementName isEqualToString:@"content"]) {
        currentSubtitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}



@end
