//
//  XMLLabelsParser.m
//  ExpoSup
//
//  Created by Jean Richelle on 8/01/14.
//
//

#import "XMLLabelsParser.h"
#import "Config.h"

@implementation XMLLabelsParser


@synthesize currentProperty, expoTitle, confirmMod, chosenModLabel, chooseModLabel, childButton, IDInstruction, modifyMod, adultButton, guideButton, backButtonLabel, soundButtonLabel, validateButton, toIDButton,toScanButton, scanInstruction, userManual, welcomeTitle, expandSynopsis, contractSynopsis, animateButton, BeaconInfo , AreaLabel;


- (Boolean)parseXMLLabels {

    NSString *filePath = [[LanguageManagement instance] pathForFile: @"labels.xml" contentFile: NO];
    
    NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from dictionary. Path = %@", filePath);
        [XMLParser setState: FILE_EMPTY];
        return false;
    }
    else {
        NSLog(@"Data created from file content. Label.");
        
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
    expoTitle = [[NSString alloc] init];
    backButtonLabel = [[NSString alloc] init];
    
    welcomeTitle = [[NSString alloc] init];
    chooseModLabel = [[NSString alloc] init];
    adultButton = [[NSString alloc] init];
    guideButton = [[NSString alloc] init];
    childButton = [[NSString alloc] init];
    soundButtonLabel = [[NSString alloc] init];
    
    chosenModLabel = [[NSString alloc] init];
    modifyMod = [[NSString alloc] init];
    confirmMod = [[NSString alloc] init];
    
    scanInstruction = [[NSString alloc] init];
    BeaconInfo = [[NSString alloc] init];
    AreaLabel = [[NSString alloc] init];
    toIDButton = [[NSString alloc] init];
    toScanButton = [[NSString alloc] init];
    
    IDInstruction = [[NSString alloc] init];
    validateButton = [[NSString alloc] init];
    
    userManual = [[NSString alloc] init];
    
    expandSynopsis = [[NSString alloc] init];
    contractSynopsis = [[NSString alloc] init];
    
    animateButton = [[NSString alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{

    currentProperty = [[NSMutableString alloc] init];

}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if([elementName isEqualToString:@"expoTitle"]) {
        expoTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"backButtonLabel"]) {
        backButtonLabel = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    // --------
    else if ([elementName isEqualToString:@"welcomeTitle"]) {
        welcomeTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"chooseModLabel"]) {
        chooseModLabel = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"adultButton"]) {
        adultButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"guideButton"]) {
        guideButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"childButton"]) {
        childButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"soundButtonLabel"]) {
        soundButtonLabel = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    //----------
    
    else if ([elementName isEqualToString:@"chosenModLabel"]) {
        chosenModLabel = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"modifyMod"]) {
        modifyMod = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"confirmMod"]) {
        confirmMod = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    
    // ----------
    
    else if ([elementName isEqualToString:@"scanInstruction"]) {
        scanInstruction = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"BeaconInfo"]) {
        BeaconInfo = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([elementName isEqualToString:@"AreaLabel"]) {
        AreaLabel = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([elementName isEqualToString:@"toIDButton"]) {
        toIDButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"toScanButton"]) {
        toScanButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    //-----------
    
    else if ([elementName isEqualToString:@"IDInstruction"]) {
        IDInstruction = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"validateButton"]) {
        validateButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    
    
    else if ([elementName isEqualToString:@"userManual"]) {
        userManual = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"expandSynopsis"]) {
        expandSynopsis = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"contractSynopsis"]) {
        contractSynopsis = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"animateButton"]) {
        animateButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}



@end
