//
//  WebViewController.h
//  exposup
//
//  Created by Aurélien Lebeau on 15/12/15.
//
//

#import <UIKit/UIKit.h>
#import "LanguageManagement.h"
#import "SectionParentViewController.h"
#import "Alerts.h"
#import "Labels.h"
#import <Foundation/Foundation.h>

@interface WebViewController : SectionParentViewController<UIWebViewDelegate>

@property (assign, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSURL *lastRequest;
@property (strong, nonatomic) UIWebView *webview;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

- (void)loadFile:(NSString*)name;
- (IBAction)popView:(id)sender;

// webview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView;
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webViewDidFinishLoad:(UIWebView *)webView;

@end
