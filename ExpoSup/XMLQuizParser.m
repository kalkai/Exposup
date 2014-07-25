//
//  XMLQuizParser.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/04/13.
//
//

#import "XMLQuizParser.h"

@implementation XMLQuizParser

@synthesize correctAnswers,currentCorrectAnswer,currentFalseAnswers,currentProperty,currentQuestion,questions,falseAnswers;

- (void)parseXMLFileAtPath:(NSString *)path {

    NSLog(@"path %@", path);
    NSString *filePath = [[LanguageManagement instance] pathForFile: path contentFile: NO];
    
    NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = %@", filePath);
        Alerts *alert = [[Alerts alloc] init];
        [alert showQuizNotFoundAlert:self file:path];
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
    // NSLog(@"start ");
    questions = [[NSMutableArray alloc] init];
    falseAnswers = [[NSMutableArray alloc] init];
    correctAnswers = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    // NSLog(@"begin %@", elementName);
    if([elementName isEqualToString:@"entry"]) {
        
        
        currentQuestion = nil;
        
        currentCorrectAnswer = nil;
    
        currentFalseAnswers = nil;

        currentQuestion = [[NSMutableString alloc] init];
        currentCorrectAnswer = [[NSMutableString alloc] init];
        currentFalseAnswers = [[NSMutableArray alloc] init];
    }

    else if([elementName isEqualToString: @"question"] || [elementName isEqualToString: @"correctAnswer"] || [elementName isEqualToString: @"answer"]) {
        currentProperty = nil;
        currentProperty = [[NSMutableString alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //NSLog(@"finish %@", elementName);
    if([elementName isEqualToString:@"entry"]) {
        [questions addObject: [currentQuestion stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        [correctAnswers addObject: [currentCorrectAnswer stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        [falseAnswers addObject: currentFalseAnswers];
        
    }
    else if ([elementName isEqualToString:@"correctAnswer"])
        currentCorrectAnswer = currentProperty;
    else if ([elementName isEqualToString:@"question"])
        currentQuestion = currentProperty;
    else if ([elementName isEqualToString:@"answer"])
        [currentFalseAnswers addObject: [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}




@end
