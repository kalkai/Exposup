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

- (IBAction)showEmptyFieldAlert:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Champs vide"
                                                    message: @"Veuillez indiquer un identifiant avant de continuer"
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showIDNotFoundAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Identifiant non valide"
                                                    message: @"L'identifiant que vous avez indiqué n'existe pas."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showQRCodeNotFoundAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Identifiant non valide"
                                                    message: @"La section liée à ce QR code n'existe pas."
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


- (IBAction)showSlideshowNotFoundAlert:(id)sender file:(NSString*)file {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant le slideshow demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showZoomNotFoundAlert:(id)sender file:(NSString*)file {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                    message: [@"Le fichier contenant le zoom demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showVideoNotFoundAlert:(id)sender file:(NSString*)file {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                    message: [@"Le fichier vidéo demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showTextNotFoundAlert:(id)sender file:(NSString*)file {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant la section texte demandée n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showConfigNotFoundAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: @"Le fichier de configuration n'existe pas. Fichier : config.xml"
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showDictionaryNotFoundAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant le dictionnaire n'existe pas. Fichier : "stringByAppendingString: [[[LanguageManagement instance] currentLanguagePrefix] stringByAppendingString: @"dictionary.xml"]]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showLabelsNotFoundAlert:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                    message: [@"Le fichier contenant les labels n'existe pas. Fichier : "stringByAppendingString: [[[LanguageManagement instance] currentLanguagePrefix] stringByAppendingString: @"labels.xml"]]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showQuizNotFoundAlert:(id)sender file:(NSString*)file {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier manquant"
                                                message: [@"Le fichier contenant le quiz demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];
}

- (IBAction)errorParsingAlert:(id)sender file:(NSString*)file error:(NSString *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Parsing error"
                                                    message: [[@"Le fichier xml correspondant contient des erreurs. Fichier : " stringByAppendingString: file] stringByAppendingString: [@" Erreur : " stringByAppendingString: error]]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


- (IBAction)showAudioNotFoundAlert:(id)sender file:(NSString*)file {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier audio manquant"
                                                message: [@"Le fichier audio demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                               delegate: nil
                                      cancelButtonTitle: @"OK"
                                      otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showImageNotFoundAlert:(id)sender file:(NSString*)file {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Fichier image manquant"
                                                    message: [@"Le fichier image demandé n'existe pas. Fichier : " stringByAppendingString: file]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

- (IBAction)showPoliceNotFoundAlert:(id)sender name:(NSString*)name num:(int) num  {
    NSString *police = [[NSString alloc] init];
    if(num == 1)
        police = @"<bigFont>";
    else if(num == 2)
        police = @"<normalFont>";
    else if(num == 3)
        police = @"<smallFont>";
    else if(num == 4)
        police = @"<tinyFont>";
    else if(num == 5)
        police = @"<quoteFont>";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Police inexisante"
                                                    message: [[@"La police n'existe pas : "             stringByAppendingString: name] stringByAppendingString: [@"\n paramètre: " stringByAppendingString: police]]
                                                   delegate: nil
                                          cancelButtonTitle: @"OK"
                                          otherButtonTitles: nil];
    [alert show];
}

@end
