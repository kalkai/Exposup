//
//  BeaconConfig.h
//  exposup
//
//  Created by Kevin on 16/05/16.
//
//


#import <Foundation/Foundation.h>

#import "Config.h"
#import "Alerts.h"
#import "XMLParser.h"


@interface XMLBeaconConfigParser : XMLParser
@property (assign,nonatomic) Boolean error;
@property (strong,nonatomic) NSString *errors;
@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSString *currentMajor;
@property (strong,nonatomic) NSString *currentMinor;
@property (strong,nonatomic) NSString *currentZone;
@property (strong,nonatomic) NSDictionary *mapMajortoZone;

@property (strong,nonatomic) NSMutableArray *majors;
@property (strong,nonatomic) NSMutableArray *minors;
@property (strong,nonatomic) NSMutableArray *zones;


- (Boolean)parseIndex;
+(XMLBeaconConfigParser*)instance;

@end
