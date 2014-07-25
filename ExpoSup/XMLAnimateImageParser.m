//
//  XMLAnimateImageParser.m
//  ExpoSup
//
//  Created by Aurélien Lebeau on 28/07/13.
//
//

#import "XMLAnimateImageParser.h"

@implementation XMLAnimateImageParser

@synthesize currentProperty,  audioFile, images, duration, autostart, repetition, audioAutostart,audioFileName,audioRepetition, audioTitle, title, comment;

- (void)parseXMLFileAtPath:(NSString *)path {

    NSLog(@"path %@", path);
    NSString *filePath = [[LanguageManagement instance] pathForFile: path contentFile: NO];
    NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = %@", filePath);
        Alerts *alert = [[Alerts alloc] init];
        [alert showSlideshowNotFoundAlert:self file:path];
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
    images = [[NSMutableArray alloc] init];
    audioFile = [[AudioViewController alloc] init];
    duration = [[NSString alloc] init];
    autostart = false;
    repetition = false;
    
    title = [[NSString alloc] init];
    title = @"notitle";
    comment = [[NSString alloc] init];
    comment = @"nocomment";
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    currentProperty = nil;
    currentProperty = [[NSMutableString alloc] init];
    
    if([elementName isEqualToString:@"audio"]) {
        audioFileName = [[NSString alloc] init];
        audioTitle = [[NSString alloc] init];
        audioTitle = @"noaudio";
        audioRepetition = [[NSString alloc] init];
        audioAutostart = [[NSString alloc] init];
    }

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"audio"]) {
        audioFile = [[AudioViewController alloc] init];
        audioFile.file = audioFileName;
        audioFile.name = audioTitle;
        
        if([audioRepetition isEqualToString:@"oui"])
            audioFile.repetition = true;
        else audioFile.repetition = false;
        
        if([audioAutostart isEqualToString:@"oui"])
            audioFile.autostart = true;
        else audioFile.autostart = false;
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
    else if ([elementName isEqualToString:@"image"])
        [images addObject: [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    else if ([elementName isEqualToString:@"duration"])
        duration = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    else if([elementName isEqualToString:@"autostart"]) {
        if([currentProperty isEqualToString:@"oui"])
            autostart = true;
        else autostart = false;
    }
    else if([elementName isEqualToString:@"repetition"]) {
        if([currentProperty isEqualToString:@"oui"])
            repetition = true;
        else repetition = false;
    }
    else if([elementName isEqualToString:@"title"]) {
        title = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"comment"]) {
        comment = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}



@end
