//
//  IDChoiceViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 3/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "IDChoiceViewController.h"

@implementation IDChoiceViewController
@synthesize idTextfield, file, expoTitle, goButton, banner, popover, infoButton, idInfo, languagesButton, argument, popController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    languagesButton = [[LanguageManagement instance] addLanguageSelectionButton: self.view viewController: self];
    
    [super viewWillAppear: animated];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self createSubviewsForPortrait];
    }
    //[idTextfield becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 
 }*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.showReturn = false;
    [[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //label scan
    expoTitle = [[UILabel alloc] init];
    expoTitle.text = [[Labels instance] expoTitle];
    expoTitle.font = [[Config instance] bigFont];
    expoTitle.textColor = [[Config instance] color1];
    expoTitle.backgroundColor = [UIColor clearColor];
    [expoTitle sizeToFit];
    expoTitle.numberOfLines = 2;
    [self.view addSubview: expoTitle];
    
    
    //banner
    if([[Config instance] banner] != nil) {
        banner = [[UIImageView alloc] init];
        banner.image = [[Config instance] banner];
        [self.view addSubview: banner];
    }
    
    //info button
    infoButton = [UIButton buttonWithType: UIButtonTypeCustom];
    infoButton.frame = CGRectMake(0, 0, 40, 40);
    [infoButton setBackgroundImage: [UIImage imageNamed: @"info.png"] forState:UIControlStateNormal];

    [infoButton addTarget: self action: @selector(printInfoPopup:) forControlEvents: UIControlEventTouchUpInside];
    [infoButton addTarget: self action: @selector(hideInfoPopup:) forControlEvents: UIControlEventTouchUpOutside];
    [self.view addSubview: infoButton];
    
    //go button
    goButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [ColorButton configButton: goButton];
    goButton.frame = CGRectMake(0, 0, 200 , 50);
    [goButton setTitle: [[Labels instance] validateButton] forState: UIControlStateNormal];
    [goButton addTarget: self action: @selector(parseFileAndProceed:) forControlEvents: UIControlEventTouchUpInside];
    [self.view addSubview: goButton];
    

    idTextfield = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 200, 50)];
    idTextfield.borderStyle = UITextBorderStyleRoundedRect;
    idTextfield.font = [[Config instance] normalFont];
    idTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    idTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    idTextfield.clearButtonMode = UITextFieldViewModeAlways;
    idTextfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    idTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview: idTextfield];
    
    //cam info
    idInfo = [[UILabel alloc] init];
    idInfo.text = [[Labels instance] IDInstruction];
    idInfo.font = [[Config instance] smallFont];
    idInfo.textColor = [[Config instance] color1];
    idInfo.backgroundColor = [UIColor clearColor];
    [idInfo sizeToFit];
    idInfo.numberOfLines = 2;
    [self.view addSubview: idInfo];
    
    
}

