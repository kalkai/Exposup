//
//  ViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RotateViewController.h"
#import "LanguageManagement.h"
#import "Config.h"
#import "ColorButton.h"
#import "SelectedModViewController.h"
#import "Labels.h"

@interface MainViewController : RotateViewController {
    SelectedModViewController *selectedModView;
    NSString *modText;
}

@property (strong, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *modChoiceLabel;
@property (strong, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (strong, nonatomic) IBOutlet UILabel *sound;
@property (strong, nonatomic) IBOutlet UITextView *foot;

@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) IBOutlet UIButton *languagesButton;

@property (strong, nonatomic) UIButton *checkbox;
@property (assign, nonatomic) bool checkboxSelected;

@property (strong, nonatomic) IBOutlet UIButton *childButton;
@property (strong, nonatomic) IBOutlet UIButton *adultButton;
@property (strong, nonatomic) IBOutlet UIButton *guideButton;

-(void)updateLanguage;

@end
