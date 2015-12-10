//
//  XMLIndexParser.h
//  ExpoSup
//
//  Created by Jean Richelle on 9/09/13.
//
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "XMLParser.h"

@interface XMLIndexParser : XMLParser

@property (assign,nonatomic) Boolean error;
@property (strong,nonatomic) NSString *errors;
@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSString *currentName;
@property (strong,nonatomic) NSString *currentID;
@property (strong,nonatomic) NSDictionary *map;

@property (strong,nonatomic) NSMutableArray *names;
@property (strong,nonatomic) NSMutableArray *ids;


- (Boolean)parseIndex;
+(XMLIndexParser*)instance;

@end
