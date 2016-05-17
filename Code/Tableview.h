//
//  Tableview.h
//  exposup
//
//  Created by Kevin on 2/05/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BeaconManagerDelegate.h"
#import "AppDelegate.h"

@interface Tableview : UITableView{
    IBOutlet UITableView *tableView;
    AppDelegate * beaconManager;
}

@end
 