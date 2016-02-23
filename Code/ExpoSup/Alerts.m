//
//  Alerts.m
//  ExpoSup
//
//  Created by Aurélien Lebeau on 25/05/13.
//
//

#import "Alerts.h"
#import "LanguageManagement.h"

@implementation Alerts

+ (UIAlertController*)getEmptyFieldAlert{
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Champs vide"
                                                    message: @"Veuillez indiquer un identifiant avant de continuer"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    
    
    // After iOS 9
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Champs vide"
                                                                   message:@"Veuillez indiquer un identifiant avant de continuer"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getIDNotFoundAlert {
    // Before iOS 9
   /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Identifiant non valide"
                                                    message: @"L'identifiant que vous avez indiqué n'existe pas."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Identifiant non valide"
                                                                   message:@"L'identifiant que vous avez indiqué n'existe pas."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getQRCodeNotFoundAlert {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Identifiant non valide"
                                                    message: @"La section liée à ce QR code n'existe pas."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Identifiant non valide"
                                                                   message:@"La section liée à ce QR code n'existe pas."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    return alert;
}


+ (UIAlertController*)getSlideshowNotFoundAlert:(NSString*)file {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant le slideshow demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];*/
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant le slideshow demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getZoomNotFoundAlert:(NSString*)file {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                    message: [@"Le fichier contenant le zoom demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant le zoom demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getVideoNotFoundAlert:(NSString*)file {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                    message: [@"Le fichier vidéo demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier vidéo demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getTextNotFoundAlert:(NSString*)file {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant la section texte demandée n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant la section texte demandée n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getWebNotFoundAlert:(NSString*)file {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant la section web ou le lien indiqué n'existe pas. Fichier/Lien : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getConfigNotFoundAlert {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: @"Le fichier de configuration n'existe pas. Fichier : config.xml"
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];*/
    
    
    // After iOS 9
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:@"Le fichier de configuration n'existe pas. Fichier : config.xml"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getDictionaryNotFoundAlert {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant le dictionnaire n'existe pas. Fichier : "stringByAppendingString: [[[LanguageManagement instance] currentLanguagePrefix] stringByAppendingString: @"dictionary.xml"]]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant le dictionnaire n'existe pas. Fichier : "stringByAppendingString: [[[LanguageManagement instance] currentLanguagePrefix] stringByAppendingString: @"dictionary.xml"]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getLabelsNotFoundAlert {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                    message: [@"Le fichier contenant les labels n'existe pas. Fichier : "stringByAppendingString: [[[LanguageManagement instance] currentLanguagePrefix] stringByAppendingString: @"labels.xml"]]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant les labels n'existe pas. Fichier : "stringByAppendingString: [[[LanguageManagement instance] currentLanguagePrefix] stringByAppendingString: @"labels.xml"]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getCameraNotFoundAlert:(int)errorCode {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Erreur Caméra"
                                                                   message:[@"Impossible d'accéder à la caméra. Code d'erreur: " stringByAppendingString:[NSString stringWithFormat:@"%d", errorCode]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}


+ (UIAlertController*)getQuizNotFoundAlert:(NSString*)file {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant le quiz demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier contenant le quiz demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getParsingErrorAlert:(NSString*)file error:(NSString *)error {
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Parsing error"
                                                    message: [[@"Le fichier xml correspondant contient des erreurs. Fichier : " stringByAppendingString: file] stringByAppendingString: [@" Erreur : " stringByAppendingString: error]]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[[@"Le fichier xml correspondant contient des erreurs. Fichier : " stringByAppendingString: file] stringByAppendingString: [@" Erreur : " stringByAppendingString: error]]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}


+ (UIAlertController*)getAudioNotFoundAlert:(NSString*)file {

    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier audio manquant"
                                                message: [@"Le fichier audio demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];*/
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier audio demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getImageNotFoundAlert:(NSString*)file {
    
    // Before iOS 9
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier image manquant"
                                                    message: [@"Le fichier image demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show]; */
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Fichier manquant"
                                                                   message:[@"Le fichier image demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

+ (UIAlertController*)getFontNotFoundAlert:(NSString*)name value:(NSString*)font  {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Police inexisante"
                                                                   message:[[@"La police n'existe pas : "             stringByAppendingString: [name stringByAppendingString: @". Type: "]] stringByAppendingString: font]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    
    return alert;
}

@end
