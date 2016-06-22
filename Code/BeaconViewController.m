//
//  BeaconViewController.m
//  exposup
//
//
//

#import "BeaconViewController.h"
#import "AppDelegate.h"
#import "BeaconManagerDelegate.h"

@implementation BeaconViewController


@synthesize result, file, expoTitle, scannerContainer, toID,toScan, banner, popover, infoButton, BeaconInfo, languagesButton, argument, popController,tableView,beaconManager, AreaLabel, index, SectionKeyArray;

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
    
    //    [self startScanning];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [self createSubviewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self createSubviewsForPortrait];
    }
    
}


- (void)viewDidDisappear:(BOOL)animated {
    //    [self stopScanning];
}

- (void)viewDidLoad
{
    [self deleteSubviewsFromView: self.view];
    [super viewDidLoad];

//    tableData = [NSArray arrayWithObjects:@"Egg Benedict", @"Mushroom Risotto", @"Full Breakfast", @"Hamburger", @"Ham and Egg Sandwich", @"Creme Brelee", @"White Chocolate Donut", @"Starbucks Coffee", @"Vegetable Curry", @"Instant Noodle with Egg", @"Noodle with BBQ Pork", @"Japanese Noodle with Pork", @"Green Tea", @"Thai Shrimp Cake", @"Angry Birds Cake", @"Ham and Cheese Panini", nil];

    
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
    
    
    //bouton Scan
    toScan = [UIButton buttonWithType: UIButtonTypeCustom];
    [ColorButton configButton: toScan];
    [toScan setTitle: [[Labels instance] toScanButton] forState: UIControlStateNormal];
    [toScan addTarget:self action:@selector(toScan:) forControlEvents: UIControlEventTouchUpInside];
    [toScan sizeToFit];
    toScan.frame = CGRectMake(0, 0, toScan.frame.size.width + 20, 35);
    [self.view addSubview: toScan];
    
    
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
    
 
    
    //beacon info
    BeaconInfo = [[UILabel alloc] init];
    BeaconInfo.text = [[Labels instance] BeaconInfo];
    BeaconInfo.font = [[Config instance] smallFont];
    BeaconInfo.textColor = [[Config instance] color1];
    BeaconInfo.backgroundColor = [UIColor clearColor];
    [BeaconInfo sizeToFit];
    BeaconInfo.numberOfLines = 2;
    [self.view addSubview: BeaconInfo];
    
    AreaLabel = [[Labels instance] AreaLabel];
    
    //self.tableView =[[UITableView alloc]init];
//    _tableView.dataSource =self;
//    _tableView.delegate = self;
//    _beaconManager = (AppDelegate*) [UIApplication sharedApplication].delegate;
//    _beaconManager.delegate = self;
//    [self.view addSubview:_tableView];

    //[scrollView addSubview:tableView.view];
    tableView = [[UITableView alloc] init];
    tableView.delegate=self;
    tableView.dataSource =self;
    
    beaconManager = (AppDelegate*) [UIApplication sharedApplication].delegate;
    beaconManager.delegate = self;
    [self.view addSubview: tableView];
    

    index = [XMLBeaconParsers instance];
    
//    //XMLIndexParser *index = [XMLIndexParser instance];
//    if(index.error == true) {
//        //Alerts *alert = [[Alerts alloc] init];
//        //[alert errorParsingAlert:self file:@"index.xml" error: index.errors];
//        UIAlertController* alert = [Alerts getParsingErrorAlert:@"index.html" error: index.errors];
//        [self presentViewController:alert animated:YES completion:nil];
//    }

    SectionKeyArray = beaconManager.currentBeacons;//[NSMutableArray arrayWithArray:[index.mapZonetoID allKeys]];
//    NSLog(@"VAAAAALEUR222");
//    NSLog(@"%@",SectionKeyArray);
//    NSLog(@"%@",index.mapZonetoID);
    
}
-(void)updateCurrentBeacons{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.SectionKeyArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *sectionTitle = [self.SectionKeyArray objectAtIndex:section];
    NSArray * sectionBeacon = [index.mapZonetoID objectForKey:sectionTitle];
    return [sectionBeacon count];
}


-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[AreaLabel stringByAppendingString:@": "] stringByAppendingString:[self.SectionKeyArray objectAtIndex:section] ];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"beaconCellId"];
    if (cell == nil) {
        
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                               reuseIdentifier:@"beaconCellId"];
        
    }
    //    NSString *res =[beaconManager.ZoneToBeacons objectForKey:@"2" ][indexPath.row];
 //       NSMutableArray *value = [beaconManager.currentBeacons objectForKey:@"2"];
