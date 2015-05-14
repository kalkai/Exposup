//
//  TextViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 4/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "SectionParentViewController.h"
#import "ImageZoomViewController.h"
#import "MovieViewController.h"
#import "SlideshowViewController.h"
#import "XMLTextParser.h"
#import "XMLDictionaryParser.h"
#import "AudioViewController.h"
#import "SectionViewController.h"


@interface TextViewController : SectionParentViewController <UIScrollViewDelegate>

@property (strong, nonatomic) NSMutableArray *views;

@property (assign, nonatomic) int coordY;
@property (assign, nonatomic) int currentWidth;
@property (strong, nonatomic) NSMutableDictionary *buttonToParagraphIdx;
@property (strong, nonatomic) NSMutableDictionary *buttonToParagraphView;
@property (strong, nonatomic) NSMutableDictionary *expandedParagraph;
@property (strong, nonatomic) NSMutableDictionary *isParagraphOpen;
@property (strong, nonatomic) NSMutableDictionary *superiorLines;
@property (strong, nonatomic) NSMutableDictionary *inferiorLines;
@property (strong, nonatomic) UILabel *titleScreen;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPopoverController *popover;

@property (assign,nonatomic) NSString *standID;
@property (strong,nonatomic) AudioViewController *audioController;
@property (strong,nonatomic) UITapGestureRecognizer *tapGr;
@property (strong,nonatomic) NSMutableArray *clickingFrames;
@property (strong,nonatomic) NSMutableArray *commentToPopup;
@property (strong,nonatomic) NSMutableArray *buttonsList;
@property (strong,nonatomic) XMLTextParser *parser;

@property (strong, nonatomic) NSMutableString *argument;


- (void)touches;
- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView*)textView;

@end
