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

@protocol ScanViewControllerDelegate;

@interface ScanViewController : RotateViewController <UIPopoverPresentationControllerDelegate, AVCaptureMetadataOutputObjectsDelegate>

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

// Useful for the QR code scanner
@property (nonatomic, weak) id<ScanViewControllerDelegate> delegate;
@property (strong, nonatomic) AVCaptureDevice* device;
@property (strong, nonatomic) AVCaptureDeviceInput* input;
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureMetadataOutput *output;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer* preview;
- (void) startScanning;
- (void) stopScanning;


-(IBAction)printInfoPopup:(id)sender;
-(IBAction)hideInfoPopup:(id)sender;

-(void)updateLanguage;

@end

@protocol ScanViewControllerDelegate <NSObject>

@optional

- (void) scanViewController:(ScanViewController*) aCtler didTapToFocusOnPoint:(CGPoint) aPoint;
- (void) scanViewController:(ScanViewController*) aCtler didSuccessfullyScan:(NSString *) aScannedValue;

@end
