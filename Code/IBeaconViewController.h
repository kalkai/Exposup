//
//  ScanViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 21/03/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RotateViewController.h"
#import "Config.h"
#import "ColorButton.h"
#import "XMLSectionParser.h"
#import "SectionViewController.h"
#import "LanguageManagement.h"
#import "Alerts.h"
#import "Labels.h"

@protocol IBeaconViewController;

@interface IBeaconViewController : RotateViewController <UIPopoverPresentationControllerDelegate>

@property (strong,nonatomic) NSString *result;
@property (strong,nonatomic) NSString *argument;

@property (strong, nonatomic) UIView *scannerContainer;
@property (strong,nonatomic) NSString *file;

@property (strong, nonatomic) UILabel *expoTitle;
@property (strong, nonatomic) UILabel *scanInstruction;
@property (strong, nonatomic) UIButton *toID;
@property (strong, nonatomic) UIImageView *banner;
@property (strong, nonatomic) UIViewController *popover;
@property (strong, nonatomic) UIPopoverPresentationController *popController;
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *languagesButton;



-(IBAction)printInfoPopup:(id)sender;
-(IBAction)hideInfoPopup:(id)sender;

-(void)updateLanguage;

@end

@protocol IBeaconViewControllerDelegate <NSObject>

@optional

- (void) IBeaconViewController:(IBeaconViewController*) aCtler didTapToFocusOnPoint:(CGPoint) aPoint;
- (void) IBeaconViewController:(IBeaconViewController*) aCtler didSuccessfullyScan:(NSString *) aScannedValue;

@end
