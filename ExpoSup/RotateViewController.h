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

@interface RotateViewController : UIViewController

- (void)setBackgroundImage:(NSString*)backFile;
@property (assign, nonatomic) UIInterfaceOrientation previousOrientation;


@end
