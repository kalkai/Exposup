//
//  BeaconViewController.h
//  exposup
//
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "RotateViewController.h"
#import "Config.h"
#import "ColorButton.h"
#import "XMLSectionParser.h"
#import "LanguageManagement.h"
#import "Alerts.h"
#import "Labels.h"
#import "SectionViewController.h"
#import "ViewController.h"
#import "BeaconManagerDelegate.h"
#import "XMLSectionParser.h"
#import "XMLBeaconParsers.h"

@interface BeaconViewController : RotateViewController <UIPopoverPresentationControllerDelegate,UITableViewDataSource, BeaconManagerDelegate,UITableViewDelegate>

@property (strong,nonatomic) NSString *result;
@property (strong,nonatomic) NSString *argument;

@property (strong, nonatomic) UIView *scannerContainer;
@property (strong,nonatomic) NSString *file;

@property (strong, nonatomic) UILabel *expoTitle;
@property (strong, nonatomic) UILabel *BeaconInfo;
@property (strong, nonatomic) NSString *AreaLabel;
@property (strong, nonatomic) UIButton *toID;
@property (strong, nonatomic) UIImageView *banner;
@property (strong, nonatomic) UIViewController *popover;
@property (strong, nonatomic) UIPopoverPresentationController *popController;
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *languagesButton;
@property (strong, nonatomic)  IBOutlet UITableView *tableView;
@property (strong, nonatomic) AppDelegate * beaconManager;
@property (strong, nonatomic) XMLBeaconParsers *index;
@property(strong, nonatomic)NSMutableArray *SectionKeyArray;

//@property(nonatomic, strong) UITableView *tableView;



-(IBAction)printInfoPopup:(id)sender;
-(IBAction)hideInfoPopup:(id)sender;

-(void)updateLanguage;

@end

@protocol BeaconViewControllerDelegate <NSObject>

@optional

- (void) BeaconViewController:(BeaconViewController*) aCtler didTapToFocusOnPoint:(CGPoint) aPoint;
- (void) BeaconViewController:(BeaconViewController*) aCtler didSuccessfullyScan:(NSString *) aScannedValue;



@end
