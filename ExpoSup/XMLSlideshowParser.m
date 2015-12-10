//
//  XMLSlideshowParser.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 5/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "XMLSlideshowParser.h"

@implementation XMLSlideshowParser

@synthesize nSlides, audioAutostart, audioRepetition, audioFileName, audios, audioTitle, title;

@synthesize images;
@synthesize comments;

@synthesize currentImagePath;
@synthesize currentComment;
@synthesize currentProperty;
@synthesize currentAudio;




- (Boolean)parseXMLFileAtPath:(NSString *)path {
    self.nSlides = 0;
    NSLog(@"path %@", path);
     NSString *filePath = [[LanguageManagement instance] pathForFile: path contentFile: NO];
     NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        self.nSlides = -1;
        NSLog(@"Error during creation of data from file. Path = %@", filePath);
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showSlideshowNotFoundAlert:self file:path];
        [XMLParser setState: FILE_EMPTY];
        return false;
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
            //Alerts *alert = [[Alerts alloc] init];
            //[alert errorParsingAlert:self file:path error:[parseError localizedDescription]];
            [XMLParser setLastErrorFilePath:path];
            [XMLParser setLastErrorDescription:[parseError localizedDescription]];
            [XMLParser setState: PARSING_ERROR];
            return false;
        }
    }
    return true;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    images = [[NSMutableArray alloc] init];
    comments = [[NSMutableArray alloc] init];
    audios = [[NSMutableArray alloc] init];
    title = [[NSString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"slide"]) {
        
        
        currentImagePath = nil;

        currentComment = nil;

        currentAudio = nil;

        currentImagePath = [[NSMutableString alloc] init];
        currentAudio = [[AudioViewController alloc] init];
        currentComment = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString: @"comment"]) {
        currentComment = [[NSMutableString alloc] init];
    }
    else if([elementName isEqualToString:@"audio"]) {
        audioFileName = [[NSString alloc] init];
        audioTitle = [[NSString alloc] init];
        audioTitle = @"noaudio";
        audioRepetition = [[NSString alloc] init];
        audioAutostart = [[NSString alloc] init];
    }
    
    currentProperty = nil;
    currentProperty = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"slide"]) {
        ++nSlides;
        [images addObject: [currentImagePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

        [comments addObject: [currentComment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];

        [audios addObject: currentAudio];
        
    }
    else if ([elementName isEqualToString:@"image"])
        currentImagePath = currentProperty;
    else if ([elementName isEqualToString:@"comment"])
        currentComment = currentProperty;
    else if([elementName isEqualToString:@"audio"]) {
        currentAudio = [[AudioViewController alloc] init];
        currentAudio.file = audioFileName;
        currentAudio.name = audioTitle;
        
        if([audioRepetition isEqualToString:@"oui"])
            currentAudio.repetition = true;
        else currentAudio.repetition = false;
        
        if([audioAutostart isEqualToString:@"oui"])
            currentAudio.autostart = true;
        else currentAudio.autostart = false;
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
    } else if([elementName isEqualToString:@"title"]) {
        title = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}




@end
