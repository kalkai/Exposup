//
//  XMLAnimateImageParser.h
//  ExpoSup
//
//  Created by Aurélien Lebeau on 28/07/13.
//
//

#import <Foundation/Foundation.h>
#import "Config.h"
#import "Alerts.h"
#import "AudioViewController.h"

@interface XMLAnimateImageParser : NSObject <NSXMLParserDelegate>

@property(strong,nonatomic) AudioViewController* audioFile;
@property(strong,nonatomic) NSString *audioFileName;
@property(strong,nonatomic) NSString *audioTitle;
@property(strong,nonatomic) NSString *audioAutostart;
@property(strong,nonatomic) NSString *audioRepetition;

@property(strong,nonatomic) NSMutableArray* images;
@property(strong,nonatomic) NSString* duration;

@property(strong,nonatomic) NSString* title;
@property(strong,nonatomic) NSString* comment;

@property(assign,nonatomic) Boolean autostart;
@property(assign,nonatomic) Boolean repetition;

@property(strong,nonatomic) NSMutableString* currentProperty;



- (void)parseXMLFileAtPath:(NSString *)path;


@end
