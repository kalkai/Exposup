//
//  BeaconManager.m
//  IBeaconTraining
//
//

#import "BeaconManager.h"
#import "XMLBeaconConfigParser.h"
#import "XMLBeaconParsers.h"
@interface BeaconManager ()

@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLBeaconRegion  *beaconRegion;
@property(strong, nonatomic)NSMutableDictionary *beaconsDiscovered;
@property(strong, nonatomic)XMLBeaconConfigParser *index;



@end

@implementation BeaconManager

-(instancetype)init{
    self = [super init];
    
    // INSTANTIATE ATTRIBUTES HERE
    _beaconsDiscovered = [[NSMutableDictionary alloc] init];
    _currentBeacons = [[NSMutableArray alloc] init];
    
    _ZoneToBeacons = [[NSMutableDictionary alloc] init];
    _SortedZoneToBeacons = [[NSMutableDictionary alloc] init];
    
    
    _ImidiateBeacons = [[NSMutableArray alloc] init];
    _NearBeacons = [[NSMutableArray alloc] init];
    _FarBeacons = [[NSMutableArray alloc] init];
    _UnknownBeacons = [[NSMutableArray alloc] init];
    
    _locationManager =  [[CLLocationManager alloc] init];
    _SectionKeyArray = [[NSMutableArray alloc] init];
    NSUUID * beaconUUID = [[NSUUID alloc] initWithUUIDString:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"];
    _beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID: beaconUUID identifier:@"BeaconsIdentifier"];
    _touchedIds = [[NSMutableArray alloc]init];
    _locationManager.delegate = self;
    _index = [XMLBeaconConfigParser instance];
    _zones =  [XMLBeaconParsers instance].zones;
    return self;
}

-(void)startBeaconRanging{
    [_locationManager requestAlwaysAuthorization];
    [_locationManager startRangingBeaconsInRegion:_beaconRegion];
    [_locationManager startUpdatingLocation];
}

-(void)stopBeaconRanging{
    [_locationManager stopUpdatingLocation];
    [_locationManager stopRangingBeaconsInRegion:_beaconRegion];
}




-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
};

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray<CLBeacon *> *)beacons inRegion:(CLBeaconRegion *)region{
    
    [_currentBeacons  removeAllObjects];
    [_ZoneToBeacons removeAllObjects];
    [_SortedZoneToBeacons removeAllObjects];
    [_ImidiateBeacons removeAllObjects];
    [_NearBeacons removeAllObjects];
    [_FarBeacons removeAllObjects];
    [_UnknownBeacons removeAllObjects];
    for(CLBeacon* aBeacon in beacons){
        double acc = aBeacon.accuracy;
        NSLog(@"%f",acc);
        NSString *BeaconMajorkey = [ _index.mapMajortoZone objectForKey:[NSString stringWithFormat:@"%d",aBeacon.major.intValue]];
        
        NSString *BeaconMinorkey =  [ _index.mapMajortoZone objectForKey:[NSString stringWithFormat:@"%d",aBeacon.minor.intValue]];
        
        //        if (aBeacon.proximity == CLProximityImmediate){
        //            [_ImidiateBeacons addObject:BeaconMinorkey];
        //        }
        //        if (aBeacon.proximity == CLProximityNear){
        //            [_NearBeacons addObject:BeaconMinorkey];
        //        }
        //        if (aBeacon.proximity == CLProximityFar){
        //            [_FarBeacons addObject:BeaconMinorkey];
        //        }
        //        if (aBeacon.proximity == CLProximityUnknown){
        //            [_UnknownBeacons addObject:BeaconMinorkey];
        //        }
//        if ([_ZoneToBeacons objectForKey:BeaconMajorkey ] == nil /*&& (aBeacon.proximity == CLProximityNear || aBeacon.proximity == CLProximityImmediate)*/){
//            //[_keyArray addObject:BeaconMajorkey];
//            [_ZoneToBeacons setValue:[[NSMutableArray alloc] init] forKey:BeaconMajorkey];
//        }
//        [_beaconsDiscovered setValue:aBeacon forKey:BeaconMinorkey];
        //        if(aBeacon.proximity == CLProximityNear || aBeacon.proximity == CLProximityImmediate){
        [_currentBeacons addObject:BeaconMajorkey];
        //NSLog(@"VAAAAALEUR");
        //[_ZoneToBeacons[BeaconMajorkey] addObject:BeaconMinorkey];
        //NSLog(@"%@", _ZoneToBeacons);
        
        //        }
    }
    
    for (NSMutableArray *zone in _zones ){
        if ([_currentBeacons containsObject:zone] == FALSE){
            [_currentBeacons addObject:zone];
        }
    }
    
//    NSMutableArray *dictValues = [[_ZoneToBeacons allValues] mutableCopy];
//    
//    //[dictValues autorelease]; //only needed for manual reference counting
//    
//    [dictValues sortUsingComparator: (NSComparator)^(NSArray *a, NSArray *b)
//     {
//         NSUInteger key1 = [a count];
//         NSUInteger key2 = [b count];
//         if (key1 == key2)
//             return false;
//         else
//             return key1 < key2;
//     }
//     ];
//    //NSLog(@"%@", dictValues);
//    
//    for(NSArray* value in dictValues){
//        //        NSLog(@"VAAAAALEUR222");
//        //        NSLog(@"%@", value);
//        NSArray * arrayofKeys = [_ZoneToBeacons allKeysForObject:value];
//        NSString * key = [arrayofKeys firstObject];
//        [_SortedZoneToBeacons setValue:value forKey:key];
//    };
//    //NSLog(@"%@", _SortedZoneToBeacons);
//    
//    //NSLog(@"%@", dictValues);
//    _SectionKeyArray = [NSMutableArray arrayWithArray:[_SortedZoneToBeacons allKeys]];
    
//    NSLog(@"%@", _ImidiateBeacons);
    //NSLog(@"%@", _SortedZoneToBeacons);
//    NSLog(@"%@", _currentBeacons);
    //NSLog(@"%@", _SectionKeyArray);
    [_delegate updateCurrentBeacons];
}



@end
