//
//  AudioViewController.m
//  ExpoSup
//
//  Created by Jean Richelle on 28/09/13.
//
//

#import "AudioViewController.h"

@interface AudioViewController ()

@end

@implementation AudioViewController

@synthesize file,autostart,repetition, audioPlayer, pauseButton , playButton, stopButton, name, audioComment, volumeButton, popover, currentView, volumeViewSlider, popController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addAudioAndPlayOnceToView:(UIView*)view parent:(SectionParentViewController*)parent {
    NSLog(@"add audio, file = %@", file);
    if([Config instance].audioOn) {
        
        
        if(file != nil && ![file isEqual: nil] && ![file isEqualToString: [[NSString alloc] init]]) {
            NSError *error;
            [parent setIsPageWithAudio:YES];
            NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: file contentFile: NO]];
            if(data == nil) {
                //Alerts *alert = [[Alerts alloc] init];
                //[alert showAudioNotFoundAlert: self file: file];
                UIAlertController* alert = [Alerts getAudioNotFoundAlert:file];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                audioPlayer = [[AVAudioPlayer alloc] initWithData: data error: &error];
                
                if(audioPlayer == nil) {
                    NSLog(@"AudioPlayer error");
                }
                else {
                    [audioPlayer prepareToPlay];
                    NSLog(@"Audio file %@", file);
                    NSLog(autostart ? @"Autostart true" : @"Autostart false");
                    NSLog(repetition ? @"Repetition true" : @"Repetition false");
                    
                    audioPlayer.numberOfLoops = 0;
                    [self playButtonClicked: self];
                }
            }
        }
    }

}

