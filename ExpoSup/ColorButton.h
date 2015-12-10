//
//  ColorButton.h
//  ExpoSup
//
//  Created by Aurélien Lebeau on 25/05/13.
//
//
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "Config.h"

@interface ColorButton : NSObject

+ (UIButton*)getButton;
+(void) configButton: (UIButton*)button;

@end
