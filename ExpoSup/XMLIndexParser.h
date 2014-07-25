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

@interface XMLIndexParser : NSObject <NSXMLParserDelegate>

@property (assign,nonatomic) Boolean error;
@property (strong,nonatomic) NSString *errors;
@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSString *currentName;
@property (strong,nonatomic) NSString *currentID;
@property (strong,nonatomic) NSDictionary *map;

@property (strong,nonatomic) NSMutableArray *names;
@property (strong,nonatomic) NSMutableArray *ids;


- (void)parseIndex;
+(XMLIndexParser*)instance;

@end
