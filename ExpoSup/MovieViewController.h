//
//  MovieViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 6/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionParentViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Alerts.h"
#import "AudioViewController.h"

@interface MovieViewController : SectionParentViewController

@property (assign, nonatomic) NSString *standID;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;

@property (strong, nonatomic) AudioViewController *audioController;

@end
