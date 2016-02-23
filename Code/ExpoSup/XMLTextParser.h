//
//  XMLTextParser.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 4/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "AudioViewController.h"
#import "XMLParser.h"

@interface XMLTextParser : XMLParser

@property (strong,nonatomic) NSString *currentText;
@property (strong,nonatomic) NSString *title;

@property (strong,nonatomic) NSMutableString *currentProperty;

@property (strong,nonatomic) NSString *currentImage;
@property (strong,nonatomic) NSString *currentComment;
@property (strong,nonatomic) NSString *currentSource;
@property (strong,nonatomic) NSString *currentLink;
@property (strong,nonatomic) NSString *currentLinkType;
@property (strong,nonatomic) NSString *currentLinkContour;
@property (assign,nonatomic) NSString *currentAdjust;
@property (strong,nonatomic) NSString *currentLocation;
@property (strong,nonatomic) NSString *currentSubtitle;
@property (strong,nonatomic) NSString *currentSynopsis;
@property (strong,nonatomic) NSString *currentParagraph;


@property (strong,nonatomic) NSString *currentCitation;
@property (strong,nonatomic) NSString *currentAuthor;

@property (strong,nonatomic) NSMutableArray *results;


@property (strong,nonatomic) NSMutableArray *paragraphs;
@property (strong,nonatomic) NSMutableArray *synopsis;
@property (strong,nonatomic) NSMutableArray *images;
@property (strong,nonatomic) NSMutableArray *comments;
@property (strong,nonatomic) NSMutableArray *sources;
@property (strong,nonatomic) NSMutableArray *links;
@property (strong,nonatomic) NSMutableArray *linksTypes;
@property (strong,nonatomic) NSMutableArray *linksContours;
@property (strong,nonatomic) NSMutableArray *adjusts;
@property (strong,nonatomic) NSMutableArray *subtitles;
@property (strong,nonatomic) NSMutableArray *locations;


@property (strong,nonatomic) NSMutableArray *citations;
@property (strong,nonatomic) NSMutableArray *authors;


@property(assign,nonatomic) Boolean audio;
@property(strong,nonatomic) AudioViewController* currentAudio;
@property(strong,nonatomic) NSString *audioFileName;
@property(strong,nonatomic) NSString *audioTitle;
@property(strong,nonatomic) NSString *audioAutostart;
@property(strong,nonatomic) NSString *audioRepetition;

- (Boolean)parseXMLFileAtPath:(NSString *)path;



@end
