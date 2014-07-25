//
//  XMLLabelsParser.h
//  ExpoSup
//
//  Created by Jean Richelle on 8/01/14.
//
//

#import <Foundation/Foundation.h>
#import "Alerts.h"


@class Config;

@interface XMLLabelsParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableString *currentProperty;

@property (strong, nonatomic) NSString *expoTitle;
@property (strong, nonatomic) NSString *backButtonLabel;

@property (strong, nonatomic) NSString *welcomeTitle;
@property (strong, nonatomic) NSString *chooseModLabel;
@property (strong, nonatomic) NSString *adultButton;
@property (strong, nonatomic) NSString *guideButton;
@property (strong, nonatomic) NSString *childButton;
@property (strong, nonatomic) NSString *soundButtonLabel;

@property (strong, nonatomic) NSString *chosenModLabel;
@property (strong, nonatomic) NSString *modifyMod;
@property (strong, nonatomic) NSString *confirmMod;

@property (strong, nonatomic) NSString *scanInstruction;
@property (strong, nonatomic) NSString *toIDButton;

@property (strong, nonatomic) NSString *IDInstruction;
@property (strong, nonatomic) NSString *validateButton;

@property (strong, nonatomic) NSString *userManual;

@property (strong, nonatomic) NSString *expandSynopsis;
@property (strong, nonatomic) NSString *contractSynopsis;

@property (strong, nonatomic) NSString *animateButton;

- (void)parseXMLLabels;

@end
