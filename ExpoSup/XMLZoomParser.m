//
//  XMLZoomParser.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 10/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "XMLZoomParser.h"

@implementation XMLZoomParser

@synthesize imagePath, currentProperty, currentContent, currentImage, popupContent, bottomRight, upperLeft, currentX, currentY, title, audioTitle,audioFileName,audioRepetition,audioAutostart,audio;


- (void)parseXMLFileAtPath:(NSString *)path {
    
     NSString *filePath = [[LanguageManagement instance] pathForFile: path contentFile: NO];
    
     NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = %@", filePath);
        Alerts *alert = [[Alerts alloc] init];
        [alert showZoomNotFoundAlert:self file:path];
    }
    else {
        NSLog(@"Data created from file content.");
    
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
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    imagePath = [[NSMutableString alloc] init];
    title = [[NSMutableString alloc] init];
    popupContent = [[NSMutableArray alloc] init];
    upperLeft = [[NSMutableArray alloc] init];
    bottomRight = [[NSMutableArray alloc] init];
    audio = [[AudioViewController alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"zoom"]) {
        currentImage = nil;
        currentImage = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"popup"]) {
        currentContent = nil;
        currentContent = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"upperLeft"] || [elementName isEqualToString:@"bottomRight"]) {
        currentX = nil;
        currentX = [[NSMutableString alloc] init];
        
        currentY = nil;
        currentY = [[NSMutableString alloc] init];
    }        
    else if([elementName isEqualToString:@"audio"]) {
        audioFileName = [[NSString alloc] init];
        audioTitle = [[NSString alloc] init];
        audioRepetition = [[NSString alloc] init];
        audioAutostart = [[NSString alloc] init];
    }
    else {
        currentProperty = nil;
        currentProperty = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"object found %@", currentProperty);
    if([elementName isEqualToString:@"image"]) {
        imagePath = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
       // NSLog(@"Image trouvée : %@", imagePath);
    }
    else if([elementName isEqualToString:@"popup"]) {
        [popupContent addObject: [currentContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else if([elementName isEqualToString:@"upperLeft"]) {
        [upperLeft addObject: [currentX stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [upperLeft addObject: [currentY stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else if([elementName isEqualToString:@"bottomRight"]) {
        [bottomRight addObject: [currentX stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [bottomRight addObject: [currentY stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else if([elementName isEqualToString:@"content"]) {
        currentContent = currentProperty;
    }
    else if([elementName isEqualToString:@"title"]) {
        title = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"x"]) {
        currentX = currentProperty;
    }
    else if([elementName isEqualToString:@"y"]) {
        currentY = currentProperty;
    }
    if([elementName isEqualToString:@"audio"]) {
        audio = [[AudioViewController alloc] init];
        audio.file = audioFileName;
        audio.name = audioTitle;
        
        if([audioRepetition isEqualToString:@"oui"])
            audio.repetition = true;
        else audio.repetition = false;
        
        if([audioAutostart isEqualToString:@"oui"])
            audio.autostart = true;
        else audio.autostart = false;
    }
    else if([elementName isEqualToString:@"audioRepetition"]) {
        audioRepetition = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"audioAutostart"]) {
        audioAutostart = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"audioFileName"]) {
        audioFileName = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"audioTitle"]) {
        audioTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}




@end
