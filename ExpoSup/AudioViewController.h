//
//  AudioViewController.h
//  ExpoSup
//
//  Created by Jean Richelle on 28/09/13.
//
//

#import <UIKit/UIKit.h>
#import "Alerts.h"
#import "Config.h"
#import "ColorButton.h"
#import <AVFoundation/AVFoundation.h>
#import "SectionParentViewController.h"

@interface AudioViewController : UIViewController

@property(strong,nonatomic) NSString *file;
@property(strong,nonatomic) NSString *name;
@property(assign,nonatomic) Boolean autostart;
@property(assign,nonatomic) Boolean repetition;

@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *stopButton;
@property (strong, nonatomic) UIButton *volumeButton;
@property (strong, nonatomic) UILabel *audioComment;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) MPVolumeView *volumeViewSlider;
@property (strong, nonatomic) UIView *currentView;


- (int)createButtonsToView:(UIView *)view Yoffset:(int)y width:(int) width;
- (void)addAudioAndPlayOnceToView:(UIView*)view parent:(SectionParentViewController*)parent;
- (Boolean)addAudioToView: (UIView *)view atY:(int)y width:(int) width startDelayed:(bool)delayed parent:(SectionParentViewController*)parent;
-(void) addVolumeButton:(UIView *)view Yoffset:(int)y Xoffset:(int)x;
-(void)removeVolumeIcon;


- (void)deleteFromView;
- (void)canStart;

- (IBAction)playButtonClicked:(id)sender;
- (IBAction)pauseButtonClicked:(id)sender;
- (IBAction)stopButtonClicked:(id)sender;
- (Boolean)tryToStop:(id)sender;

@end
