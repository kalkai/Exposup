//
//  RotateViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 3/04/13.
//
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Config.h"
#import "XMLParser.h"

@interface RotateViewController : UIViewController


- (BOOL)prefersStatusBarHidden;
- (void)setBackgroundImage:(NSString*)backFile;
@property (assign, nonatomic) UIInterfaceOrientation previousOrientation;


@end
