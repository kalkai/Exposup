//
//  BeaconManager.h
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BeaconManagerDelegate.h"

@interface BeaconManager : UIResponder <CLLocationManagerDelegate>

@property(strong, nonatomic)NSMutableArray *currentBeacons;
@property(strong, nonatomic)NSMutableArray *SectionKeyArray;
@property(strong, nonatomic)NSMutableArray *ImidiateBeacons;
@property(strong, nonatomic)NSMutableArray *NearBeacons;
@property(strong, nonatomic)NSMutableArray *FarBeacons;
@property(strong, nonatomic)NSMutableArray *UnknownBeacons;
@property(weak, nonatomic) id<BeaconManagerDelegate> delegate;
@property(strong, nonatomic)NSMutableDictionary *ZoneToBeacons;
@property(strong, nonatomic)NSMutableDictionary *linkBeacontoZone;
@property(strong, nonatomic)NSMutableDictionary *SortedZoneToBeacons;
@property(strong, nonatomic)NSMutableArray *touchedIds;
@property(strong ,nonatomic)NSMutableArray *zones;
-(void) startBeaconRanging;
-(void) stopBeaconRanging;
@end
