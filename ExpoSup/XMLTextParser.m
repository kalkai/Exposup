//
//  XMLTextParser.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 4/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "XMLTextParser.h"

@implementation XMLTextParser


@synthesize title, citations, currentAuthor, currentCitation, comments, sources, links, linksTypes, currentLink, currentLinkType, adjusts, currentAdjust, locations, subtitles, currentSubtitle, currentLocation,authors, currentLinkContour, linksContours, synopsis, currentComment, currentImage, currentParagraph, currentProperty, currentSource, currentSynopsis, currentText, results, images, paragraphs, currentAudio, audioAutostart, audioFileName, audioRepetition, audioTitle,audio;



- (Boolean)parseXMLFileAtPath:(NSString *)path {
    NSLog(@"path %@", path);
     NSString *filePath = [[LanguageManagement instance] pathForFile: path contentFile: NO];
    
     NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = %@", filePath);
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showTextNotFoundAlert:self file:path];
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
        else {
            NSLog(@"Parsing Done...");
        }
    }
    return true;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    results = [[NSMutableArray alloc] init];
    
    images = [[NSMutableArray alloc] init];
    comments = [[NSMutableArray alloc] init];
    sources = [[NSMutableArray alloc] init];
    links = [[NSMutableArray alloc] init];
    linksTypes = [[NSMutableArray alloc] init];
    linksContours = [[NSMutableArray alloc] init];
    adjusts = [[NSMutableArray alloc] init];
    subtitles = [[NSMutableArray alloc] init];
    locations = [[NSMutableArray alloc] init];
    
    citations = [[NSMutableArray alloc] init];
    authors = [[NSMutableArray alloc] init];
    title = [[NSMutableString alloc] init];
    
    synopsis = [[NSMutableArray alloc] init];
    paragraphs = [[NSMutableArray alloc] init];
    
    audio = NO;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if([elementName isEqualToString: @"image"]) {
        if(currentComment) {
            currentComment = nil;
        }
        
        if(currentImage) {
            currentImage = nil;
        }
        
        if(currentSource) {
            currentSource = nil;
        }
        

        currentSource = [[NSMutableString alloc] init];
        currentImage = [[NSMutableString alloc] init];
        currentComment = [[NSMutableString alloc] init];
        currentLink = [[NSMutableString alloc] init];
        currentLinkType = [[NSMutableString alloc] init];
        currentLinkContour = @"non";
        currentAdjust = @"oui";
    }
    else if([elementName isEqualToString: @"citation"]) {
        currentCitation = nil;
        currentAuthor = nil;
        
        currentAuthor = [[NSMutableString alloc] init];
        currentCitation = [[NSMutableString alloc] init];
    } else if ([elementName isEqualToString:@"subtitle"]) {
        currentLocation = nil;
        currentSubtitle = nil;
        
        currentSubtitle = [[NSMutableString alloc] init];
        currentLocation = [[NSMutableString alloc] init];
    } else if ([elementName isEqualToString:@"paragraph"]) {
        currentParagraph = nil;        
        currentParagraph = [[NSMutableString alloc] init];
        
        currentSynopsis = [[NSMutableString alloc] init];
        currentSynopsis = @"nosynopsis";
        //NSLog(@"Start a paragraph -------------------");
    }
    
    else if([elementName isEqualToString:@"audio"]) {
        audio = YES;
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
    
    if([elementName isEqualToString:@"image"]) {
        [results addObject: @"image"];
        [images addObject: [currentImage stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        [comments addObject: currentComment];
        [sources addObject: currentSource];
        
        [links addObject: currentLink];
        [linksTypes addObject: currentLinkType];
        [linksContours addObject: currentLinkContour];
        [adjusts addObject: currentAdjust];
    }
    else if([elementName isEqualToString:@"subtitle"]) {
        [results addObject:@"subtitle"];
        
        [subtitles addObject:[currentSubtitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [locations addObject:[currentLocation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else if([elementName isEqualToString:@"citation"]) {
        [results addObject: @"citation"];
        [citations addObject: [currentCitation stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        [authors addObject: [currentAuthor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    }
    else if([elementName isEqualToString:@"paragraph"]) {
        //NSLog(@"End a paragraph -------------------");
        currentParagraph = currentProperty;
        [results addObject: @"paragraph"];
        currentParagraph = [currentParagraph stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //NSLog(@"Current Synopsis = %@", currentSynopsis);
        //NSLog(@"Current Paragraph = %@", currentParagraph);
        
        
        if(! [currentSynopsis isEqualToString: @"nosynopsis"]) {
            currentSynopsis = [currentSynopsis stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            NSRange range = [currentParagraph rangeOfString: currentSynopsis  options: NSCaseInsensitiveSearch];
            if(range.location != NSNotFound) {
                currentParagraph = [currentParagraph substringFromIndex:NSMaxRange(range)];
            }
        }
        
        currentParagraph = [currentParagraph stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        currentSynopsis = [currentSynopsis stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        
        
        [paragraphs addObject: currentParagraph];
        [synopsis addObject: currentSynopsis];
    }
    else if([elementName isEqualToString:@"comment"]) {
        currentComment = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"link"]) {
        currentLink = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"linkType"]) {
        currentLinkType = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"adjust"]) {
        NSString *value = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([value isEqualToString: @"non"])
            currentAdjust = @"non";
        else currentAdjust = @"oui";
    }
    else if([elementName isEqualToString:@"linkContour"]) {
        NSString *value = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([value isEqualToString: @"non"])
            currentLinkContour = @"non";
        else currentLinkContour = @"oui";
    }
    else if([elementName isEqualToString:@"path"]) {
        currentImage = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"source"]) {
        currentSource = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"title"]) {
        title = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"author"]) {
        currentAuthor = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if([elementName isEqualToString:@"sentence"]) {
        currentCitation = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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

    else if([elementName isEqualToString:@"synopsis"]) {
        currentSynopsis = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
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