//        
//    NSMutableArray *array = beaconManager.ZoneToBeacons;
//    NSString *res = value[indexPath.row];
    
    NSString* sectionTitle = [self.SectionKeyArray objectAtIndex:indexPath.section];
    NSArray *sectionZone = [index.mapZonetoID objectForKey:sectionTitle];
    
    
    NSString *res = [sectionZone objectAtIndex:indexPath.row];
    //NSLog(@"%@",[beaconManager.SortedZoneToBeacons objectForKey:@"2"] );
    cell.detailTextLabel.text = res;
    
    if([beaconManager.touchedIds containsObject:res]== YES){
        cell.backgroundColor = [UIColor greenColor];
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];

    }
    
//    if([beaconManager.NearBeacons containsObject:res]== YES){
//        cell.backgroundColor = [UIColor greenColor];
//    }
//    if([beaconManager.FarBeacons containsObject:res] == YES){
//        cell.backgroundColor = [UIColor orangeColor];
//    }
//    if([beaconManager.UnknownBeacons containsObject:res]== YES){
//        cell.backgroundColor = [UIColor grayColor];
//    }
    NSString *fileToLoad = @"default";
    if([res length] == 0) {
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showEmptyFieldAlert:self];
        UIAlertController *alert = [Alerts getEmptyFieldAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        if([self isFileFound: @"index.xml"]) {
            //XMLIndexParser *index = [XMLIndexParser instance];
            if(index.error == true) {
                //Alerts *alert = [[Alerts alloc] init];
                //[alert errorParsingAlert:self file:@"index.xml" error: index.errors];
                UIAlertController* alert = [Alerts getParsingErrorAlert:@"index.html" error: index.errors];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else fileToLoad = [index.mapIDtoName objectForKey:res];
        }
        
        if([fileToLoad isEqualToString:@"default"] || fileToLoad == nil) {
            // not found in index.xml
            fileToLoad = [res stringByAppendingString: @".xml"];
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if([appDelegate.mod  isEqualToString: @"Guide"] || [appDelegate.mod isEqualToString:@"Child"]) {
            file = [res stringByAppendingString: appDelegate.mod];
//            NSLog(@"Fichier guide ou enfant n'existe pas, chargement adulte");
            if(![self isFileFound: file])
                file = fileToLoad; // si le guide ou enfant n'est pas trouvé, on met le fichier par defaut, l'adulte
        }
        else file = fileToLoad;
        
        if(![self isFileFound: file]) {
//            NSLog(@"Fichier non trouvé : %@.", file);
            //Alerts *alert = [[Alerts alloc] init];
            //[alert showIDNotFoundAlert:self];
            UIAlertController* alert = [Alerts getIDNotFoundAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            XMLSectionParser* sectionParser = [[XMLSectionParser alloc] init];
            //sectionParser = [[XMLSectionParser alloc] init];
            [sectionParser parseXMLFileAtPath: file];
            
            if(sectionParser.error == FALSE) {
                // si on a une seule sous-section, on passe directement dessus
                NSString *title = sectionParser.title;
                cell.textLabel.text =  title;
            }
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    result = cell.detailTextLabel.text;
    [beaconManager.touchedIds addObject:result];
//    NSLog(@"%@", beaconManager.touchedIds);
    
//    
//    
//
//    //NSString *scannedValue = [((AVMetadataMachineReadableCodeObject *) current) stringValue];
//    result = @"This string is immutable";  
//    //[self.delegate scanViewController:self didSuccessfullyScan:scannedValue];
    [self parseFileAndProceed:self];
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






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if( [segue.identifier isEqualToString:@"fromScanToSection"] ) {
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

- (IBAction)toScan:(id)sender {
    [self performSegueWithIdentifier: @"toScan" sender:self];
}

- (IBAction)parseFileAndProceed:(id)sender {
    NSString *res = result;
    NSString *fileToLoad = @"default";
    if([res length] == 0) {
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showEmptyFieldAlert:self];
        UIAlertController *alert = [Alerts getEmptyFieldAlert];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        if([self isFileFound: @"indexWithZone.xml"]) {
            //XMLIndexParser *index = [XMLIndexParser instance];
            if(index.error == true) {
                //Alerts *alert = [[Alerts alloc] init];
                //[alert errorParsingAlert:self file:@"index.xml" error: index.errors];
                UIAlertController* alert = [Alerts getParsingErrorAlert:@"index.html" error: index.errors];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else fileToLoad = [index.mapIDtoName objectForKey:res];
        }
        
        if([fileToLoad isEqualToString:@"default"] || fileToLoad == nil) {
            // not found in index.xml
            fileToLoad = [res stringByAppendingString: @".xml"];
        }
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        if([appDelegate.mod  isEqualToString: @"Guide"] || [appDelegate.mod isEqualToString:@"Child"]) {
            file = [res stringByAppendingString: appDelegate.mod];
//            NSLog(@"Fichier guide ou enfant n'existe pas, chargement adulte");
            if(![self isFileFound: file])
                file = fileToLoad; // si le guide ou enfant n'est pas trouvé, on met le fichier par defaut, l'adulte
        }
        else file = fileToLoad;
        
        if(![self isFileFound: file]) {
//            NSLog(@"Fichier non trouvé : %@.", file);
            //Alerts *alert = [[Alerts alloc] init];
            //[alert showIDNotFoundAlert:self];
            UIAlertController* alert = [Alerts getIDNotFoundAlert];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            XMLSectionParser* sectionParser = [[XMLSectionParser alloc] init];
            //sectionParser = [[XMLSectionParser alloc] init];
            [sectionParser parseXMLFileAtPath: file];
            
            if(sectionParser.error == FALSE) {
                // si on a une seule sous-section, on passe directement dessus
                NSString *type = [sectionParser.types objectAtIndex: 0];
                if(sectionParser.names.count == 1 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"movie"]) {
 //                   NSLog(@"Only one subsection");
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
                    [self performSegueWithIdentifier: @"fromScanToSection" sender: self];
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

- (BOOL)isFileFound:(NSString *)fileName {
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    
    return [filemgr fileExistsAtPath: [[LanguageManagement instance] pathForFile: fileName contentFile: NO]];
}

//
//- (void)parseFileAndProceed:(id)sender {
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    
//    if([appDelegate.mod  isEqualToString: @"Guide"] || [appDelegate.mod isEqualToString:@"Child"]) {
//        file = [result stringByAppendingString: appDelegate.mod];
//        NSLog(@"Fichier guide ou enfant n'existe pas, chargement adulte");
//        if(![self isIDFileFound: file])
//            file = result; // si le guide ou enfant n'est pas trouvé, on met le fichier par defaut, l'adulte
//    }
//    else file = result;
//        
//        if(![self isIDFileFound: file]) {
//            NSLog(@"Fichier non trouvé : %@.", file);
//            //Alerts *alert = [[Alerts alloc] init];
//            //[alert showQRCodeNotFoundAlert:self];
//            UIAlertController* alert = [Alerts getQRCodeNotFoundAlert];
//            [self presentViewController:alert animated:YES completion:nil];
//            UIAlertAction* restartScanningAction = [UIAlertAction actionWithTitle:@"OK"
//                                                                            style:UIAlertActionStyleDefault
//                                                                          handler:^(UIAlertAction * action) {
//                                                                              //                                                                        [self startScanning];
//                                                                          }];
//            [alert addAction: restartScanningAction];
//        }
//        else {
//            
//            
//            XMLSectionParser* sectionParser = [[XMLSectionParser alloc] init];
//            sectionParser = [[XMLSectionParser alloc] init];
//            [sectionParser parseXMLFileAtPath: file];
//            
//            if(sectionParser.error == FALSE) {
//                // si on a une seule sous-section, on passe directement dessus
//                NSString *type = [sectionParser.types objectAtIndex: 0];
//                if(sectionParser.names.count == 1 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"movie"]) {
//                    NSLog(@"Only one subsection");
//                    //[self setNumberOfPagesToPop: [NSNumber numberWithInt: 2]]; // utile pour faire un retour "direct" à la page de scan
//                    
//                    argument = [sectionParser.files objectAtIndex: 0];
//                    
//                    if([type isEqualToString: @"slideshow"]) {
//                        [self performSegueWithIdentifier: @"fromScanToSlideshow" sender: self];
//                    }
//                    else if([type isEqualToString: @"text"]) {
//                        [self performSegueWithIdentifier: @"fromScanToText" sender: self];
//                    }
//                    else if([type isEqualToString: @"quiz"] || [type isEqualToString: @"quizz"]) {
//                        [self performSegueWithIdentifier: @"fromScanToQuiz" sender: self];
//                    }
//                    else if([type isEqualToString: @"zoom"]) {
//                        [self performSegueWithIdentifier: @"fromScanToZoom" sender: self];
//                    }
//                    else if([type isEqualToString: @"animate"]) {
//                        [self performSegueWithIdentifier: @"fromScanToAnimate" sender: self];
//                    }
//                    else if([type isEqualToString: @"web"]) {
//                        [self performSegueWithIdentifier: @"fromScanToWeb" sender: self];
//                    }
//                }
//                else {
//                    [self performSegueWithIdentifier: @"toSectionVC" sender: self];
//                }
//            }
//            else {
//                //Alerts *alert = [[Alerts alloc] init];
//                //[alert errorParsingAlert:self file: sectionParser.path error: @"File is probably not a section file."];
//                UIAlertController* alert = [Alerts getParsingErrorAlert:sectionParser.path error:@"File is probably not a section file."];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
//        }
//}




- (BOOL)isIDFileFound:(NSString *)fileName {
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    return [filemgr fileExistsAtPath: [[LanguageManagement instance] pathForFile: fileName contentFile: NO]];
}


- (void)createSubviewsForPortrait {
    infoButton.frame = CGRectMake(768-infoButton.frame.size.width-5, 5, infoButton.frame.size.width, infoButton.frame.size.height);
    banner.frame = CGRectMake((768 - 650) / 2, 1024-30-100, 650, 100);
    
    BeaconInfo.frame = CGRectMake(768 / 2 - BeaconInfo.frame.size.width/2, 200, BeaconInfo.frame.size.width, BeaconInfo.frame.size.height);
    tableView.frame = CGRectMake(768/2-600/2, 250, 600, 500);
    //    self.preview.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
    toID.frame = CGRectMake(768/2 - toID.frame.size.width/2, 845, toID.frame.size.width, toID.frame.size.height);
    toScan.frame = CGRectMake(768/2 - toID.frame.size.width/2, 845-toID.frame.size.height-10, toID.frame.size.width, toID.frame.size.height);
    
    expoTitle.frame = CGRectMake(768 / 2 - expoTitle.frame.size.width/2, 100, expoTitle.frame.size.width, expoTitle.frame.size.height);
    
    if(languagesButton != NULL) {
        languagesButton.frame = CGRectMake(infoButton.frame.origin.x - languagesButton.frame.size.width - 10,  infoButton.frame.origin.y, languagesButton.frame.size.width, languagesButton.frame.size.height);
    }
}

- (void)createSubviewsForLandscape {
    infoButton.frame = CGRectMake(1024-infoButton.frame.size.width-5, 5,infoButton.frame.size.width, infoButton.frame.size.height);
    banner.frame = CGRectMake((1024 - 650) / 2, 768-30-100, 650, 100);
    BeaconInfo.frame = CGRectMake(1024 / 2 - BeaconInfo.frame.size.width/2, 100, BeaconInfo.frame.size.width, BeaconInfo.frame.size.height);
    
    tableView.frame = CGRectMake(1024/2-550/2, 140, 550, 400);
    //    self.preview.frame = CGRectMake(0, 0, scannerContainer.frame.size.width, scannerContainer.frame.size.height);
    toID.frame = CGRectMake(1024/2 - toID.frame.size.width/2, 595, toID.frame.size.width, toID.frame.size.height);
    toID.frame = CGRectMake(1024/2 - toID.frame.size.width/2, 595-toID.frame.size.height-10, toID.frame.size.width, toID.frame.size.height);
    
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
                        //        AVCaptureConnection *con = self.preview.connection;
                        //        con.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
                        [self createSubviewsForLandscape];
                    }
                    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                        //reader.previewTransform = CGAffineTransformMakeRotation (M_PI * 0 / 180.0);
                        //        AVCaptureConnection *con = self.preview.connection;
                        //        con.videoOrientation = AVCaptureVideoOrientationPortrait;
                        [self createSubviewsForPortrait];
                    }
}


- (void)updateLanguage {
    expoTitle.text = [[Labels instance] expoTitle];
    [expoTitle sizeToFit];
    BeaconInfo.text = [[Labels instance] BeaconInfo];
    [BeaconInfo sizeToFit];
    toID.titleLabel.text = [[Labels instance] toIDButton];
    [toID sizeToFit];
    [self viewWillAppear:YES];
}

@end

