//
//  ScanViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 21/03/13.
//
//

#import "ScanViewController.h"


@implementation ScanViewController

@synthesize reader, result, file, expoTitle, scannerContainer, toID, banner, popover, infoButton, scanInstruction, languagesButton, argument;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [reader start];

    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    languagesButton = [[LanguageManagement instance] addLanguageSelectionButton: self.view];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 270 / 180.0);
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 0 / 180.0);
        [self createSubviewsForPortrait];
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [reader stop];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[[self.view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    result = nil;
    
    //Cam view
    scannerContainer = [[UIView alloc] init];
    [self StartScan: self];
    
    

    //label scan
    expoTitle = [[UILabel alloc] init];
    expoTitle.text = [[Labels instance] expoTitle];
    expoTitle.font = [[Config instance] bigFont];
    expoTitle.textColor = [[Config instance] color1];
    expoTitle.backgroundColor = [UIColor clearColor];
    [expoTitle sizeToFit];
    expoTitle.numberOfLines = 2;
    [self.view addSubview: expoTitle];
    
    
    
    //bouton identifiant
    toID = [UIButton buttonWithType: UIButtonTypeCustom];
    [ColorButton configButton: toID];
    [toID setTitle: [[Labels instance] toIDButton] forState: UIControlStateNormal];
    [toID addTarget:self action:@selector(toID:) forControlEvents: UIControlEventTouchUpInside];
    [toID sizeToFit];
    toID.frame = CGRectMake(0, 0, toID.frame.size.width + 20, 35);
    [self.view addSubview: toID];
    
    
    
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
    
    
    
    //cam info
    scanInstruction = [[UILabel alloc] init];
    scanInstruction.text = [[Labels instance] scanInstruction];
    scanInstruction.font = [[Config instance] smallFont];
    scanInstruction.textColor = [[Config instance] color1];
    scanInstruction.backgroundColor = [UIColor clearColor];
    [scanInstruction sizeToFit];
    scanInstruction.numberOfLines = 2;
    [self.view addSubview: scanInstruction];
    
    

    
    
}



- (void)showPopup {
    UIViewController *popup = [[UIViewController alloc] init];
    popup.view.backgroundColor = [UIColor clearColor];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.editable = NO;
    tv.scrollEnabled = YES;
    tv.showsVerticalScrollIndicator = YES;
    tv.text = [[Labels instance] userManual];
    tv.backgroundColor = [[Config instance] color2];
    tv.font = [[Config instance] smallFont];
    tv.textColor = [[Config instance] color1];
    tv.frame = CGRectMake(0, 0, 550, 450);


    [popup.view addSubview: tv];
    UITextView *tv2;
    
    if(![[[Labels instance] credits] isEqualToString: [[NSString alloc] init]]) {
        UIView *lign = [[UIView alloc] initWithFrame:CGRectMake(0, tv.contentSize.height + 5, 550, 1)];
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

        CGRect newFrame2 = CGRectMake(tv2.frame.origin.x, tv2.frame.origin.y, tv2.frame.size.width, tv2.contentSize.height);
        tv2.frame = newFrame2;
        [tv addSubview: tv2];
    }
    tv.contentSize = CGSizeMake(tv.frame.size.width, tv.contentSize.height + tv2.frame.size.height + 2);//= CGRectMake(0, 0, tv.frame.size.width, tv.frame.size.height + tv2.frame.size.height + 2);
    popover = [[UIPopoverController alloc] initWithContentViewController: popup];
    
    popover.popoverContentSize = CGSizeMake(tv.frame.size.width, tv.frame.size.height);
    [popover presentPopoverFromRect: infoButton.frame
                             inView: self.view
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
}

-(IBAction)printInfoPopup:(id)sender {
    if( [popover isPopoverVisible]) {
        
        [popover dismissPopoverAnimated: YES];
    }
    else {
        [self showPopup];
        
    }
}

-(IBAction)hideInfoPopup:(id)sender {
    [popover dismissPopoverAnimated: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartScan:(id) sender {
    reader = [ZBarReaderView new];
    reader.readerDelegate = self;
    
    reader.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
    
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [reader start];
    
    
    [scannerContainer addSubview: reader];
    [self.view addSubview: scannerContainer];
}


-(void)readerView:(ZBarReaderView*)reader didReadSymbols: (ZBarSymbolSet*) symbols fromImage:(UIImage *) image{
    ZBarSymbol *symbol = nil;
    for(symbol in symbols) {
        result = symbol.data;
        [self parseFileAndProceed: self];

    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"toSectionVC"] ) {
        SectionViewController *vc = [segue destinationViewController];
        [vc initWithFileToParse: file];
    }
    


    if( [segue.identifier isEqualToString:@"fromScanToText"] ) {
        TextViewController *textVC = [segue destinationViewController];
        textVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromScanToSlideshow"] ) {
        SlideshowViewController *slideshowVC = [segue destinationViewController];
        slideshowVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromScanToMovie"] ) {
        MovieViewController *movieVC = [segue destinationViewController];
        movieVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromScanToQuiz"] ) {
        QuizViewController *quizVC = [segue destinationViewController];
        quizVC.fileName = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromScanToAnimate"] ) {
        AnimateImageViewController *animateVC = [segue destinationViewController];
        animateVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"fromScanToZoom"] ) {
        ImageZoomViewController *zoomVC = [segue destinationViewController];
        zoomVC.fileName = argument;
    }
   
}

- (IBAction)toID:(id)sender {
    [self performSegueWithIdentifier: @"toID" sender:self];
}

- (void)parseFileAndProceed:(id)sender {    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if([appDelegate.mod  isEqualToString: @"Guide"] || [appDelegate.mod isEqualToString:@"Child"]) {
        file = [result stringByAppendingString: appDelegate.mod];
        NSLog(@"Fichier guide ou enfant n'existe pas, chargement adulte");
        if(![self isIDFileFound: file])
            file = result; // si le guide ou enfant n'est pas trouvé, on met le fichier par defaut, l'adulte
    }
    else file = result;

    if(![self isIDFileFound: file]) {
        NSLog(@"Fichier non trouvé : %@.", file);
        Alerts *alert = [[Alerts alloc] init];
        [alert showQRCodeNotFoundAlert:self];
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
                     [self performSegueWithIdentifier: @"fromScanToSlideshow" sender: self];
                 }
                 else if([type isEqualToString: @"text"]) {
                    [self performSegueWithIdentifier: @"fromScanToText" sender: self];
                 }
                 else if([type isEqualToString: @"quiz"] || [type isEqualToString: @"quizz"]) {
                    [self performSegueWithIdentifier: @"fromScanToQuiz" sender: self];
                 }
                 else if([type isEqualToString: @"zoom"]) {
                    [self performSegueWithIdentifier: @"fromScanToZoom" sender: self];
                 }
                 else if([type isEqualToString: @"animate"]) {
                    [self performSegueWithIdentifier: @"fromScanToAnimate" sender: self];
                 }
             }
             else {
                 [self performSegueWithIdentifier: @"toSectionVC" sender: self];
             }
        }
        else {
            Alerts *alert = [[Alerts alloc] init];
            [alert errorParsingAlert:self file: sectionParser.path error: @"File is probably not a section file."];
        }
    }
}




