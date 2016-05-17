//
//  ViewController.m
//  IBeaconTraining
//
//  Created by Florian Praile on 25/03/16.
//  Copyright © 2016 Underside. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@implementation ViewController

@synthesize tableView,beaconManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    tableView.delegate=self;
    tableView.dataSource =self;
    
    beaconManager = (AppDelegate*) [UIApplication sharedApplication].delegate;
    beaconManager.delegate = self;
}

-(void)updateCurrentBeacons{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return beaconManager.currentBeacons.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [self.tableView  dequeueReusableCellWithIdentifier:@"beaconCellId" forIndexPath:indexPath];
    cell.textLabel.text =  beaconManager.currentBeacons[indexPath.row];
    return cell;
}

@end
