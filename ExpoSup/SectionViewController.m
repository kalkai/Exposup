//
//  SectionViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 30/03/13.
//
//

#import "SectionViewController.h"


@implementation SectionViewController

@synthesize  parser, pauseButton, playButton, stopButton, lastAudioPlayed, audioPlayers, audioPlayerNr, fileName, argument, buttonsList, sectionTitle, volumeButton, popover, volumeViewSlider;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFileToParse:(NSString *)file {
    self = [super init];
    self.fileName = file;
    return self;
}

- (id)initWithParser:(XMLSectionParser*)parserArg {
    self.parser = parserArg;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
  
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(self.previousOrientation != toInterfaceOrientation) {
        self.previousOrientation = toInterfaceOrientation;
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            UIView *view;
            int center = 1024/2;
            for(view in [self.view subviews]) {
                if(view.tag != 999) {
                    int difference = view.frame.origin.x - 768/2;
                    view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }
            }
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            UIView *view;
            int center = 768/2;
            for(view in [self.view subviews]) {
                if(view.tag != 999) {
                    int difference = view.frame.origin.x - 1024/2;
                    view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }
            }
        }
    }
    
    
}


- (int)addTitle {
    int originY = 70;
    CGSize available = CGSizeMake(self.view.frame.size.width - 150, 9999);
    sectionTitle = [[UILabel alloc] init];
    sectionTitle.font = [[Config instance] bigFont];
    sectionTitle.frame = CGRectMake(0, 0, self.view.frame.size.width - 150, 100);
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.textColor = [[Config instance] color1];
    sectionTitle.text = [parser title];
    sectionTitle.numberOfLines = 0;
    CGSize sizedToFit = [sectionTitle sizeThatFits: available];
    
    
    sectionTitle.frame = CGRectMake( self.view.frame.size.width / 2 - sizedToFit.width/2, originY, sizedToFit.width, sizedToFit.height);
    //sectionTitle.frame = CGRectMake(self.view.frame.size.width/2 - sectionTitle.frame.size.width/2, 30, sectionTitle.frame.size.width, sectionTitle.frame.size.height);
    [self.view addSubview: sectionTitle];
    return originY + sizedToFit.height;
}


