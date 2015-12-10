//
//  XMLQuizParser.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/04/13.
//
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "XMLParser.h"

@interface XMLQuizParser : XMLParser

@property (strong, nonatomic) NSMutableString *currentProperty;
@property (strong, nonatomic) NSMutableString *currentQuestion;
@property (strong, nonatomic) NSMutableString *currentCorrectAnswer;
@property (strong, nonatomic) NSMutableArray *currentFalseAnswers;

@property (strong, nonatomic) NSMutableArray *questions;
@property (strong, nonatomic) NSMutableArray *falseAnswers; //array of array
@property (strong, nonatomic) NSMutableArray *correctAnswers;

-(Boolean)parseXMLFileAtPath:(NSString*)path;

@end
