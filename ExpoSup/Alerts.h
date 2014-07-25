//
//  Alerts.h
//  ExpoSup
//
//  Created by Aurélien Lebeau on 25/05/13.
//
//

#import <Foundation/Foundation.h>

@interface Alerts : NSObject

- (IBAction)showEmptyFieldAlert:(id)sender;
- (IBAction)showIDNotFoundAlert:(id)sender;
- (IBAction)showQRCodeNotFoundAlert:(id)sender;
- (IBAction)showSlideshowNotFoundAlert:(id)sender file:(NSString*)file;
- (IBAction)showZoomNotFoundAlert:(id)sende file:(NSString*)filer;
- (IBAction)showVideoNotFoundAlert:(id)sender file:(NSString*)file;
- (IBAction)showTextNotFoundAlert:(id)sender file:(NSString*)file;
- (IBAction)showConfigNotFoundAlert:(id)sender;
- (IBAction)showDictionaryNotFoundAlert:(id)sender;
- (IBAction)showLabelsNotFoundAlert:(id)sender;
- (IBAction)showQuizNotFoundAlert:(id)sender file:(NSString*)file;
- (IBAction)errorParsingAlert:(id)sender file:(NSString*)file error:(NSString*)error;
- (IBAction)showAudioNotFoundAlert:(id)sender file:(NSString*)file;
- (IBAction)showImageNotFoundAlert:(id)sender file:(NSString*)file;
- (IBAction)showPoliceNotFoundAlert:(id)sender name:(NSString*)name num:(int) num;
@end