- (int)addSubtitle:(int)subtitleIdx atY:(int)coordY withWidth:(int)width {
    coordY += 5;
    CGRect frame;
    
    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.frame = CGRectMake(0, 0, width - 100, 100);
    subtitle.text = [parser.subtitles objectAtIndex: subtitleIdx];
    subtitle.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
    subtitle.font = [[Config instance] bigFont];
    subtitle.textColor = [[Config instance] color5];
    subtitle.numberOfLines = 0;
    [subtitle sizeToFit];
    
    NSLog(@"Section - subtitle : %@", [parser.subtitles objectAtIndex: subtitleIdx]);
    
    if([[parser.locations objectAtIndex: subtitleIdx] isEqualToString:@"gauche"]) {
        frame = CGRectMake(30, coordY, subtitle.frame.size.width, subtitle.frame.size.height);
    } else if([[parser.locations objectAtIndex: subtitleIdx] isEqualToString:@"droite"]) {
        frame = CGRectMake(width - 25 - subtitle.frame.size.width, coordY, subtitle.frame.size.width, subtitle.frame.size.height);
    } else {
        frame = CGRectMake(width/2 - subtitle.frame.size.width /2, coordY, subtitle.frame.size.width, subtitle.frame.size.height);
    }
    subtitle.frame = frame;
    
    
    
    [self.view addSubview: subtitle];
    return subtitle.frame.size.height + 5;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    parser = [[XMLSectionParser alloc] init];
    [parser parseXMLFileAtPath: fileName];
    if(parser.error == FALSE) {
        self.previousOrientation = UIInterfaceOrientationPortrait;
        
        buttonsList = [[NSMutableArray alloc] init];
        audioPlayers = [[NSMutableArray alloc] init];
        audioPlayerNr = 0;
        int originY = 0;
        originY += [self addTitle];
        originY += 30;
        
        Boolean isFirstAudio = true;
        int subtitleIdx = 0;
        for(int i=0; i<parser.names.count; ++i) {
            NSString *text = [parser.names objectAtIndex: i];
            UILabel *lab = [[UILabel alloc] init];
            lab.text = text;
            [lab sizeToFit];
            lab.frame = CGRectMake( 0, 0, 400, lab.frame.size.height);
            
            NSString *type = [parser.types objectAtIndex: i];
            
            if([type isEqualToString: @"subtitle"]) {
                originY += [self addSubtitle: subtitleIdx atY: originY withWidth: self.view.frame.size.width];
                subtitleIdx++;
                originY += 20;
            }
            else if([type isEqualToString: @"audio"] && [Config instance].audioOn) {
                if(isFirstAudio) {
                    originY = originY + 20; // on laisse un espace pour le premier audio
                    isFirstAudio = false;
                }
                originY += [self addAudiotoView: self.view atPoint: originY fromIndex: i];
            }
            else {
                int center = self.view.frame.size.width/2;
                UIButton *button = [ColorButton getButton];
                button.frame = CGRectMake( center  - lab.frame.size.width/2, originY , lab.frame.size.width, 50);
                
                [button setTitle: text forState: UIControlStateNormal];
                [buttonsList addObject: button];
                button.tag = i;
                if([type isEqualToString: @"slideshow"]) {
                    [button addTarget: self action:@selector(toSlideshow:) forControlEvents: UIControlEventTouchUpInside];
                }
                else if([type isEqualToString: @"text"]) {
                    [button addTarget: self action:@selector(toText:) forControlEvents: UIControlEventTouchUpInside];
                }
                else if([type isEqualToString: @"movie"]) {
                    button.frame = CGRectMake( center  - lab.frame.size.width*1.3/2, originY , lab.frame.size.width*1.3, 50);
                    [button addTarget: self action:@selector(toMovie:) forControlEvents: UIControlEventTouchUpInside];
                }
                else if([type isEqualToString: @"quiz"]) {
                    [button addTarget: self action:@selector(toQuiz:) forControlEvents: UIControlEventTouchUpInside];
                }
                else if([type isEqualToString: @"zoom"]) {
                    [button addTarget: self action:@selector(toZoom:) forControlEvents: UIControlEventTouchUpInside];
                }
                else if([type isEqualToString: @"animate"]) {
                    [button addTarget: self action:@selector(toAnimateImage:) forControlEvents: UIControlEventTouchUpInside];
                }
                [self.view addSubview: button];
                
                originY = originY + 50 + 10;
            }
            
        }
        
        /*
        // si on a une seule sous-section, on passe directement dessus
        NSString *type = [parser.types objectAtIndex: 0];
        if(parser.names.count == 1 && ![type isEqualToString:@"audio"] && ![type isEqualToString:@"movie"]) {
            NSLog(@"Only one subsection");
            [self setNumberOfPagesToPop: [NSNumber numberWithInt: 2]]; // utile pour faire un retour "direct" à la page de scan
            UIButton *buttonClicked = [[UIButton alloc] init];
            buttonClicked.tag = 0;
            if([type isEqualToString: @"slideshow"]) {
                NSLog(@"\t type slide");
                [self toSlideshow: buttonClicked];
            }
            else if([type isEqualToString: @"text"]) {
                NSLog(@"\t type text");
                [self toText: buttonClicked];
            }
            else if([type isEqualToString: @"quiz"] || [type isEqualToString: @"quizz"]) {
                NSLog(@"\t type quiz");
                [self toQuiz: buttonClicked];
            }
            else if([type isEqualToString: @"zoom"]) {
                NSLog(@"\t type zoom");
                [self toZoom: buttonClicked];
            }
            else if([type isEqualToString: @"animate"]) {
                NSLog(@"\t type animate");
                [self toAnimateImage: buttonClicked];
            }
        }
        */
        
    }
    else {
        Alerts *alert = [[Alerts alloc] init];
        [alert errorParsingAlert:self file:parser.path error: @"File is probably not a section file."];
    }
}


-(IBAction)toSlideshow:(id)sender {
    
    int idx = ((UIButton*)sender).tag;
    argument = [parser.files objectAtIndex: idx];
    NSLog(@"cliqué slideshow object idx %@", argument);
    [self performSegueWithIdentifier: @"toSlideshow" sender: self];
}

