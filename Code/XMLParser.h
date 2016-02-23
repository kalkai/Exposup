//
//  XMLParser.h
//  exposup
//
//  Created by Aurélien Lebeau on 7/12/15.
//
//

#import <Foundation/Foundation.h>

@interface XMLParser : NSObject <NSXMLParserDelegate>

typedef enum {
    SUCCESS = 0,
    FILE_EMPTY = 1,
    PARSING_ERROR = 2
} StateType;

+(StateType)getState;
+(NSString*)getLastErrorFilePath;
+(NSString*)getLastErrorDescription;

+(void)setState:(StateType)value;
+(void)setLastErrorFilePath:(NSString*)value;
+(void)setLastErrorDescription:(NSString*)value;

@end
