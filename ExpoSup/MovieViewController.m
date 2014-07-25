//
//  MovieViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 6/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "MovieViewController.h"

@implementation MovieViewController

@synthesize standID,moviePlayer, audioController;

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
    [audioController removeVolumeIcon];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        moviePlayer.view.frame = CGRectMake(0, 0, 1024, 768);
        [audioController addVolumeButton: moviePlayer.view Yoffset:690 Xoffset:950 ];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        moviePlayer.view.frame = CGRectMake(0, 0, 768, 1024);
        [audioController addVolumeButton: moviePlayer.view Yoffset:940 Xoffset:700 ];
    }
    [super viewWillAppear:YES];
    [moviePlayer play];
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
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    //verifier s fichier existe
    
    NSString *filePath = [[LanguageManagement instance] pathForFile: standID contentFile: NO];
    NSLog(@"movie file path: %@", filePath);
    
    moviePlayer = [[MPMoviePlayerController alloc] init];
    [moviePlayer setContentURL: [NSURL fileURLWithPath: filePath]];

    if(![self isFileFound: filePath]) {
        NSLog(@"error movie player");
        Alerts *alert = [[Alerts alloc] init];
        [alert showVideoNotFoundAlert:self file: standID];
    }
    else {
        moviePlayer.shouldAutoplay = YES;
        moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
    
        moviePlayer.fullscreen = NO;
        [self.view addSubview: moviePlayer.view];
    
        audioController = [[AudioViewController alloc] init];
        
        NSLog(@"load state %i", moviePlayer.loadState);
        
    }
    [super viewDidLoad];
    [self setIsPageWithAudio:YES];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    moviePlayer = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [audioController removeVolumeIcon];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        moviePlayer.view.frame = CGRectMake(0, 0, 1024, 768);
        [audioController addVolumeButton: moviePlayer.view Yoffset:690 Xoffset:950 ];

    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        moviePlayer.view.frame = CGRectMake(0, 0, 768, 1024);
        [audioController addVolumeButton: moviePlayer.view Yoffset:940 Xoffset:700 ];

    }
}

- (BOOL)isFileFound:(NSString *)fileName {
    NSFileManager *filemgr;
    filemgr = [NSFileManager defaultManager];
    return [filemgr fileExistsAtPath: fileName];
}




@end
