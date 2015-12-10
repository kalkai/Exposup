//
//  LanguageManagement.m
//  ExpoSup
//
//  Created by Jean Richelle on 3/01/14.
//
//

#import "LanguageManagement.h"

@implementation LanguageManagement

@synthesize languagesPrefixes, languagesNames, languagesIcons, defautLanguagePrefix, popover, currentView, currentLanguagePrefix, languageButton, isLanguageActivated, currentViewController, popController;

-(Boolean)initialize {
    XMLConfigParser *configParser = [[Config instance] parser];
    
    languagesIcons = configParser.languagesIcons;
    languagesNames = configParser.languagesNames;
    languagesPrefixes = configParser.languagesPrefixes;
    defautLanguagePrefix = configParser.defautLanguagePrefix;
    currentLanguagePrefix = defautLanguagePrefix;
    
    if(languagesIcons.count == 0 && languagesNames.count == 0 && languagesPrefixes.count == 0 && [defautLanguagePrefix isEqualToString: @"null"]) {
        isLanguageActivated = NO;
        currentLanguagePrefix = @""; // Pas de langues donc pas de préfixe
        defautLanguagePrefix = @"";
    } else {
        isLanguageActivated = YES;
    }
    
    if(isLanguageActivated) {
        languageButton = [[LanguageButton alloc] init];
        [languageButton fillWithLabel: [languagesNames objectAtIndex:[languagesPrefixes indexOfObject: currentLanguagePrefix]] andIcon: [languagesIcons objectAtIndex:[languagesPrefixes indexOfObject: currentLanguagePrefix]]];
        
        [languageButton addTarget: self action: @selector(languageButtonClicked:) forControlEvents: UIControlEventTouchUpInside];

    }
    return YES;
}

- (NSString*)defautLanguagePrefix {
    if([defautLanguagePrefix isEqualToString: @""])
        return @"";
    return [defautLanguagePrefix stringByAppendingString: @"_"];
}

- (NSString*)currentLanguagePrefix {
    if([currentLanguagePrefix isEqualToString: @""])
        return @"";
    return [currentLanguagePrefix stringByAppendingString: @"_"];
}

- (UIButton *)addLanguageSelectionButton:(UIView*)view viewController:(UIViewController*)vc {
    if(isLanguageActivated) {
        currentView = view;
        currentViewController = vc;
        [view addSubview: languageButton];
        return languageButton;
    }
    return NULL;
}



- (IBAction)languageButtonClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    //if( [popover isPopoverVisible]) {
    //    [popover dismissPopoverAnimated: YES];
    //}
    //else {
        [self showPopup: button.frame];
        
    //}
}

- (void)showPopup:(CGRect)rect {
    
    popover = [self createLanguagesPopup];
    
    // Before iOS 9
    /*
    popover = [[UIPopoverController alloc] initWithContentViewController: viewControllerToShow];
    popover.popoverContentSize = viewControllerToShow.contentSizeForViewInPopover;
    [popover presentPopoverFromRect: rect
                             inView: currentView
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
    */
    
    
    // After iOS 9
    popover.modalPresentationStyle = UIModalPresentationPopover;
    popover.preferredContentSize = popover.preferredContentSize; //useless
    [currentViewController presentViewController: popover animated:YES completion:nil];
    
    // configure the Popover presentation controller
    popController = [popover popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = currentView;
    popController.sourceRect = languageButton.frame;
    popController.delegate = self;
}


- (UIViewController*)createLanguagesPopup {
    UIViewController *popup = [[UIViewController alloc] init];
    popup.view.backgroundColor = [UIColor clearColor];
    
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 400, 600)];
    view.backgroundColor = [[Config instance] color2];
    int y = 0;
    
    int width = 150;
    int height = 40;
    
    for(int i=0; i<languagesNames.count; ++i) {
        UIButton *tmpButton = [UIButton buttonWithType: UIButtonTypeCustom];
        tmpButton.frame = CGRectMake(0, y, width, height);
        //tmpButton.backgroundColor = [UIColor redColor];
        tmpButton.tag = i;
        
        float languageNameProportion = 0.7;
        float languageIconProportion = 0.3;
        
        UIView *subview = [[UIView alloc] initWithFrame: CGRectMake(0, 0, width, height)];
        subview.userInteractionEnabled = NO;
        subview.exclusiveTouch = NO;
        
        
        UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake(2, 0, width * languageNameProportion, height)];
        title.backgroundColor = [UIColor clearColor];
        title.font = [[Config instance] tinyFont];
        title.textColor = [[Config instance] color1];
        title.textAlignment = UIControlContentHorizontalAlignmentLeft;
        title.text = [languagesNames objectAtIndex: i];
        title.userInteractionEnabled = NO;
        title.exclusiveTouch = NO;
        [subview addSubview: title];
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame: CGRectMake(width*languageNameProportion + 4, 0,width*languageIconProportion - 4,height)];
        icon.image = [UIImage imageWithContentsOfFile: [Config pathForFile: [languagesIcons objectAtIndex: i]]];
        icon.contentMode = UIViewContentModeScaleAspectFit;
        icon.userInteractionEnabled = NO;
        icon.exclusiveTouch = NO;
        
        [subview addSubview: icon];
        
        
        [tmpButton addSubview: subview];
        [tmpButton addTarget: self action: @selector(changeLanguage:) forControlEvents: UIControlEventTouchUpInside];
        
        y += height + 10;
        [view addSubview: tmpButton];
    }
    view.frame = CGRectMake(0, 0, width + 5,  y);
    [popup setPreferredContentSize: view.frame.size];
    [popup.view addSubview: view];
    
    return popup;
}

