//
//  MovieViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 6/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"

@implementation MovieViewController

@synthesize standID, audioController, player, playerController, playerFrame;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [audioController removeVolumeIcon];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        playerFrame = CGRectMake(0, 50, 1024, 718);
        playerController.view.frame = playerFrame;
        [audioController addVolumeButton: playerController.view viewController: self Yoffset:680 Xoffset:955 ];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        playerFrame = CGRectMake(0, 50, 768, 974);
        playerController.view.frame = playerFrame;
        [audioController addVolumeButton: playerController.view viewController: self Yoffset:930 Xoffset:705 ];
    }
    [super viewWillAppear:YES];
    //[moviePlayer play];
    [player play];
}

- (void) viewWillDisappear:(BOOL)animated {
    [player pause];
    [playerController.view removeFromSuperview];
    player = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    //verifier s fichier existe
    
    NSString *filePath = [[LanguageManagement instance] pathForFile: standID contentFile: NO];
    NSLog(@"movie file path: %@", filePath);
    
    //moviePlayer = [[MPMoviePlayerController alloc] init];
    //[moviePlayer setContentURL: [NSURL fileURLWithPath: filePath]];

    if(![self isFileFound: filePath]) {
        NSLog(@"error movie player");
        //Alerts *alert = [[Alerts alloc] init];
        //[alert showVideoNotFoundAlert:self file: standID];
        UIAlertController* alert = [Alerts getVideoNotFoundAlert:filePath];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        //moviePlayer.shouldAutoplay = YES;
        //moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        //moviePlayer.controlStyle = MPMovieControlStyleDefault;
        //moviePlayer.fullscreen = NO;
        //[self.view addSubview: moviePlayer.view];
        //NSLog(@"load state %i", moviePlayer.loadState);
        
        audioController = [[AudioViewController alloc] init];
        
        player = [AVPlayer playerWithURL:[NSURL fileURLWithPath: filePath]];
        //playerLayer = [AVPlayerLayer playerLayerWithPlayer: player];
        playerController = [[AVPlayerViewController alloc] init];
        playerController.player = player;
        playerController.view.frame = playerFrame;
        [self.view addSubview: playerController.view];
        
        
        
        //[self presentViewController:playerController animated:NO completion:nil];
        //playerController.view.frame = self.view.frame;
        //[self.view.layer addSublayer: playerLayer];
    }
    [super viewDidLoad];
    //[self setIsPageWithAudio:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    //moviePlayer = nil;
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
    
    [audioController removeVolumeIcon];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
       // playerLayer.frame = CGRectMake(0, 0, 1024, 768);
        //[audioController addVolumeButton: moviePlayer.view Yoffset:690 Xoffset:950 ];

    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //playerLayer.frame = CGRectMake(0, 0, 768, 1024);
        //[audioController addVolumeButton: moviePlayer.view Yoffset:940 Xoffset:700 ];

    }
}

- (BOOL)isFileFound:(NSString *)fileName {
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    return [filemgr fileExistsAtPath: fileName];
}




@end
