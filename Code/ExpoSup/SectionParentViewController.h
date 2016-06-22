//
//  SectionViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 25/03/13.
//
//

#import <UIKit/UIKit.h>
#import "ColorButton.h"
#import "Config.h"
#import "RotateViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface SectionParentViewController : RotateViewController

@property (strong, nonatomic) UISwipeGestureRecognizer *gesture;
@property (strong, nonatomic) UIView *swipeArea;
@property (strong, nonatomic) UIImageView* animationView;
@property (strong, nonatomic) UILabel* volumeLabel;
@property (strong, nonatomic) MPVolumeView *volumeViewSlider;

@property (strong, nonatomic) IBOutlet UIButton *returnButton;
@property (strong, nonatomic) IBOutlet UIButton *scanButton;
@property (strong, nonatomic) IBOutlet UIButton *scanBeaconButton;
@property (assign, nonatomic) Boolean showReturn;
@property (assign, nonatomic) Boolean isPageWithAudio;

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) NSNumber *numberOfPagesToPop;


- (BOOL)prefersStatusBarHidden;
- (IBAction)popView:(id)sender;
- (IBAction)popToScanView:(id)sender;
- (IBAction)popToScanBeaconView:(id)sender;
- (void)createBackButtons;


@end
