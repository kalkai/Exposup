//
//  XMLBeaconParsers.h
//  exposup
//
//  Created by Kevin on 13/05/16.
//
//

#import <Foundation/Foundation.h>

#import "Config.h"
#import "Alerts.h"
#import "XMLParser.h"

@interface XMLBeaconParsers : XMLParser
@property (assign,nonatomic) Boolean error;
@property (strong,nonatomic) NSString *errors;
@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSString *currentName;
@property (strong,nonatomic) NSString *currentID;
@property (strong,nonatomic) NSString *currentZone;
@property (strong,nonatomic) NSDictionary *mapIDtoName;
@property (strong,nonatomic) NSDictionary *mapZonetoID;

@property (strong,nonatomic) NSMutableArray *names;
@property (strong,nonatomic) NSMutableArray *ids;
@property (strong,nonatomic) NSMutableArray *zones;


- (Boolean)parseIndex;
+(XMLBeaconParsers*)instance;

@end
