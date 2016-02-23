//
//  XMLSlideshowParser.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 5/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "AudioViewController.h"
#import "XMLParser.h"

@interface XMLSlideshowParser : XMLParser

@property (assign,nonatomic) int nSlides;

@property (strong,nonatomic) NSString *title;
@property(strong,nonatomic) AudioViewController* currentAudio;
@property(strong,nonatomic) NSString *audioFileName;
@property(strong,nonatomic) NSString *audioTitle;
@property(strong,nonatomic) NSString *audioAutostart;
@property(strong,nonatomic) NSString *audioRepetition;

@property (strong,nonatomic) NSMutableArray *images;
@property (strong,nonatomic) NSMutableArray *comments;
@property (strong,nonatomic) NSMutableArray *audios;

@property (strong,nonatomic) NSMutableString *currentImagePath;
@property (strong,nonatomic) NSMutableString *currentComment;
@property (strong,nonatomic) NSMutableString *currentProperty;

- (Boolean)parseXMLFileAtPath:(NSString *)path;



@end
