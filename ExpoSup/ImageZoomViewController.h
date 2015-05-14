//
//  ImageZoomViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 10/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionParentViewController.h"
#import "XMLZoomParser.h"
#import "LanguageManagement.h"




@interface ImageZoomViewController : SectionParentViewController <UIScrollViewDelegate>

@property (assign, nonatomic) NSString *fileName;
@property (assign, nonatomic) float currentScale;
@property (strong, nonatomic) IBOutlet UILabel *titleScreen;

@property (strong, nonatomic) XMLZoomParser *parser;
@property (strong, nonatomic) UIView *opacity;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *clickingFrames;
@property (strong,nonatomic) UITapGestureRecognizer *tapGr;
@property (strong, nonatomic) UIPopoverController *popover;

@end
