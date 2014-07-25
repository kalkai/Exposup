#import <Foundation/Foundation.h>
#import "Config.h"



@interface XMLSectionParser : NSObject <NSXMLParserDelegate>

@property (assign,nonatomic) Boolean error;
@property (strong,nonatomic) NSString *path;
@property (strong,nonatomic) NSString *currentType;
@property (strong,nonatomic) NSString *currentFile;
@property (strong,nonatomic) NSString *currentName;
@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSString *currentLocation;
@property (strong,nonatomic) NSString *currentSubtitle;

@property (strong,nonatomic) NSMutableArray *types;
@property (strong,nonatomic) NSMutableArray *files;
@property (strong,nonatomic) NSMutableArray *names;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSMutableArray *subtitles;
@property (strong,nonatomic) NSMutableArray *locations;

- (void)parseXMLFileAtPath:(NSString *)path;



@end


