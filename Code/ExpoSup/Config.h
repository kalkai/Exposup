//
//  Config.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 23/03/13.
//
//

#import <Foundation/Foundation.h>
#import "XMLConfigParser.h"
#import "Alerts.h"
#import "LanguageManagement.h"



@interface Config : NSObject

@property (strong,nonatomic) XMLConfigParser *parser;

typedef enum {
    FONT_BIG = 0,
    FONT_NORMAL = 1,
    FONT_SMALL = 2,
    FONT_TINY = 3,
    FONT_QUOTE = 4
} ConfigErrorType;

@property (strong,nonatomic) NSString *mode;
@property (assign,nonatomic) Boolean audioOn;
@property (strong,nonatomic) NSMutableArray* errors;
@property (strong,nonatomic) NSMutableArray* errorsFont;

- (Boolean)initialize;
- (Boolean)parseConfigFile;
- (Boolean)audioOn;
- (NSMutableArray*)getErrors;
- (NSMutableArray*)getErrorsFont;

- (Boolean)showChildMode;
- (Boolean)showGuideMode;

- (NSString*) backgroundPortrait;
- (NSString*) backgroundLandscape;
- (NSString*) backButtonToScan;
- (NSString*) infoButton;

- (UIImage*) banner;

- (UIFont*) bigFont;
- (UIFont*) normalFont;
- (UIFont*) smallFont;
- (UIFont*) tinyFont;
- (UIFont*) quoteFont;
- (int) bigFontSize;
- (int) normalFontSize;
- (int) smallFontSize;
- (int) tinyFontSize;
- (int) quoteFontSize;

- (UIColor*) color1;
- (UIColor*) color2;
- (UIColor*) color3;
- (UIColor*) color4;
- (UIColor*) color5;
- (UIColor*) color6;
- (UIColor*) color6Full;

- (float) opacity;





- (UIColor*)colorForArray:(NSArray*) array opacity:(float)opacity;


- (void)setMode:(NSString *)mod;

+(Config*)instance;
+(NSString*)pathForFile:(NSString*)str;



@end
