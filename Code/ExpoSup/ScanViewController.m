//
//  ScanViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 21/03/13.
//
//

#import "ScanViewController.h"


@implementation ScanViewController

@synthesize result, file, expoTitle, scannerContainer, toID, banner, popover, infoButton, scanInstruction, languagesButton, argument, popController, device, input, session, preview, output;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {

    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    languagesButton = [[LanguageManagement instance] addLanguageSelectionButton: self.view viewController: self];
    
    [self startScanning];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        AVCaptureConnection *con = self.preview.connection;
        con.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        AVCaptureConnection *con = self.preview.connection;
        con.videoOrientation = AVCaptureVideoOrientationPortrait;
        [self createSubviewsForPortrait];
    }

}


- (void)viewDidDisappear:(BOOL)animated {
    [self stopScanning];
}

- (void)viewDidLoad
{
    [self deleteSubviewsFromView: self.view];
    [super viewDidLoad];
    
    
    result = nil;
    
    

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
    
    scannerContainer = [[UIView alloc] init];
    
    [self setupScanner];
}

- (void) setupScanner
{
    self.device =  nil;
    AVCaptureDevice* tempDevice = nil;
    
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == AVCaptureDevicePositionBack) {
            self.device = d;
        }
        tempDevice = d;
    }
    
    if(self.device == nil && tempDevice == nil) {
        UIAlertController* alert = [Alerts getCameraNotFoundAlert:0];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if(self.device == nil) {
        if([AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo] != nil) {
            self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        else self.device = tempDevice;
    }
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.session = [[AVCaptureSession alloc] init];
    self.output = [[AVCaptureMetadataOutput alloc] init];
    
    if(self.input == nil) {
        UIAlertController* alert = [Alerts getCameraNotFoundAlert:1];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if (self.output == nil){
        UIAlertController* alert = [Alerts getCameraNotFoundAlert:2];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else if (self.session == nil){
        UIAlertController* alert = [Alerts getCameraNotFoundAlert:3];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.session addOutput:self.output];
    [self.session addInput:self.input];
    
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
    
    AVCaptureConnection *con = self.preview.connection;
    
    con.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    
    
    [self.scannerContainer.layer insertSublayer:self.preview atIndex:0];
    [self.view addSubview: scannerContainer];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection
{
    for(AVMetadataObject *current in metadataObjects) {
        //if([current isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            //if([self.delegate respondsToSelector:@selector(scanViewController:didSuccessfullyScan:)]) {
                [self stopScanning];
                NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
                result = scannedValue;
                [self.delegate scanViewController:self didSuccessfullyScan:scannedValue];
                [self parseFileAndProceed:self];
        
            //}
        //}
    }
}

- (void)startScanning;
{
    [self.session startRunning];
    
}

- (void) stopScanning;
{
    [self.session stopRunning];
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
    
    // Before iOS 9
    /*
    popover = [[UIPopoverController alloc] initWithContentViewController: popup];
    
    popover.popoverContentSize = CGSizeMake(tv.frame.size.width, tv.frame.size.height );
    [popover presentPopoverFromRect: infoButton.frame
                             inView: self.view
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];*/
    // After iOS 9
    popover.modalPresentationStyle = UIModalPresentationPopover;
    popover.preferredContentSize = CGSizeMake(tv.frame.size.width, tv.frame.size.height );
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)StartScan:(id) sender {
    reader = [ZBarReaderView new];
    reader.readerDelegate = self;
    
    reader.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
    
    
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [reader start];
    
    
    [scannerContainer addSubview: reader];
    [self.view addSubview: scannerContainer];
}*/

/*
-(void)readerView:(ZBarReaderView*)reader didReadSymbols: (ZBarSymbolSet*) symbols fromImage:(UIImage *) image{
    ZBarSymbol *symbol = nil;
    for(symbol in symbols) {
        result = symbol.data;
        [self parseFileAndProceed: self];

    }
}*/


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
    else if( [segue.identifier isEqualToString:@"fromScanToWeb"] ) {
        WebViewController *webVC = [segue destinationViewController];
        webVC.fileOrLinkName = argument;
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
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showQRCodeNotFoundAlert:self];
        UIAlertController* alert = [Alerts getQRCodeNotFoundAlert];
        [self presentViewController:alert animated:YES completion:nil];
        UIAlertAction* restartScanningAction = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction * action) {
                                                                        [self startScanning];
                                                                    }];
        [alert addAction: restartScanningAction];
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
                 else if([type isEqualToString: @"web"]) {
                     [self performSegueWithIdentifier: @"fromScanToWeb" sender: self];
                 }
             }
             else {
                 [self performSegueWithIdentifier: @"toSectionVC" sender: self];
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
    self.preview.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
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
    self.preview.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
    toID.frame = CGRectMake(1024/2 - toID.frame.size.width/2, 595, toID.frame.size.width, toID.frame.size.height);

    expoTitle.frame = CGRectMake(1024 / 2 - expoTitle.frame.size.width/2, 30, expoTitle.frame.size.width, expoTitle.frame.size.height);
    
    if(languagesButton != NULL) {
        languagesButton.frame = CGRectMake(infoButton.frame.origin.x - languagesButton.frame.size.width - 10,  infoButton.frame.origin.y, languagesButton.frame.size.width, languagesButton.frame.size.height);
    }
}

- (void)deleteSubviewsFromView:(UIView*)view {
    UIView *child;
    for(child in [view subviews]) {
        if(child.tag != 888) {
            [self deleteSubviewsFromView: child];
            [child removeFromSuperview];
        }
    }
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
    
    //[reader willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //[self deleteSubviewsFromView: self.view];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 270 / 180.0); // rotation a 270degrés
        AVCaptureConnection *con = self.preview.connection;
        con.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 0 / 180.0);
        AVCaptureConnection *con = self.preview.connection;
        con.videoOrientation = AVCaptureVideoOrientationPortrait;
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
