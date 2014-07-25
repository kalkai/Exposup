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

@interface XMLDictionaryParser : NSObject <NSXMLParserDelegate>

@property (strong,nonatomic) NSMutableArray *words;
@property (strong,nonatomic) NSMutableArray *definitions;

@property (strong,nonatomic) NSMutableString *currentDefinition;
@property (strong,nonatomic) NSMutableString *currentWord;
@property (strong,nonatomic) NSMutableString *currentProperty;

- (void)parseXMLDictionary;

+(XMLDictionaryParser*)instance;


@end