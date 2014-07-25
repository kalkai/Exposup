//
//  Config.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 23/03/13.
//
//

#import "Config.h"


@implementation Config

@synthesize parser,mode, audioOn;

- (Boolean)initialize {

    if(![self parseConfigFile])
        return false;

    return true;
}


- (Boolean)parseConfigFile {
    parser = [[XMLConfigParser alloc] init];
    if(![parser parseXMLFile])
        return false;
    return true;
}

- (Boolean)showChildMode {return parser.showChildMode;};
- (Boolean)showGuideMode {return parser.showGuideMode;};
- (Boolean)audioOn {return audioOn;};

- (NSString*) backgroundPortrait { return [[LanguageManagement instance] pathForFile: parser.backgroundPortrait contentFile: NO]; };
- (NSString*) backgroundLandscape { return [[LanguageManagement instance] pathForFile: parser.backgroundLandscape contentFile: NO]; };
- (NSString*) backButtonToScan { return [[LanguageManagement instance] pathForFile: parser.backButtonToScan contentFile: NO]; };
- (NSString*) infoButton { return [[LanguageManagement instance] pathForFile: @"info.png" contentFile: NO]; };

- (UIImage*) banner {
    return [UIImage imageWithContentsOfFile: [[LanguageManagement instance] pathForFile: [parser banner] contentFile: NO]];
}

- (UIFont*) bigFont {
    if(parser.bigFont == nil || parser.bigFontSize == nil) {
        NSLog(@"grande police non reconnue");        
    }
    else if([UIFont fontWithName: parser.bigFont size: [parser.bigFontSize intValue]] != nil) {
        return [UIFont fontWithName: parser.bigFont size: [parser.bigFontSize intValue]];
    }
    
    Alerts *alert = [[Alerts alloc] init];
    [alert showPoliceNotFoundAlert:self name: parser.bigFont num: 1];
    
    return [UIFont systemFontOfSize:3];
}


- (UIFont*) normalFont {
    if(parser.normalFont == nil || parser.normalFontSize == nil) {
        NSLog(@"normal police non reconnue");
        
    }
    else if ([UIFont fontWithName: parser.normalFont size: [parser.normalFontSize intValue]] != nil)
        return [UIFont fontWithName: parser.normalFont size: [parser.normalFontSize intValue]];
    
    Alerts *alert = [[Alerts alloc] init];
    [alert showPoliceNotFoundAlert:self name: parser.normalFont num: 2];
    return [UIFont systemFontOfSize:3];
}


- (UIFont*) smallFont {
    if(parser.smallFont == nil || parser.smallFontSize == nil) {
        NSLog(@"petite police non reconnue");
    }
    else if([UIFont fontWithName: parser.smallFont size: [parser.smallFontSize intValue]] != nil)
        return [UIFont fontWithName: parser.smallFont size: [parser.smallFontSize intValue]];
    
    Alerts *alert = [[Alerts alloc] init];
    [alert showPoliceNotFoundAlert:self name: parser.smallFont num: 3];
    return [UIFont systemFontOfSize:3];
}


- (UIFont*) tinyFont {
    if(parser.tinyFont == nil || parser.tinyFontSize == nil) {
        NSLog(@"tres petite police non reconnue");
    }
    else if([UIFont fontWithName: parser.tinyFont size: [parser.tinyFontSize intValue]] != nil)
        return [UIFont fontWithName: parser.tinyFont size: [parser.tinyFontSize intValue]];
    
    Alerts *alert = [[Alerts alloc] init];
    [alert showPoliceNotFoundAlert:self name: parser.tinyFont num: 4];
    return [UIFont systemFontOfSize:3];
}

- (UIFont*) quoteFont {
    if(parser.quoteFont == nil || parser.quoteFontSize == nil) {
        NSLog(@"citation police non reconnue");
    }
    else if([UIFont fontWithName: parser.quoteFont size: [parser.quoteFontSize intValue]] != nil){
        return [UIFont fontWithName: parser.quoteFont size: [parser.quoteFontSize intValue]];
    }
    
    Alerts *alert = [[Alerts alloc] init];
    [alert showPoliceNotFoundAlert:self name: parser.quoteFont num: 5];
    return [UIFont systemFontOfSize:33];
}


- (int) bigFontSize {
    if(parser.bigFontSize != nil) {
        return [parser.bigFontSize intValue];
    }
    return 3;
}

- (int) normalFontSize {
    if(parser.normalFontSize != nil) {
        return [parser.normalFontSize intValue];
    }
    return 3;
}

- (int) smallFontSize {
    if(parser.smallFontSize != nil) {
        return [parser.smallFontSize intValue];
    }
    return 3;
}

- (int) tinyFontSize {
    if(parser.tinyFontSize != nil) {
        return [parser.tinyFontSize intValue];
    }
    return 3;
}

- (int) quoteFontSize {
    if(parser.quoteFontSize != nil) {
        return [parser.quoteFontSize intValue];
    }
    return 3;
}


- (UIColor*)colorForArray:(NSArray*) array opacity:(float)opacity{
    int r,g,b;
    if(array.count == 3) {
        r = [[array objectAtIndex:0] intValue];
        g = [[array objectAtIndex:1] intValue];
        b = [[array objectAtIndex:2] intValue];
        return [UIColor colorWithRed: r/255.0f  green: g/255.0f  blue: b/255.0f  alpha:opacity];
    }
    return nil;
}

- (UIColor*) color1 {
    UIColor *color = [self colorForArray: parser.color1 opacity:1];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (UIColor*) color2 {
    UIColor *color = [self colorForArray: parser.color2 opacity:1];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (UIColor*) color3 {
    UIColor *color = [self colorForArray: parser.color3 opacity:1];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (UIColor*) color4 {
    UIColor *color = [self colorForArray: parser.color4 opacity:1];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (UIColor*) color5 {
    UIColor *color = [self colorForArray: parser.color5 opacity:1];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (UIColor*) color6 { 
    UIColor *color = [self colorForArray: parser.color6 opacity:0.3];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (UIColor*) color6Full {
    UIColor *color = [self colorForArray: parser.color6 opacity:1];
    if(!color) {
        NSLog(@"couleur nulle");
        return [UIColor redColor];
    }
    return color;
}

- (float) opacity {
    return parser.opacity;
}








+(Config*)instance {
    static Config *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Config alloc] init];
        if(![instance initialize])
            instance = nil;
    });
    return instance;
}

+(NSString*)pathForFile:(NSString*)str {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSLog(@"files %@", paths);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString: [@"/" stringByAppendingString: str]];
    //NSLog(@"filepath %@", filePath);
    return filePath;
}






@end
