//
//  ViewController.h
//  IBeaconTraining
//
//  Created by Florian Praile on 25/03/16.
//  Copyright © 2016 Underside. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeaconManagerDelegate.h"
#import "AppDelegate.h"
@interface ViewController : UIViewController <UITableViewDataSource, BeaconManagerDelegate,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AppDelegate * beaconManager;


@end