-(IBAction)toText:(id)sender {
    NSLog(@"cliqué text");
    int idx = ((UIButton*)sender).tag;
    argument = [parser.files objectAtIndex: idx];
    [self performSegueWithIdentifier: @"toTextSection" sender: self];
}

-(IBAction)toMovie:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.files objectAtIndex: idx];
    NSLog(@"cliqué Movie %@", argument);
    [self performSegueWithIdentifier: @"toMovie" sender: self];
}

-(IBAction)toQuiz:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.files objectAtIndex: idx];
    NSLog(@"cliqué quiz %@", argument);
    [self performSegueWithIdentifier: @"toQuiz" sender: self];
}

-(IBAction)toZoom:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.files objectAtIndex: idx];
    NSLog(@"cliqué zoom %@", argument);
    [self performSegueWithIdentifier: @"toZoom" sender: self];
}

-(IBAction)toAnimateImage:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.files objectAtIndex: idx];
    NSLog(@"cliqué animate %@", argument);
    [self performSegueWithIdentifier: @"toAnimate" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"prepare for segue");
    if( [segue.identifier isEqualToString:@"toTextSection"] ) {
        TextViewController *textVC = [segue destinationViewController];
        textVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"toSlideshow"] ) {
        SlideshowViewController *slideshowVC = [segue destinationViewController];
        slideshowVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"toMovie"] ) {
        MovieViewController *movieVC = [segue destinationViewController];
        movieVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"toQuiz"] ) {
        QuizViewController *quizVC = [segue destinationViewController];
        quizVC.fileName = argument;
    }
    else if( [segue.identifier isEqualToString:@"toAnimate"] ) {
        AnimateImageViewController *animateVC = [segue destinationViewController];
        animateVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"toZoom"] ) {
        ImageZoomViewController *zoomVC = [segue destinationViewController];
        zoomVC.fileName = argument;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (int)addAudiotoView: (UIView *)view atPoint:(int)originY fromIndex:(int) index {
    if([Config instance].audioOn) {
        NSError *error;
        
        //NSLog(@"audio file : %@", [[LanguageManagement instance] pathForFile: audio]);
        NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: [parser.files objectAtIndex: index] contentFile: NO]];
        if(data == nil) {
            Alerts *alert = [[Alerts alloc] init];
            [alert showAudioNotFoundAlert: self file: [parser.files objectAtIndex: index]];
        }
        else {
            AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData: data error: &error];

            if(audioPlayer == nil) {
                NSLog(@"AudioPlayer error");
            }
            else {
                
                // La gestion de l'audio est locale dans ce cas-ci. Il faudra penser à la mettre dans AudioViewController
                [audioPlayer prepareToPlay];
                [audioPlayers addObject: audioPlayer];
                return [self createButtonsToView: view atPoint: originY fromIndex: index];
            }
        }
    }
    return 0;
}

