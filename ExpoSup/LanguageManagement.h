//
//  LanguageManagement.h
//  ExpoSup
//
//  Created by Jean Richelle on 3/01/14.
//
//
#import "Config.h"
#import "AppDelegate.h"
#import "XMLConfigParser.h"
#import "Labels.h"
#import "RotateViewController.h"
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@class LanguageButton;
@interface LanguageManagement : NSObject<UIPopoverPresentationControllerDelegate>

@property (strong,nonatomic) NSString *currentLanguagePrefix;

@property (assign,nonatomic) Boolean isLanguageActivated;

@property (strong,nonatomic) NSMutableArray *languagesNames;
@property (strong,nonatomic) NSMutableArray *languagesPrefixes;
@property (strong,nonatomic) NSMutableArray *languagesIcons;
@property (strong,nonatomic) NSString *defautLanguagePrefix;

@property (strong, nonatomic) UIViewController *popover;
@property (strong, nonatomic) UIPopoverPresentationController *popController;
@property (strong, nonatomic) UIView* currentView;
@property (strong, nonatomic) UIViewController* currentViewController;


@property (strong, nonatomic) LanguageButton *languageButton;


- (Boolean)initialize;
- (UIButton *)addLanguageSelectionButton:(UIView*) view viewController:(UIViewController*)vc;
- (NSString*)pathForFile:(NSString*)str contentFile:(Boolean)isContentFile;

- (NSString*)defautLanguagePrefix;
- (NSString*)currentLanguagePrefix;

+(LanguageManagement*)instance;
//+(UIViewController*)getTopController;

@end

@interface LanguageButton : UIButton

@property (assign, nonatomic) int width;
@property (assign, nonatomic) int height;

@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *iconName;

@property (strong, nonatomic) UILabel *title;

- (id) init;
- (void) fillWithLabel:(NSString*)label andIcon:(NSString*)iconName;

- (void) setHighlighted:(BOOL)highlighted;

@end
