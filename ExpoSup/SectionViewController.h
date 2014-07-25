//
//  SectionViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 30/03/13.
//
//

#import <UIKit/UIKit.h>
#import "SectionParentViewController.h"
#import "TextViewController.h"
#import "SlideshowViewController.h"
#import "MovieViewController.h"
#import "QuizViewController.h"
#import "AnimateImageViewController.h"
#import "ImageZoomViewController.h"
#import "XMLSectionParser.h"
#import "ColorButton.h"
#import "Alerts.h"
#import "AudioViewController.h"


@interface SectionViewController : SectionParentViewController


@property (strong, nonatomic) AudioViewController *audioController;
@property (strong, nonatomic) IBOutlet UILabel *sectionTitle;
@property (strong, nonatomic) XMLSectionParser *parser;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *argument;
@property (assign, nonatomic) int lastAudioPlayed;
@property (strong, nonatomic) NSMutableArray *buttonsList;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) MPVolumeView *volumeViewSlider;

- (id)initWithFileToParse:(NSString *)fileName;

-(IBAction)toSlideshow:(id)sender;
-(IBAction)toText:(id)sender;
-(IBAction)toMovie:(id)sender;
-(IBAction)toAnimateImage:(id)sender;
-(IBAction)playButtonClicked:(id)sender;
-(IBAction)pauseButtonClicked:(id)sender;
-(IBAction)stopButtonClicked:(id)sender;


@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) UIButton *volumeButton;

@property (assign, nonatomic) int audioPlayerNr;
@property (strong, nonatomic) NSMutableArray *audioPlayers;
@property (strong, nonatomic) NSMutableArray *audioPlayersAssociatedIndex; //index of parser result

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;

@end
