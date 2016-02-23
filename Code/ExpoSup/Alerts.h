//
//  Alerts.h
//  ExpoSup
//
//  Created by Aurélien Lebeau on 25/05/13.
//
//

#import <Foundation/Foundation.h>

@interface Alerts : NSObject

+ (UIAlertController*)getEmptyFieldAlert;
+ (UIAlertController*)getIDNotFoundAlert;
+ (UIAlertController*)getQRCodeNotFoundAlert;
+ (UIAlertController*)getSlideshowNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getZoomNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getVideoNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getTextNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getWebNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getConfigNotFoundAlert;
+ (UIAlertController*)getDictionaryNotFoundAlert;
+ (UIAlertController*)getLabelsNotFoundAlert;
+ (UIAlertController*)getCameraNotFoundAlert:(int)errorCode;
+ (UIAlertController*)getQuizNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getParsingErrorAlert:(NSString*)file error:(NSString*)error;
+ (UIAlertController*)getAudioNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getImageNotFoundAlert:(NSString*)file;
+ (UIAlertController*)getFontNotFoundAlert:(NSString*)name value:(NSString*)font;
@end
