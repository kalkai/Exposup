//
//  XMLParser.m
//  exposup
//
//  Created by Aurélien Lebeau on 7/12/15.
//
//

#import "XMLParser.h"

@implementation XMLParser
static StateType state;
static NSString *lastErrorFilePath;
static NSString *lastErrorDescription;

+(StateType)getState {
    return state;
}

+(NSString*)getLastErrorFilePath{
    return lastErrorFilePath;
}

+(NSString*)getLastErrorDescription{
    return lastErrorDescription;
}

+(void)setState:(StateType)value{
    state = value;
}

+(void)setLastErrorFilePath:(NSString*)value {
    lastErrorFilePath = value;
}

+(void)setLastErrorDescription:(NSString*)value{
    lastErrorDescription = value;
}

@end
