//
//  AppDelegate.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "BeaconManager.h"


@interface AppDelegate : BeaconManager<UIApplicationDelegate> {
}

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) NSString *mod;

@end