- (void)showPopup {
    popover = [[UIViewController alloc] init];
    popover.view.backgroundColor = [UIColor clearColor];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.editable = NO;
    tv.scrollEnabled = YES;
    tv.showsVerticalScrollIndicator = YES;
    
    tv.text = [[[Labels instance] userManual] stringByAppendingString: [@"\n \n-------------------------- \n" stringByAppendingString: [[Labels instance] credits]]];
    
    tv.backgroundColor = [[Config instance] color2];
    tv.font = [[Config instance] smallFont];
    tv.textColor = [[Config instance] color1];
    tv.frame = CGRectMake(0, 0, 550, 450);
    
    //CGSize textViewSizeTV1 = [tv sizeThatFits:CGSizeMake(tv.frame.size.width, FLT_MAX)];
    
    [popover.view addSubview: tv];
    /*UITextView *tv2;
    
    if(![[[Labels instance] credits] isEqualToString: [[NSString alloc] init]]) {
        UIView *lign = [[UIView alloc] initWithFrame:CGRectMake(0, textViewSizeTV1.height  + 5, 550, 1)];
        lign.backgroundColor = [[Config instance] color1];
        [tv addSubview: lign];
        
        tv2 = [[UITextView alloc] init];
        tv2.editable = NO;
        tv2.scrollEnabled = NO;
        tv2.text = [[Labels instance] credits];
        tv2.backgroundColor = [[Config instance] color2];
        tv2.font = [[Config instance] tinyFont];
        tv2.textColor = [[Config instance] color1];
        tv2.frame = CGRectMake(0, lign.frame.origin.y + 1, 550, 250);
        //NSLog(@"height %f", tv.contentSize.height);
        //CGRect newFrame2 = CGRectMake(tv2.frame.origin.x, tv2.frame.origin.y, tv2.frame.size.width, tv2.contentSize.height);
        //tv2.frame = newFrame2;
        
        CGSize textViewSizeTV2 = [tv2 sizeThatFits:CGSizeMake(tv2.frame.size.width, FLT_MAX)];
        CGRect newFrame = tv2.frame;
        newFrame.size.height = textViewSizeTV2.height;
        tv2.frame = newFrame;
        
        [tv addSubview: tv2];
    }
    NSLog(@"contentsize 1: %f", tv.contentSize.height);
    tv.contentSize = CGSizeMake(tv.frame.size.width, textViewSizeTV1.height + tv2.frame.size.height + 2);
    NSLog(@"contentsize 2: %f", tv.contentSize.height);
    //tv.frame = CGRectMake(tv.frame.origin.x, tv.frame.origin.y, tv.frame.size.width, tv.frame.size.height + tv2.frame.size.height + 2);
    //= CGRectMake(0, 0, tv.frame.size.width, tv.frame.size.height + tv2.frame.size.height + 2);
    
    */
    
    //Before iOS 9
    /*
    popover = [[UIPopoverController alloc] initWithContentViewController: popup];
    
    popover.popoverContentSize = CGSizeMake(tv.frame.size.width, tv.frame.size.height );
    [popover presentPopoverFromRect: infoButton.frame
                             inView: self.view
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];*/
    
    // After iOS 9
    popover.modalPresentationStyle = UIModalPresentationPopover;
    popover.preferredContentSize = CGSizeMake(tv.frame.size.width, tv.frame.size.height);
    [self presentViewController: popover animated:YES completion:nil];
    
    // configure the Popover presentation controller
    popController = [popover popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = self.view;
    popController.sourceRect = infoButton.frame;
    popController.delegate = self;
}

-(IBAction)printInfoPopup:(id)sender {
    //if( [popover isPopoverVisible]) {
    //    [popover dismissPopoverAnimated: YES];
    //}
    //else {
        [self showPopup];
    //}
}

-(IBAction)hideInfoPopup:(id)sender {
    //[popover dismissPopoverAnimated: YES];
    [popover dismissViewControllerAnimated:NO completion:nil];
}



- (void)createSubviewsForPortrait {
    expoTitle.frame = CGRectMake(768 / 2 - expoTitle.frame.size.width/2, 100, expoTitle.frame.size.width, expoTitle.frame.size.height);
    idInfo.frame = CGRectMake(768 / 2 - idInfo.frame.size.width/2, 200, idInfo.frame.size.width, idInfo.frame.size.height);
    
    idTextfield.frame = CGRectMake(768 / 2 - idTextfield.frame.size.width/2, 250, idTextfield.frame.size.width, idTextfield.frame.size.height);
    
    infoButton.frame = CGRectMake(768-infoButton.frame.size.width-5, 5, infoButton.frame.size.width, infoButton.frame.size.height);
    
    banner.frame = CGRectMake((768 - 650) / 2, 620, 650, 100);
    
    goButton.frame = CGRectMake(768 / 2 - goButton.frame.size.width/2, 320, goButton.frame.size.width, goButton.frame.size.height);
    
    if(languagesButton != NULL) {
        languagesButton.frame = CGRectMake(infoButton.frame.origin.x - languagesButton.frame.size.width - 10,  infoButton.frame.origin.y, languagesButton.frame.size.width, languagesButton.frame.size.height);
    }
}

- (void)createSubviewsForLandscape {
    expoTitle.frame = CGRectMake(1024 / 2 - expoTitle.frame.size.width/2, 40, expoTitle.frame.size.width, expoTitle.frame.size.height);
    
    idInfo.frame = CGRectMake(1024 / 2 - idInfo.frame.size.width/2, 120, idInfo.frame.size.width, idInfo.frame.size.height);
    
    idTextfield.frame = CGRectMake(1024 / 2 - (idTextfield.frame.size.width + goButton.frame.size.width + 10)/2, 180, idTextfield.frame.size.width, idTextfield.frame.size.height);
    
    infoButton.frame = CGRectMake(1024-infoButton.frame.size.width-5, 5, infoButton.frame.size.width, infoButton.frame.size.height);
    
    banner.frame = CGRectMake((1024 - 650) / 2, 280, 650, 100);
    
    goButton.frame = CGRectMake(1024 / 2 - (idTextfield.frame.size.width + goButton.frame.size.width + 10)/2 + idTextfield.frame.size.width + 10, 180, goButton.frame.size.width, goButton.frame.size.height);
    
    if(languagesButton != NULL) {
        languagesButton.frame = CGRectMake(infoButton.frame.origin.x - languagesButton.frame.size.width - 10,  infoButton.frame.origin.y, languagesButton.frame.size.width, languagesButton.frame.size.height);
    }
    
}


- (void)viewDidUnload
{
    [self setIdTextfield:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





- (BOOL)isFileFound:(NSString *)fileName {
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    return [filemgr fileExistsAtPath: [[LanguageManagement instance] pathForFile: fileName contentFile: NO]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"fromIDToSection"] ) {
        SectionViewController *vc = [segue destinationViewController];
        [vc initWithFileToParse: file];
    }
    
    
    
    if( [segue.identifier isEqualToString:@"fromIDToText"] ) {
        TextViewController *textVC = [segue destinationViewController];
        textVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromIDToSlideshow"] ) {
        SlideshowViewController *slideshowVC = [segue destinationViewController];
        slideshowVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromIDToMovie"] ) {
        MovieViewController *movieVC = [segue destinationViewController];
        movieVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromIDToQuiz"] ) {
        QuizViewController *quizVC = [segue destinationViewController];
        quizVC.fileName = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromIDToAnimate"] ) {
        AnimateImageViewController *animateVC = [segue destinationViewController];
        animateVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromIDToZoom"] ) {
        ImageZoomViewController *zoomVC = [segue destinationViewController];
        zoomVC.fileName = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromIDToWeb"] ) {
        WebViewController *webVC = [segue destinationViewController];
        webVC.fileOrLinkName = argument;
    }
}



- (IBAction)parseFileAndProceed:(id)sender {
    NSString *res = idTextfield.text;
    NSString *fileToLoad = @"default";
    if([res length] == 0) {
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showEmptyFieldAlert:self];
        UIAlertController *alert = [Alerts getEmptyFieldAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        if([self isFileFound: @"index.xml"]) {
            XMLIndexParser *index = [XMLIndexParser instance];
            if(index.error == true) {
                //Alerts *alert = [[Alerts alloc] init];
                //[alert errorParsingAlert:self file:@"index.xml" error: index.errors];
                UIAlertController* alert = [Alerts getParsingErrorAlert:@"index.html" error: index.errors];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else fileToLoad = [index.map objectForKey:res];
        }
        
        if([fileToLoad isEqualToString:@"default"] || fileToLoad == nil) {
            // not found in index.xml
            fileToLoad = [res stringByAppendingString: @".xml"];
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if([appDelegate.mod  isEqualToString: @"Guide"] || [appDelegate.mod isEqualToString:@"Child"]) {
            file = [res stringByAppendingString: appDelegate.mod];
            NSLog(@"Fichier guide ou enfant n'existe pas, chargement adulte");
            if(![self isFileFound: file])
                file = fileToLoad; // si le guide ou enfant n'est pas trouvé, on met le fichier par defaut, l'adulte
        }
        else file = fileToLoad;
        
        if(![self isFileFound: file]) {
            NSLog(@"Fichier non trouvé : %@.", file);
            //Alerts *alert = [[Alerts alloc] init];
            //[alert showIDNotFoundAlert:self];
            UIAlertController* alert = [Alerts getIDNotFoundAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            XMLSectionParser* sectionParser = [[XMLSectionParser alloc] init];
            sectionParser = [[XMLSectionParser alloc] init];
            [sectionParser parseXMLFileAtPath: file];
            
            if(sectionParser.error == FALSE) {
                // si on a une seule sous-section, on passe directement dessus
                NSString *type = [sectionParser.types objectAtIndex: 0];
                if(sectionParser.names.count == 1 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"movie"]) {
                    NSLog(@"Only one subsection");
                    //[self setNumberOfPagesToPop: [NSNumber numberWithInt: 2]]; // utile pour faire un retour "direct" à la page de scan
                    
                    argument = [sectionParser.files objectAtIndex: 0];
                    
                    if([type isEqualToString: @"slideshow"]) {
                        [self performSegueWithIdentifier: @"fromIDToSlideshow" sender: self];
                    }
                    else if([type isEqualToString: @"text"]) {
                        [self performSegueWithIdentifier: @"fromIDToText" sender: self];
                    }
                    else if([type isEqualToString: @"quiz"] || [type isEqualToString: @"quizz"]) {
                        [self performSegueWithIdentifier: @"fromIDToQuiz" sender: self];
                    }
                    else if([type isEqualToString: @"zoom"]) {
                        [self performSegueWithIdentifier: @"fromIDToZoom" sender: self];
                    }
                    else if([type isEqualToString: @"animate"]) {
                        [self performSegueWithIdentifier: @"fromIDToAnimate" sender: self];
                    }
                    else if([type isEqualToString: @"web"]) {
                        [self performSegueWithIdentifier: @"fromIDToWeb" sender: self];
                    }
                }
                else {
                    [self performSegueWithIdentifier: @"fromIDToSection" sender: self];
                }
            }
            else {
                //Alerts *alert = [[Alerts alloc] init];
                //[alert errorParsingAlert:self file: sectionParser.path error: @"File is probably not a section file."];
                UIAlertController* alert = [Alerts getParsingErrorAlert:sectionParser.path error:@"File is probably not a section file."];
                [self presentViewController:alert animated:YES completion:nil];
            }

        }
    }
}

- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //The device has already rotated, that's why this method is being called.
    UIDeviceOrientation toOrientation   = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation toInterfaceOrientation;
    //fixes orientation mismatch (between UIDeviceOrientation and UIInterfaceOrientation)
    if (toOrientation == UIDeviceOrientationLandscapeRight)
        toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    else if (toOrientation == UIDeviceOrientationLandscapeLeft)
        toInterfaceOrientation = UIInterfaceOrientationLandscapeRight;
    else if (toOrientation == UIDeviceOrientationPortraitUpsideDown)
        toInterfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
    else toInterfaceOrientation = UIInterfaceOrientationPortrait;
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self createSubviewsForPortrait];
    }
    
}

@end
