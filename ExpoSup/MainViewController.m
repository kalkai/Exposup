//
//  ViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MainViewController.h"

@implementation MainViewController

@synthesize welcomeLabel, modChoiceLabel, childButton, adultButton, guideButton, checkbox,soundSwitch, checkboxSelected, sound, foot, popover, languagesButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear: animated];
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([Config instance] != nil) {
        languagesButton = [[LanguageManagement instance] addLanguageSelectionButton: self.view];
    }
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        languagesButton.frame = CGRectMake(1024 - languagesButton.frame.size.width - 10 , 5, languagesButton.frame.size.width, languagesButton.frame.size.height);
        foot.frame = CGRectMake(15, 610, 1024-15, 160);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        languagesButton.frame = CGRectMake(768 - languagesButton.frame.size.width - 10 , 5, languagesButton.frame.size.width, languagesButton.frame.size.height);
        foot.frame = CGRectMake(15, 890, 768-15, 130);
    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    if ([Config instance] != nil) {
        NSLog(@"Config instance not nil... = %@",[Config instance]);
        [self setBackgroundImage: [[Config instance] backgroundPortrait]];
        
        //titre
        
        welcomeLabel.text = [[Labels instance] welcomeTitle];
        welcomeLabel.font = [[Config instance] bigFont];
        welcomeLabel.textColor = [[Config instance] color1];
        welcomeLabel.backgroundColor = [UIColor clearColor];
        [welcomeLabel sizeToFit];
        // on va placer le label au centre. On prend la moitié de l'écran et on décale à gauche de la moitié du label.
        //welcomeLabel.frame = CGRectMake(self.view.frame.size.width/2 - welcomeLabel.frame.size.width/2, 100, welcomeLabel.frame.size.width, welcomeLabel.frame.size.height);
        welcomeLabel.numberOfLines = 2;
        [self.view addSubview: welcomeLabel];
        
        //choix du mode
        modChoiceLabel.text = [[Labels instance] chooseModLabel];
        modChoiceLabel.font = [[Config instance] bigFont];
        modChoiceLabel.textColor = [[Config instance] color1];
        modChoiceLabel.backgroundColor = [UIColor clearColor];
        [modChoiceLabel sizeToFit];
        // on va placer le label au centre. On prend la moitié de l'écran et on décale à gauche de la moitié du label.
        modChoiceLabel.frame = CGRectMake(self.view.frame.size.width/2 - modChoiceLabel.frame.size.width/2, 650, modChoiceLabel.frame.size.width, modChoiceLabel.frame.size.height);
        modChoiceLabel.numberOfLines = 2;
        [self.view addSubview: modChoiceLabel];
        
        
        foot = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, 768, 10)];
        foot.text = [[Labels instance] credits];
        foot.textColor = [[Config instance] color1];
        foot.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
        foot.font = [[Config instance] smallFont];
        foot.numberOfLines = 0;
        [foot sizeToFit];
        [self.view addSubview: foot];
       
        
        [self createModsButtons];
        [self createCheckboxSound];
    
    }
}

- (void)createModsButtons {
    
    [ColorButton configButton: adultButton];
    [adultButton addTarget:self action:@selector(selectAdult:) forControlEvents:UIControlEventTouchUpInside];
    [adultButton setTitle:[[Labels instance] adultButton] forState: UIControlStateNormal];
    [self.view addSubview: adultButton];
    
    if([[Config instance] showChildMode]) {
        
        [ColorButton configButton: childButton];
        [childButton addTarget:self action:@selector(selectChild:) forControlEvents:UIControlEventTouchUpInside];
        [childButton setTitle:[[Labels instance] childButton] forState: UIControlStateNormal];
        [self.view addSubview: childButton];
    }
    else childButton.hidden = YES;
    
    if([[Config instance] showGuideMode]) {
        
        [ColorButton configButton: guideButton];
        [guideButton addTarget:self action:@selector(selectGuide:) forControlEvents:UIControlEventTouchUpInside];
        [guideButton setTitle:[[Labels instance] guideButton] forState: UIControlStateNormal];
        [self.view addSubview: guideButton];
    }
    else guideButton.hidden = YES;
}

- (void)createCheckboxSound {
    [Config instance].audioOn = YES;
    [sound setFont: [[Config instance] normalFont]];
    [sound setText: [[Labels instance] soundButtonLabel]];
    [sound setTextColor: [[Config instance] color1]];
    [soundSwitch addTarget: self action: @selector(checkboxSelected:) forControlEvents:UIControlEventValueChanged];
    [soundSwitch setOnTintColor: [[Config instance] color2]];
    [soundSwitch setTintColor: [[Config instance] color1]];
}

-(void)checkboxSelected: (id)sender {
   [Config instance].audioOn = ((UISwitch *)sender).on;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        if(languagesButton != NULL)
            languagesButton.frame = CGRectMake(1024 - languagesButton.frame.size.width - 10 , 5, languagesButton.frame.size.width, languagesButton.frame.size.height);
        foot.frame = CGRectMake(15, 610, 1024-15, 160);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        if(languagesButton != NULL)
            languagesButton.frame = CGRectMake(768 - languagesButton.frame.size.width - 10 , 5, languagesButton.frame.size.width, languagesButton.frame.size.height);
        foot.frame = CGRectMake(15, 890, 768-15, 130);
    }
    
}

-(void)selectAdult:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.mod = @"Adult";
    
    if(![[Config instance] showChildMode] && ![[Config instance] showGuideMode]) {
        [self performSegueWithIdentifier:@"fromStartToScan" sender: self];
    }
    else {
        [self performSegueWithIdentifier:@"toMods" sender: self];
    }
}

-(void)selectChild:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.mod = @"Child";
    
    if(![[Config instance] showChildMode] && ![[Config instance] showGuideMode]) {
        [self performSegueWithIdentifier:@"fromStartToScan" sender: self];
    }
    else {
        [self performSegueWithIdentifier:@"toMods" sender: self];
    }
}

-(void)selectGuide:(id)sender {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    appDelegate.mod = @"Guide";
    
    if(![[Config instance] showChildMode] && ![[Config instance] showGuideMode]) {
        [self performSegueWithIdentifier:@"fromStartToScan" sender: self];
    }
    else {
        [self performSegueWithIdentifier:@"toMods" sender: self];
    }
}


-(void)updateLanguage {
    welcomeLabel.text = [[Labels instance] welcomeTitle];
    sound.text =  [[Labels instance] soundButtonLabel];
    modChoiceLabel.text =  [[Labels instance] chooseModLabel];
    
    adultButton.titleLabel.text =  [[Labels instance] adultButton];
    childButton.titleLabel.text =  [[Labels instance] childButton];
    guideButton.titleLabel.text =  [[Labels instance] guideButton];
}


@end
