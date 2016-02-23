//
//  selectedModViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RotateViewController.h"
#import "Config.h"
#import "ColorButton.h"


@interface SelectedModViewController : RotateViewController 

@property (strong, nonatomic) IBOutlet UIButton *change;
@property (strong, nonatomic) IBOutlet UIButton *confirm;

@property (weak, nonatomic) IBOutlet UILabel *modChosen;
@property (assign, nonatomic) NSString *modText;


- (IBAction)popView:(id)sender;


@end
