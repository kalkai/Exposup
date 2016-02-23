//
//  AnimateImageViewController.h
//  ExpoSup
//
//  Created by Aurélien Lebeau on 28/07/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "XMLAnimateImageParser.h"
#import "SectionParentViewController.h"

@interface AnimateImageViewController : SectionParentViewController

@property (assign, nonatomic) NSString *standID;
@property (strong, nonatomic) XMLAnimateImageParser *parser;

@property (strong, nonatomic) UIImageView* animationView;
@property (strong, nonatomic) UIButton *startButton;
@property (strong, nonatomic) UILabel *titleScreen;
@property (strong, nonatomic) UITextView *comment;
@property (assign, nonatomic) int currentWidth;
@property (assign, nonatomic) int tempHeight;


@end
