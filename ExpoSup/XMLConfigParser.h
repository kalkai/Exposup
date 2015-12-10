//
//  XMLConfigParser.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 27/03/13.
//
//

#import <Foundation/Foundation.h>
#import "Alerts.h"
#import "XMLParser.h"

@interface XMLConfigParser : XMLParser

@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSString *currentR;
@property (strong,nonatomic) NSString *currentG;
@property (strong,nonatomic) NSString *currentB;
@property (strong,nonatomic) NSString *currentLanguageName;
@property (strong,nonatomic) NSString *currentLanguagePrefix;
@property (strong,nonatomic) NSString *currentLanguageIcon;
@property (strong,nonatomic) NSString *currentLanguageIsDefault;


@property (strong,nonatomic) NSString *backgroundPortrait;
@property (strong,nonatomic) NSString *backgroundLandscape;
@property (strong,nonatomic) NSString *backButtonToScan;
@property (strong,nonatomic) NSString *backButtonLabel;
//@property (strong,nonatomic) NSString *infoButton;
@property (strong,nonatomic) NSString *welcomeTitle;
@property (strong,nonatomic) NSString *expoTitle;
@property (strong,nonatomic) NSString *userManual;
@property (strong,nonatomic) NSString *banner;
@property (strong,nonatomic) NSString *scanInstruction;
@property (strong,nonatomic) NSString *IDInstruction;

@property (assign,nonatomic) Boolean showChildMode;
@property (assign,nonatomic) Boolean showGuideMode;

@property (strong,nonatomic) NSString *bigFont;
@property (strong,nonatomic) NSString *bigFontSize;
@property (strong,nonatomic) NSString *normalFont;
@property (strong,nonatomic) NSString *normalFontSize;
@property (strong,nonatomic) NSString *smallFont;
@property (strong,nonatomic) NSString *smallFontSize;
@property (strong,nonatomic) NSString *tinyFont;
@property (strong,nonatomic) NSString *tinyFontSize;
@property (strong,nonatomic) NSString *quoteFont;
@property (strong,nonatomic) NSString *quoteFontSize;


@property (strong,nonatomic) NSMutableArray *color1;
@property (strong,nonatomic) NSMutableArray *color2;
@property (strong,nonatomic) NSMutableArray *color3;
@property (strong,nonatomic) NSMutableArray *color4;
@property (strong,nonatomic) NSMutableArray *color5;
@property (strong,nonatomic) NSMutableArray *color6;
@property (assign,nonatomic) float opacity;

@property (strong,nonatomic) NSMutableArray *languagesNames;
@property (strong,nonatomic) NSMutableArray *languagesPrefixes;
@property (strong,nonatomic) NSMutableArray *languagesIcons;
@property (strong,nonatomic) NSString *defautLanguagePrefix;


- (Boolean)parseXMLFile;

@end
