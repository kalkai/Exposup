//
//  SlideshowViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 5/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SectionParentViewController.h"
#import "XMLSlideshowParser.h"
#import "AudioViewController.h"

@interface SlideshowViewController : SectionParentViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) NSString *standID;
@property (strong, nonatomic) XMLSlideshowParser *parser;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) int currentID;
@property (strong, nonatomic) AudioViewController *currentAudio;

@property (assign, nonatomic) CGRect portraitFrame;
@property (assign, nonatomic) CGRect landscapeFrame;

@property (assign, nonatomic) CGRect portraitImageFrame;
@property (assign, nonatomic) CGRect landscapeImageFrame;
@property (assign, nonatomic) CGRect currentImageFrame;

@property (assign, nonatomic) CGRect portraitCommentFrame;
@property (assign, nonatomic) CGRect landscapeCommentFrame;
@property (assign, nonatomic) CGRect currentCommentFrame;

@property (assign, nonatomic) int portraitAudioOffset;
@property (assign, nonatomic) int landscapeAudioOffset;
@property (assign, nonatomic) int currentAudioOffset;
@property (strong, nonatomic) UILabel *sectionTitle;





- (CGRect)createFrameFromPoint:(int)x;

- (void)goToNext:(id)sender;
- (void)goToPrevious:(id)sender;

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView;

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;


@end
