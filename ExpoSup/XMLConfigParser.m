//
//  XMLConfigParser.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 27/03/13.
//
//

#import "XMLConfigParser.h"

@implementation XMLConfigParser

@synthesize backgroundPortrait, backgroundLandscape, currentProperty,bigFont,normalFont,smallFont, tinyFont, bigFontSize,normalFontSize,smallFontSize, tinyFontSize, currentB,currentG,currentR, showChildMode, showGuideMode, backButtonToScan,scanInstruction, IDInstruction, userManual, color1,color2,color3,color4,color5,color6, expoTitle, welcomeTitle, banner, opacity, quoteFont, quoteFontSize, backButtonLabel, languagesIcons, languagesNames, languagesPrefixes, defautLanguagePrefix, currentLanguageIcon, currentLanguageIsDefault, currentLanguageName, currentLanguagePrefix;


- (Boolean)parseXMLFile {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"files %@", paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString: @"/config.xml"];
    
    NSData *data = [NSData  dataWithContentsOfFile: filePath];
    if(data == nil) {
        NSLog(@"Error during creation of data from file. Path = config.xml");
        
        Alerts *alert = [[Alerts alloc] init];
        [alert showConfigNotFoundAlert:self];
        return false;
    }
    else {
        NSLog(@"Data created from file content. Config.");
        
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
            [alert errorParsingAlert:self file:filePath error: [parseError localizedDescription]];
            return false;
        }
        else return true;
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    backgroundPortrait = [[NSString alloc] init];
    backgroundLandscape = [[NSString alloc] init];
    backButtonToScan = [[NSString alloc] init];
    backButtonLabel = [[NSString alloc] init];
    //infoButton = [[NSString alloc] init]; // Do not forget to synthetize if uncomment
    welcomeTitle = [[NSString alloc] init];
    expoTitle = [[NSString alloc] init];
    userManual = [[NSString alloc] init];
    banner = [[NSString alloc] init];
    scanInstruction = [[NSString alloc] init];
    IDInstruction = [[NSString alloc] init];
    
    showGuideMode = false;
    showChildMode = false;
    
    bigFont = [[NSString alloc] init];
    normalFont = [[NSString alloc] init];
    smallFont = [[NSString alloc] init];
    tinyFont = [[NSString alloc] init];
    quoteFont = [[NSString alloc] init];
    
    tinyFontSize = [[NSString alloc] init];
    normalFontSize = [[NSString alloc] init];
    smallFontSize = [[NSString alloc] init];
    tinyFontSize = [[NSString alloc] init];
    quoteFontSize = [[NSString alloc] init];
    
    color1 = [[NSMutableArray alloc] init];
    color2 = [[NSMutableArray alloc] init];
    color3 = [[NSMutableArray alloc] init];
    color4 = [[NSMutableArray alloc] init];
    color5 = [[NSMutableArray alloc] init];
    color6 = [[NSMutableArray alloc] init];
    
    opacity = 0.3;
    
    languagesPrefixes = [[NSMutableArray alloc] init];
    languagesNames = [[NSMutableArray alloc] init];
    languagesIcons = [[NSMutableArray alloc] init];
    defautLanguagePrefix = @"null";
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString: @"backgroundPortrait"]
       || [elementName isEqualToString: @"backgroundLandscape"]
       || [elementName isEqualToString: @"backToScanButton"]
       || [elementName isEqualToString: @"backButtonLabel"]
       || [elementName isEqualToString: @"r"]
       || [elementName isEqualToString: @"g"]
       || [elementName isEqualToString: @"b"]
       //|| [elementName isEqualToString: @"infoButton"]
       // Keep the next part for old versions
       || [elementName isEqualToString: @"policeGrande"]
       || [elementName isEqualToString: @"policeMoyenne"]
       || [elementName isEqualToString: @"policePetite"]
       || [elementName isEqualToString: @"policeTresPetite"]
       || [elementName isEqualToString: @"tailleGrandePolice"]
       || [elementName isEqualToString: @"tailleMoyennePolice"]
       || [elementName isEqualToString: @"taillePetitePolice"]
       || [elementName isEqualToString: @"tailleTresPetitePolice"]
       || [elementName isEqualToString: @"modeEnfant"]
       || [elementName isEqualToString: @"modeGuide"]
       || [elementName isEqualToString: @"titreAccueil"]
       || [elementName isEqualToString: @"titreExposition"]
       || [elementName isEqualToString: @"opacite"]
       || [elementName isEqualToString: @"modeEmploi"]
       || [elementName isEqualToString: @"banniere"]
       || [elementName isEqualToString: @"instructionScan"]
       || [elementName isEqualToString: @"instructionIdentifiant"]
       // after refactoring, useful for new versions
       || [elementName isEqualToString: @"bigFont"]
       || [elementName isEqualToString: @"normalFont"]
       || [elementName isEqualToString: @"smallFont"]
       || [elementName isEqualToString: @"tinyFont"]
       || [elementName isEqualToString: @"quoteFont"]
       || [elementName isEqualToString: @"bigFontSize"]
       || [elementName isEqualToString: @"normalFontSize"]
       || [elementName isEqualToString: @"smallFontSize"]
       || [elementName isEqualToString: @"tinyFontSize"]
       || [elementName isEqualToString: @"quoteFontSize"]
       || [elementName isEqualToString: @"childMode"]
       || [elementName isEqualToString: @"guideMode"]
       || [elementName isEqualToString: @"welcomeTitle"]
       || [elementName isEqualToString: @"expoTitle"]
       || [elementName isEqualToString: @"opacity"]
       || [elementName isEqualToString: @"userManual"]
       || [elementName isEqualToString: @"banner"]
       || [elementName isEqualToString: @"scanInstruction"]
       || [elementName isEqualToString: @"IDInstruction"]
       || [elementName isEqualToString: @"languageName"]
       || [elementName isEqualToString: @"languagePrefix"]
       || [elementName isEqualToString: @"languageIcon"]
       || [elementName isEqualToString: @"default"]) {
        currentProperty = nil;
        currentProperty = [[NSMutableString alloc] init];
    }
    else if ( // the next part is for old versions
             [elementName isEqualToString: @"couleur1"]
             || [elementName isEqualToString: @"couleur2"]
             || [elementName isEqualToString: @"couleur3"]
             || [elementName isEqualToString: @"couleur4"]
             || [elementName isEqualToString: @"couleur5"]
             || [elementName isEqualToString: @"couleur6"]
             // the next part is for new versions
             || [elementName isEqualToString: @"color1"]
             || [elementName isEqualToString: @"color2"]
             || [elementName isEqualToString: @"color3"]
             || [elementName isEqualToString: @"color4"]
             || [elementName isEqualToString: @"color5"]
             || [elementName isEqualToString: @"color6"]) {
        currentB = [[NSMutableString alloc] init];
        currentG = [[NSMutableString alloc] init];
        currentR = [[NSMutableString alloc] init];
    }
    else if ([elementName isEqualToString: @"language"]) {
        currentLanguagePrefix = [[NSMutableString alloc] init];
        currentLanguageName = [[NSMutableString alloc] init];
        currentLanguageIcon = [[NSMutableString alloc] init];
        currentLanguageIsDefault = [[NSMutableString alloc] init];
        currentLanguageIsDefault = @"non";
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(currentProperty)
        [currentProperty appendString: string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"backgroundPortrait"]) {
        backgroundPortrait = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"backgroundLandscape"]) {
        backgroundLandscape = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"backToScanButton"]) {
        backButtonToScan = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"backButtonLabel"]) {
        backButtonLabel = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"r"]) {
        currentR = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"g"]) {
        currentG = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"b"]) {
        currentB = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    //else if ([elementName isEqualToString:@"infoButton"]) {
    //    infoButton = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //}
    
    // The next part is for old versions
    else if ([elementName isEqualToString:@"policeGrande"]) {
        bigFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"policeMoyenne"]) {
        normalFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"policePetite"]) {
        smallFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"policeTresPetite"]) {
        tinyFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"tailleGrandePolice"]) {
        bigFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"tailleMoyennePolice"]) {
        normalFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([elementName isEqualToString:@"taillePetitePolice"]) {
        smallFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"tailleTresPetitePolice"]) {
        tinyFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([elementName isEqualToString: @"titreAccueil"]) {
        welcomeTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"titreExposition"]) {
        expoTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"modeEmploi"]) {
        userManual = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"banniere"]) {
        banner = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"instructionScan"]) {
        scanInstruction = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"instructionIdentifiant"]) {
        IDInstruction = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
        
    
    else if ([elementName isEqualToString:@"modeEnfant"]) {
        NSString *result = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([result isEqualToString: @"oui"])
            showChildMode = true;
        else showChildMode = false;
    }
    else if ([elementName isEqualToString:@"modeGuide"]) {
        NSString *result = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([result isEqualToString: @"oui"])
            showGuideMode = true;
        else showGuideMode = false;
    }
    else if ([elementName isEqualToString:@"couleur1"]) {
        [color1 addObject: currentR];
        [color1 addObject: currentG];
        [color1 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"couleur2"]) {
        [color2 addObject: currentR];
        [color2 addObject: currentG];
        [color2 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"couleur3"]) {
        [color3 addObject: currentR];
        [color3 addObject: currentG];
        [color3 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"couleur4"]) {
        [color4 addObject: currentR];
        [color4 addObject: currentG];
        [color4 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"couleur5"]) {
        [color5 addObject: currentR];
        [color5 addObject: currentG];
        [color5 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"couleur6"]) {
        [color6 addObject: currentR];
        [color6 addObject: currentG];
        [color6 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"opacite"]) {
        NSString *value = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        opacity = [value floatValue];
    }
    
    
    // The next part is for NEW versions
    else if ([elementName isEqualToString:@"bigFont"]) {
        bigFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"normalFont"]) {
        normalFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"smallFont"]) {
        smallFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"tinyFont"]) {
        tinyFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"quoteFont"]) {
        quoteFont = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"bigFontSize"]) {
        bigFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"normalFontSize"]) {
        normalFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([elementName isEqualToString:@"smallFontSize"]) {
        smallFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"tinyFontSize"]) {
        tinyFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString:@"quoteFontSize"]) {
        quoteFontSize = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    else if ([elementName isEqualToString: @"welcomeTitle"]) {
        welcomeTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"expoTitle"]) {
        expoTitle = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"userManual"]) {
        userManual = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"banner"]) {
        banner = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"scanInstruction"]) {
        scanInstruction = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"IDInstruction"]) {
        IDInstruction = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    
    else if ([elementName isEqualToString:@"childMode"]) {
        NSString *result = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([result isEqualToString: @"oui"])
            showChildMode = true;
        else showChildMode = false;
    }
    else if ([elementName isEqualToString:@"guideMode"]) {
        NSString *result = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([result isEqualToString: @"oui"])
            showGuideMode = true;
        else showGuideMode = false;
    }
    else if ([elementName isEqualToString:@"color1"]) {
        [color1 addObject: currentR];
        [color1 addObject: currentG];
        [color1 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"color2"]) {
        [color2 addObject: currentR];
        [color2 addObject: currentG];
        [color2 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"color3"]) {
        [color3 addObject: currentR];
        [color3 addObject: currentG];
        [color3 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"color4"]) {
        [color4 addObject: currentR];
        [color4 addObject: currentG];
        [color4 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"color5"]) {
        [color5 addObject: currentR];
        [color5 addObject: currentG];
        [color5 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"color6"]) {
        [color6 addObject: currentR];
        [color6 addObject: currentG];
        [color6 addObject: currentB];
    }
    else if ([elementName isEqualToString:@"opacity"]) {
        NSString *value = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        opacity = [value floatValue];
    }
    
    else if ([elementName isEqualToString: @"languagePrefix"]) {
        currentLanguagePrefix = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"languageName"]) {
        currentLanguageName = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"languageIcon"]) {
        currentLanguageIcon = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    else if ([elementName isEqualToString: @"default"]) {
        NSString *temp = [currentProperty stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(![temp isEqualToString: @"oui"]) {
            temp = @"non";
        }
        currentLanguageIsDefault = temp;
    }
    else if ([elementName isEqualToString: @"language"]) {
        [languagesIcons addObject: currentLanguageIcon];
        [languagesNames addObject: currentLanguageName];
        [languagesPrefixes addObject: currentLanguagePrefix];
        
        if([currentLanguageIsDefault isEqualToString: @"oui"]) {
            defautLanguagePrefix = currentLanguagePrefix;
        }
    }

}


@end