- (Boolean)addAudioToView: (UIView *)view atY:(int) y width:(int)width startDelayed:(bool)delayed parent:(SectionParentViewController*)parent {
    NSLog(@"add audio, file = %@", file);
    if([Config instance].audioOn) {
        
        if(file != nil && ![file isEqual: nil] && ![file isEqualToString: [[NSString alloc] init]]) {
            NSError *error;
            [parent setIsPageWithAudio:YES];
            NSData *data = [NSData  dataWithContentsOfFile: [[LanguageManagement instance] pathForFile: file contentFile: NO]];
            if(data == nil) {
                //Alerts *alert = [[Alerts alloc] init];
                //[alert showAudioNotFoundAlert: self file: file];
                UIAlertController *alert = [Alerts getAudioNotFoundAlert:file];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                audioPlayer = [[AVAudioPlayer alloc] initWithData: data error: &error];
                
                if(audioPlayer == nil) {
                    NSLog(@"AudioPlayer error");
                    return NO;
                }
                else {
                    //NSLog(@"Play");
                    //NSLog(@"audio player %@", audioPlayer);
                    [audioPlayer prepareToPlay];
                    NSLog(@"Audio file %@", file);
                    NSLog(autostart ? @"Autostart true" : @"Autostart false");
                    NSLog(repetition ? @"Repetition true" : @"Repetition false");
                    [self createButtonsToView: view Yoffset: y width: width];
                    
                    if (autostart && !delayed)
                        [self playButtonClicked: self];
                    if(repetition)
                        audioPlayer.numberOfLoops = -1;
                    
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (void)canStart {
    if(autostart) {
        [self playButtonClicked: self];
    }
}

- (int)createButtonsToView:(UIView *)view Yoffset:(int)y width:(int)width {
    currentView = view;
    audioComment = [[UILabel alloc] init];
    audioComment.tag = 9999;
    if(name != nil && ![name isEqualToString: @"noaudio"]) {
        audioComment.text = name;
    }
    else {
        audioComment.text = @"Commentaire audio : ";
    }
    NSLog(@"Name : %@", name);
    audioComment.font = [[Config instance] tinyFont];
    audioComment.textColor = [[Config instance] color1];
    audioComment.backgroundColor = [UIColor clearColor];
    [audioComment sizeToFit];
    [view addSubview: audioComment];
    
    playButton = [ColorButton getButton];
    playButton.tag = 9999;

    
    int widthButton = 50;
    int heightButton = 40;
    
    int totalWidth = 4 * widthButton + audioComment.frame.size.width + 5*20;
    
    
    playButton.frame = CGRectMake(width/2-totalWidth/2 + audioComment.frame.size.width + 20, y, widthButton, heightButton);
    //[playButton setTitle: @"Play" forState: UIControlStateNormal];
    [playButton setImage: [UIImage imageNamed:@"play.png"] forState: UIControlStateNormal];
    playButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    audioComment.frame = CGRectMake(playButton.frame.origin.x - audioComment.frame.size.width - 15, y + heightButton/2 - audioComment.frame.size.height/2, audioComment.frame.size.width, audioComment.frame.size.height);
    
    pauseButton = [ColorButton getButton];
    pauseButton.tag = 9999;
    pauseButton.frame = CGRectMake(width/2-totalWidth/2 + audioComment.frame.size.width + widthButton + 2*20, y, widthButton, heightButton);
    //[pauseButton setTitle: @"Pause" forState: UIControlStateNormal];

    
    [pauseButton setImage: [UIImage imageNamed:@"pause.png"] forState: UIControlStateNormal];
    pauseButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [pauseButton addTarget:self action:@selector(pauseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    stopButton = [ColorButton getButton];
    stopButton.tag = 9999;
    stopButton.frame = CGRectMake(width/2-totalWidth/2 + audioComment.frame.size.width + 2*widthButton + 3*20, y, widthButton, heightButton);
    //[stopButton setTitle: @"Stop" forState: UIControlStateNormal];
    stopButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [stopButton setImage: [UIImage imageNamed:@"stop.png"] forState: UIControlStateNormal];
    [stopButton addTarget:self action:@selector(stopButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    volumeButton = [ColorButton getButton];
    volumeButton.tag = 9999;
    volumeButton.frame = CGRectMake(width/2-totalWidth/2 + audioComment.frame.size.width + 3*widthButton + 4*20, y, widthButton, heightButton);
    volumeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [volumeButton setImage: [UIImage imageNamed:@"sound.png"] forState: UIControlStateNormal];
    
    [volumeButton addTarget:self action:@selector(volumeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [view addSubview: playButton];
    [view addSubview: pauseButton];
    [view addSubview: stopButton];
    [view addSubview: volumeButton];
    
    return 80;
}

- (IBAction)playButtonClicked:(id)sender {
    [audioPlayer play];
}

- (IBAction)pauseButtonClicked:(id)sender {
    [audioPlayer pause];
}

- (IBAction)stopButtonClicked:(id)sender {
    [audioPlayer stop];
    [audioPlayer setCurrentTime:0];
}

-(void) removeVolumeIcon {
    [volumeButton removeFromSuperview];
}


-(void) addVolumeButton:(UIView *)view Yoffset:(int)y Xoffset:(int)x {
    currentView = view;
    
    int widthButton = 50;
    int heightButton = 40;
    
    volumeButton = [ColorButton getButton];
    volumeButton.tag = 9999;
    volumeButton.frame = CGRectMake(x, y, widthButton, heightButton);
    volumeButton.imageEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    [volumeButton setImage: [UIImage imageNamed:@"sound.png"] forState: UIControlStateNormal];
    
    [volumeButton addTarget:self action:@selector(volumeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview: volumeButton];
}


- (IBAction)volumeButtonClicked:(id)sender {
    UIButton *button = (UIButton*)sender;
    //if( [popover isPopoverVisible]) {
    //    [popover dismissPopoverAnimated: YES];
    //}
    //else {
        [self showPopup: button.frame];
    //}
}

- (void)showPopup:(CGRect)rect {
    popover = [[UIViewController alloc] init];
    popover.view.backgroundColor = [UIColor clearColor];
    
    
    volumeViewSlider = [[MPVolumeView alloc] init];
    
    for(id current in volumeViewSlider.subviews) {
        if([current isKindOfClass:[UISlider class]]) {
            UISlider *volumeSlider = (UISlider*)current;
            volumeSlider.minimumTrackTintColor = [[Config instance] color2];
        }
    }
    
    volumeViewSlider.frame = CGRectMake(0, 0, 300, 50);
    [volumeViewSlider sizeToFit];
    [popover.view addSubview: volumeViewSlider];
    
    // Before iOS 9
    /*
    popover = [[UIPopoverController alloc] initWithContentViewController: popup];
    
    popover.popoverContentSize = volumeViewSlider.frame.size;
    [popover presentPopoverFromRect: rect
                             inView: currentView
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];*/
    
    // After iOS 9
    popover.modalPresentationStyle = UIModalPresentationPopover;
    popover.preferredContentSize = volumeViewSlider.frame.size;
    [self presentViewController: popover animated:YES completion:nil];
    
    // configure the Popover presentation controller
    popController = [popover popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = currentView;
    popController.sourceRect = rect;
    popController.delegate = self;
}


- (Boolean)tryToStop:(id)sender {
    if([audioPlayer isPlaying]) {
        [self stopButtonClicked: self];
        return true;
    }
    return false;
}

- (void)deleteFromView {
    [audioComment removeFromSuperview];
    [playButton removeFromSuperview];
    [pauseButton removeFromSuperview];
    [stopButton removeFromSuperview];
    [volumeButton removeFromSuperview];
}


@end