- (int)createButtonsToView:(UIView *)view atPoint:(int) originY fromIndex:(int) i{
    int center = self.view.frame.size.width / 2;
    
    UILabel *audioComment = [[UILabel alloc] init];
    audioComment.text = [parser.names objectAtIndex: i];
    audioComment.font = [[Config instance] normalFont];
    audioComment.textColor = [[Config instance] color1];
    audioComment.backgroundColor = [UIColor clearColor];
    [audioComment sizeToFit];
    [view addSubview: audioComment];
    audioComment.frame = CGRectMake(self.view.frame.size.width/2 - audioComment.frame.size.width/2 , originY,  audioComment.frame.size.width,  audioComment.frame.size.height);
    
    
    int widthButton = 50;
    int heightButton = 40;
    originY += audioComment.frame.size.height*1.2;
    playButton = [ColorButton getButton];
    playButton.frame = CGRectMake(center - 2 * widthButton - 20, originY, widthButton, heightButton);
    //[playButton setTitle: @"Play" forState: UIControlStateNormal];
    [playButton setImage: [UIImage imageNamed:@"play.png"] forState: UIControlStateNormal];
    playButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    pauseButton = [ColorButton getButton];
    pauseButton.frame = CGRectMake(center - widthButton - 10, originY, widthButton, heightButton);
    //[pauseButton setTitle: @"Pause" forState: UIControlStateNormal];
    [pauseButton setImage: [UIImage imageNamed:@"pause.png"] forState: UIControlStateNormal];
    pauseButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [pauseButton addTarget:self action:@selector(pauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    stopButton = [ColorButton getButton];
    stopButton.frame = CGRectMake(center, originY, widthButton, heightButton);
    //[stopButton setTitle: @"Stop" forState: UIControlStateNormal];
    [stopButton setImage: [UIImage imageNamed:@"stop.png"] forState: UIControlStateNormal];
    stopButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [stopButton addTarget:self action:@selector(stopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    volumeButton = [ColorButton getButton];
    volumeButton.tag = 9999;
    volumeButton.frame = CGRectMake(center + widthButton + 10, originY, widthButton, heightButton);
    volumeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [volumeButton setImage: [UIImage imageNamed:@"sound.png"] forState: UIControlStateNormal];
    
    [volumeButton addTarget:self action:@selector(volumeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    playButton.tag = audioPlayerNr;
    pauseButton.tag = audioPlayerNr;
    stopButton.tag = audioPlayerNr;
    audioPlayerNr++;
    
    [view addSubview: playButton];
    [view addSubview: pauseButton];
    [view addSubview: stopButton];
    [view addSubview: volumeButton];
    
    return 90;
}
    



- (IBAction)playButtonClicked:(id)sender {
    UIButton *buttonClicked = ((UIButton*)sender);
    AVAudioPlayer *playerRelated = [audioPlayers objectAtIndex: buttonClicked.tag];
    
    
    //on vérifie que rien d'autre n'est joué en ce moment
    AVAudioPlayer *player;
    Boolean isAudioPlaying = NO;
    for(player in audioPlayers) 
        if(player.isPlaying) 
            isAudioPlaying = YES;

    
    if(!isAudioPlaying) {
        lastAudioPlayed = buttonClicked.tag;
        [playerRelated play];
    }
}

- (IBAction)pauseButtonClicked:(id)sender {
    UIButton *buttonClicked = ((UIButton*)sender);
    AVAudioPlayer *playerRelated = [audioPlayers objectAtIndex: buttonClicked.tag];
    if(lastAudioPlayed == ((UIButton*)sender).tag)
        [playerRelated pause];
}

- (IBAction)stopButtonClicked:(id)sender {
    UIButton *buttonClicked = ((UIButton*)sender);
    AVAudioPlayer *playerRelated = [audioPlayers objectAtIndex: buttonClicked.tag];
    if(lastAudioPlayed == ((UIButton*)sender).tag) {
        [playerRelated stop];
        [playerRelated setCurrentTime:0];
    }
}

- (IBAction)volumeButtonClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    if( [popover isPopoverVisible]) {
        [popover dismissPopoverAnimated: YES];
    }
    else {
        [self showPopup: button.frame];
        
    }
}

- (void)showPopup:(CGRect)rect {
    UIViewController *popup = [[UIViewController alloc] init];
    popup.view.backgroundColor = [UIColor clearColor];
    
    
    volumeViewSlider = [[MPVolumeView alloc] init];
    
    for(id current in volumeViewSlider.subviews) {
        if([current isKindOfClass:[UISlider class]]) {
            UISlider *volumeSlider = (UISlider*)current;
            volumeSlider.minimumTrackTintColor = [[Config instance] color2];
        }
    }
    
    volumeViewSlider.frame = CGRectMake(0, 0, 300, 100);
    [volumeViewSlider sizeToFit];
    [popup.view addSubview: volumeViewSlider];
    
    
    popover = [[UIPopoverController alloc] initWithContentViewController: popup];
    
    popover.popoverContentSize = volumeViewSlider.frame.size;
    [popover presentPopoverFromRect: rect
                             inView: self.view
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        UIView *view;
        int center = 1024/2;
        for(view in [self.view subviews]) {
            if(view.tag != 999) {
                int difference = view.frame.origin.x - 768/2;
                view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
        }
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        UIView *view;
        int center = 768/2;
        for(view in [self.view subviews]) {
            if(view.tag != 999) {
                int difference = view.frame.origin.x - 1024/2;
                view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
        }
    }
}


@end
