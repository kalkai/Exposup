//
//  XMLDictionaryParser.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/04/13.
//
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "XMLParser.h"

@interface XMLDictionaryParser : XMLParser

@property (strong,nonatomic) NSMutableArray *words;
@property (strong,nonatomic) NSMutableArray *definitions;

@property (strong,nonatomic) NSMutableString *currentDefinition;
@property (strong,nonatomic) NSMutableString *currentWord;
@property (strong,nonatomic) NSMutableString *currentProperty;

- (Boolean)parseXMLDictionary;

+(XMLDictionaryParser*)instance;


@end