- (void)changeLanguage:(id)sender {
    NSLog(@"start");
    UIButton *buttonTriggered = (UIButton*)sender;
    int index = buttonTriggered.tag;
    currentLanguagePrefix = [languagesPrefixes objectAtIndex: index];
    //[popover dismissPopoverAnimated: YES];
    [popover dismissViewControllerAnimated:YES completion:nil];

    
    [languageButton fillWithLabel: [languagesNames objectAtIndex:[languagesPrefixes indexOfObject: currentLanguagePrefix]] andIcon: [languagesIcons objectAtIndex:[languagesPrefixes indexOfObject: currentLanguagePrefix]]];

    // update labels and current view
    [[Labels instance] updateLabels];

    [currentViewController.view setNeedsDisplay];
    [currentViewController viewWillDisappear:YES];
    [currentViewController viewDidDisappear:YES];
    [currentViewController viewDidLoad];
    [currentViewController viewWillAppear:YES];
    
    
    NSLog(@"end");
}


/*
+(UIViewController*)getTopController {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return ((UINavigationController*)appDelegate.window.rootViewController).visibleViewController;
}*/

- (NSString*)pathForFile:(NSString*)str contentFile:(Boolean)isContentFile {
    NSString *currentPrefix = [self currentLanguagePrefix];
    NSString *fullName = [currentPrefix stringByAppendingString: str];
    //NSLog(@"1 Full name should be  = %@", fullName);
    
    Boolean currentLanguageFileExists = [[NSFileManager defaultManager] fileExistsAtPath: [Config pathForFile: fullName]];
    if(!currentLanguageFileExists && !isContentFile) {
        currentPrefix = [self defautLanguagePrefix];
        fullName = [currentPrefix stringByAppendingString: str];
        Boolean defaultLanguageFileExists = [[NSFileManager defaultManager] fileExistsAtPath: [Config pathForFile: fullName]];
        
        if(!defaultLanguageFileExists) {// On retourne le fichier sans prefix
             //NSLog(@"2 Short name = %@", str);
            return [Config pathForFile: str];
        }
         //NSLog(@"2 Full name default = %@", fullName);
        return [Config pathForFile: fullName];
    }
    //NSLog(@"2 Full name current = %@", fullName);
    return [Config pathForFile: fullName];
}

+(LanguageManagement*)instance {
    static LanguageManagement *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[LanguageManagement alloc] init];
        if(![instance initialize])
            instance = nil;
    });
    return instance;
}

@end

@implementation LanguageButton
@synthesize label, iconName, title;

- (id) init {
    self.width = 150;
    self.height = 50;
    
    self = [super initWithFrame: CGRectMake(0, 0, self.width, self.height)];
    //[[self layer] setBorderWidth:2.0f];
    //[[self layer] setBorderColor: [[Config instance] color2].CGColor];
    
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void) fillWithLabel:(NSString*)lab andIcon:(NSString*)icon {
    for(UIView *subview in [self subviews]) {
        if(subview.tag == 888)
            [subview removeFromSuperview];
    }
    self.label = lab;
    self.iconName = icon;
    [self addSubview: [self createSubviewForLanguageButton]];
}

- (UIView*)createSubviewForLanguageButton {
    UIView *subview = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.width, self.height)];
    subview.userInteractionEnabled = NO;
    subview.exclusiveTouch = NO;
    
    float languageNameProportion = 0.6;
    float languageIconProportion = 0.3;
    float comboboxIconProportion = 0;
    float emptyProportion = 1 - (languageIconProportion + languageNameProportion + comboboxIconProportion);
    
    title = [[UILabel alloc] initWithFrame: CGRectMake(2, 0, self.width * languageNameProportion, self.height)];
    title.backgroundColor = [UIColor clearColor];
    title.font = [[Config instance] tinyFont];
    title.textColor = [[Config instance] color1];
    title.textAlignment = UIControlContentHorizontalAlignmentLeft;
    title.text = self.label;
    title.userInteractionEnabled = NO;
    title.exclusiveTouch = NO;
    [subview addSubview: title];
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame: CGRectMake(self.width*(languageNameProportion + emptyProportion/2), 0,self.width*languageIconProportion,self.height)];
    icon.image = [UIImage imageWithContentsOfFile: [Config pathForFile: self.iconName]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    icon.userInteractionEnabled = NO;
    icon.exclusiveTouch = NO;
    
    [subview addSubview: icon];
    
    /*UIImageView *comboboxIcon = [[UIImageView alloc] initWithFrame: CGRectMake(self.width*(1-comboboxIconProportion) - 2, 0, self.width*comboboxIconProportion -2, self.height)];
    comboboxIcon.image = [UIImage imageNamed: @"combobox.png"];
    comboboxIcon.contentMode = UIViewContentModeScaleAspectFit;
    comboboxIcon.userInteractionEnabled = NO;
    comboboxIcon.exclusiveTouch = NO;
    
    
    [subview addSubview: comboboxIcon];*/
    
    subview.tag = 888;
    return subview;
}


- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if(highlighted)
        [[self layer] setBorderColor: [UIColor whiteColor].CGColor];
    else
        [[self layer] setBorderColor: [[Config instance] color2].CGColor];
}



@end
