//
//  Labels.h
//  ExpoSup
//
//  Created by Jean Richelle on 9/01/14.
//
//

#import <Foundation/Foundation.h>
#import "XMLLabelsParser.h"
#import "LanguageManagement.h"

@interface Labels : NSObject

@property (strong,nonatomic) XMLLabelsParser *labelsParser;

-(NSString*)credits;
-(NSString*)expoTitle;
-(NSString*)welcomeTitle;
-(NSString*)backButtonLabel;
-(NSString*)chooseModLabel;
-(NSString*)adultButton;
-(NSString*)guideButton;
-(NSString*)childButton;
-(NSString*)soundButtonLabel;
-(NSString*)chosenModLabel;
-(NSString*)modifyMod;
-(NSString*)confirmMod;
-(NSString*)scanInstruction;
-(NSString*)BeaconInfo;
-(NSString*)AreaLabel;
-(NSString*)toIDButton;
-(NSString*)IDInstruction;
-(NSString*)validateButton;
-(NSString*)userManual;
-(NSString*)animateButton;

-(NSString*)expandSynopsis;
-(NSString*)contractSynopsis;


+(Labels*)instance;

-(Boolean)initialize;
-(void)updateLabels;
@end
