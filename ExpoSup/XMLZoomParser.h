//
//  XMLZoomParser.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 10/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "AudioViewController.h"
#import "XMLParser.h"

@interface XMLZoomParser : XMLParser

@property (strong,nonatomic) NSString *imagePath;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSMutableArray *popupContent;
@property (strong,nonatomic) NSMutableArray *upperLeft; // i = x, i+1 = y
@property (strong,nonatomic) NSMutableArray *bottomRight;

@property (strong,nonatomic) NSMutableString *currentProperty;
@property (strong,nonatomic) NSMutableString *currentImage;

@property (strong,nonatomic) NSMutableString *currentContent;
@property (strong,nonatomic) NSMutableString *currentX;
@property (strong,nonatomic) NSMutableString *currentY;

@property(strong,nonatomic) AudioViewController* audio;
@property(strong,nonatomic) NSString *audioFileName;
@property(strong,nonatomic) NSString *audioTitle;
@property(strong,nonatomic) NSString *audioAutostart;
@property(strong,nonatomic) NSString *audioRepetition;


- (Boolean)parseXMLFileAtPath:(NSString *)path;


@end
