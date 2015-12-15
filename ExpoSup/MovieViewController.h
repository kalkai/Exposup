//
//  MovieViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 6/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "SectionParentViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Alerts.h"
#import "AudioViewController.h"

@interface MovieViewController : SectionParentViewController

//@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (assign, nonatomic) NSString *standID;
@property (strong, nonatomic) AudioViewController *audioController;

@property (strong, nonatomic) AVPlayer* player;
//@property (strong, nonatomic) AVPlayerLayer* playerLayer;
@property (strong, nonatomic) AVPlayerViewController* playerController;
@property (assign, nonatomic) CGRect playerFrame;

@end