- (BOOL)isIDFileFound:(NSString *)fileName {
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    return [filemgr fileExistsAtPath: [[LanguageManagement instance] pathForFile: fileName contentFile: NO]];
}


- (void)createSubviewsForPortrait {
    infoButton.frame = CGRectMake(768-infoButton.frame.size.width-5, 5, infoButton.frame.size.width, infoButton.frame.size.height);
    banner.frame = CGRectMake((768 - 650) / 2, 1024-30-100, 650, 100);
    
    scanInstruction.frame = CGRectMake(768 / 2 - scanInstruction.frame.size.width/2, 200, scanInstruction.frame.size.width, scanInstruction.frame.size.height);
    
    scannerContainer.frame = CGRectMake(768/2-600/2, 250, 600, 500);
    toID.frame = CGRectMake(768/2 - toID.frame.size.width/2, 845, toID.frame.size.width, toID.frame.size.height);

    expoTitle.frame = CGRectMake(768 / 2 - expoTitle.frame.size.width/2, 100, expoTitle.frame.size.width, expoTitle.frame.size.height);
    
    if(languagesButton != NULL) {
        languagesButton.frame = CGRectMake(infoButton.frame.origin.x - languagesButton.frame.size.width - 10,  infoButton.frame.origin.y, languagesButton.frame.size.width, languagesButton.frame.size.height);
    }
}

- (void)createSubviewsForLandscape {
    infoButton.frame = CGRectMake(1024-infoButton.frame.size.width-5, 5,infoButton.frame.size.width, infoButton.frame.size.height);
    banner.frame = CGRectMake((1024 - 650) / 2, 768-30-100, 650, 100);
    scanInstruction.frame = CGRectMake(1024 / 2 - scanInstruction.frame.size.width/2, 100, scanInstruction.frame.size.width, scanInstruction.frame.size.height);
    
    scannerContainer.frame = CGRectMake(1024/2-550/2, 140, 550, 400);
    toID.frame = CGRectMake(1024/2 - toID.frame.size.width/2, 595, toID.frame.size.width, toID.frame.size.height);

    expoTitle.frame = CGRectMake(1024 / 2 - expoTitle.frame.size.width/2, 30, expoTitle.frame.size.width, expoTitle.frame.size.height);
    
    if(languagesButton != NULL) {
        languagesButton.frame = CGRectMake(infoButton.frame.origin.x - languagesButton.frame.size.width - 10,  infoButton.frame.origin.y, languagesButton.frame.size.width, languagesButton.frame.size.height);
    }
}

- (void)deleteSubviewsFromView:(UIView*)view {
    UIView *child;
    for(child in [view subviews]) {
        [self deleteSubviewsFromView: child];
        [child removeFromSuperview];
            
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //[reader willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self deleteSubviewsFromView: self.view];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 270 / 180.0); // rotation a 270degrés
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 0 / 180.0);
        [self createSubviewsForPortrait];
    }
    
}

- (void)updateLanguage {
    expoTitle.text = [[Labels instance] expoTitle];
    [expoTitle sizeToFit];
    scanInstruction.text = [[Labels instance] scanInstruction];
    [scanInstruction sizeToFit];
    toID.titleLabel.text = [[Labels instance] toIDButton];
    [toID sizeToFit];
    [self viewWillAppear:YES];
}

@end
