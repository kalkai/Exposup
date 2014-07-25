//
//  ScanViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 21/03/13.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "RotateViewController.h"
#import "Config.h"
#import "ColorButton.h"
#import "XMLSectionParser.h"
#import "SectionViewController.h"
#import "LanguageManagement.h"
#import "Alerts.h"
#import "Labels.h"

@interface ScanViewController : RotateViewController <ZBarReaderViewDelegate>

@property (strong,nonatomic) NSString *result;

@property (strong, nonatomic) UIView *scannerContainer;
@property (strong,nonatomic) ZBarReaderView *reader;
@property (strong,nonatomic) NSString *file;

@property (strong, nonatomic) UILabel *expoTitle;
@property (strong, nonatomic) UILabel *scanInstruction;
@property (strong, nonatomic) UIButton *toID;
@property (strong, nonatomic) UIImageView *banner;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *languagesButton;



-(void)readerView:(ZBarReaderView*)reader didReadSymbols: (ZBarSymbolSet*) symbols fromImage:(UIImage *) image;

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration;
-(IBAction)printInfoPopup:(id)sender;
-(IBAction)hideInfoPopup:(id)sender;

-(void)updateLanguage;

@end
