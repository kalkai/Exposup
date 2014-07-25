//
//  Labels.m
//  ExpoSup
//
//  Created by Jean Richelle on 9/01/14.
//
//

#import "Labels.h"

@implementation Labels

@synthesize  labelsParser;

-(NSString*)expoTitle { return labelsParser.expoTitle; }
-(NSString*)welcomeTitle { return labelsParser.welcomeTitle; }
-(NSString*)backButtonLabel { return labelsParser.backButtonLabel;}
-(NSString*)chooseModLabel { return labelsParser.chooseModLabel;}
-(NSString*)adultButton { return labelsParser.adultButton;}
-(NSString*)guideButton { return labelsParser.guideButton;}
-(NSString*)childButton { return labelsParser.childButton;}
-(NSString*)soundButtonLabel { return labelsParser.soundButtonLabel;}
-(NSString*)chosenModLabel { return labelsParser.chosenModLabel;}
-(NSString*)modifyMod { return labelsParser.modifyMod;}
-(NSString*)confirmMod { return labelsParser.confirmMod;}
-(NSString*)scanInstruction { return labelsParser.scanInstruction;}
-(NSString*)toIDButton { return labelsParser.toIDButton;}
-(NSString*)IDInstruction { return labelsParser.IDInstruction;}
-(NSString*)validateButton { return labelsParser.validateButton;}
-(NSString*)userManual { return labelsParser.userManual; }
-(NSString*)expandSynopsis { return labelsParser.expandSynopsis; }
-(NSString*)contractSynopsis { return labelsParser.contractSynopsis; }
-(NSString*)animateButton { return labelsParser.animateButton; }

-(NSString*)credits { return @"ExpoSup, v3.04, © 2014 (Belgique) \nRéalisation et conception : Aurélien Lebeau et Jean Richelle - Département d'Informatique de la Faculté des Sciences de l'ULB et Centre de Culture Scientifique de l'ULB \nPour le projet \"Vers le Lune avec Tania\" - Maison de la Science de l'ULg, Centre de Culture Scientifique de l'ULB et Euro Space Center à Transinne - financé par la DG06 du SPW"; }




+(Labels*)instance {
    static Labels *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Labels alloc] init];
        if(![instance initialize])
            instance = nil;
    });
    return instance;
}

- (Boolean)initialize {

    labelsParser = [[XMLLabelsParser alloc] init];
    [labelsParser parseXMLLabels];

    return true;
}

- (void)updateLabels {
    labelsParser = [[XMLLabelsParser alloc] init];
    [labelsParser parseXMLLabels];
}


@end
