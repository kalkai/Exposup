//
//  IDChoiceViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 3/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageManagement.h"
#import "SectionParentViewController.h"
#import "SectionViewController.h"
#import "XMLSectionParser.h"
#import "XMLIndexParser.h"
#import "Alerts.h"
#import "Labels.h"

@interface IDChoiceViewController : SectionParentViewController

@property (strong, nonatomic) UILabel *expoTitle;
@property (strong, nonatomic) UILabel *idInfo;
@property (strong, nonatomic) UITextField *idTextfield;
@property (strong, nonatomic) UIButton *goButton;
@property (strong, nonatomic) UIImageView *banner;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIButton *infoButton;
@property (strong, nonatomic) UIButton *languagesButton;

@property (strong, nonatomic) NSString *file;

- (IBAction)parseFileAndProceed:(id)sender;
- (IBAction)popView:(id)sender ;
-(IBAction)printInfoPopup:(id)sender;
-(IBAction)hideInfoPopup:(id)sender;

@end
