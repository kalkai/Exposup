//
//  WebViewController.m
//  exposup
//
//  Created by Aurélien Lebeau on 15/12/15.
//
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webview, fileName, activityView, lastRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        webview.frame = CGRectMake(0,  0, 1024, 768);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        webview.frame = CGRectMake(0, 0, 768, 1024);
    }
    [super viewWillAppear:YES];
    [self loadFile: fileName];
}

- (void) viewWillDisappear:(BOOL)animated {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    webview = [[UIWebView alloc] init];
    [webview setBackgroundColor: [UIColor clearColor]];
    [webview setOpaque:NO];
    [webview setScalesPageToFit: YES];


    [webview setDelegate:self];
    [self.view addSubview: webview];
    
    [webview setAllowsInlineMediaPlayback:YES];
    self.webview.mediaPlaybackRequiresUserAction = NO;
    
}

- (void) loadFile: (NSString*)name {
    NSString *filePath = [[LanguageManagement instance] pathForFile: name contentFile: NO];
    NSURL *url = [NSURL URLWithString: filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    lastRequest = request.URL;
    [webview loadRequest: request];
    
    
    /*NSData *data = [NSData  dataWithContentsOfFile: filePath];
    
    if(data==nil) {
        NSLog(@"\n\n\n\n DATA IS NIL \n\n\n\n");
    }
    else {
        //Useful to set the base URL path
        NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *documentsURL = [paths lastObject];
        
        
        [webview loadData: data MIMEType:@"text/html" textEncodingName:@"UTF-8" baseURL: documentsURL];
    }*/
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    //The device has already rotated, that's why this method is being called.
    UIDeviceOrientation toOrientation   = [[UIDevice currentDevice] orientation];
    UIInterfaceOrientation toInterfaceOrientation;
    //fixes orientation mismatch (between UIDeviceOrientation and UIInterfaceOrientation)
    if (toOrientation == UIDeviceOrientationLandscapeRight)
        toInterfaceOrientation = UIInterfaceOrientationLandscapeLeft;
    else if (toOrientation == UIDeviceOrientationLandscapeLeft)
        toInterfaceOrientation = UIInterfaceOrientationLandscapeRight;
    else if (toOrientation == UIDeviceOrientationPortraitUpsideDown)
        toInterfaceOrientation = UIInterfaceOrientationPortraitUpsideDown;
    else toInterfaceOrientation = UIInterfaceOrientationPortrait;
    
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        webview.frame = CGRectMake(0,  0, 1024, 768);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        webview.frame = CGRectMake(0, 0, 768, 1024);
    }
}

- (IBAction)popView:(id)sender {
    NSLog(@"WebViewController popview.");
    if([webview canGoBack])
        [webview goBack];
    else
        [super popView:sender];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Webview did start load.");
    activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"Webview should start load with request. \nRequest : %@\nNavigationType : %ld",request, (long)navigationType);
    
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        [webview stopLoading];

        NSString *URLConstruction = [[NSString alloc] init];
        URLConstruction = request.URL.lastPathComponent;
        NSLog(@"URLConstruction : %@", URLConstruction);
        [self loadFile: URLConstruction];
        return false;
    }
    else return true;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Webview loading error: %@", [error debugDescription]);
    if(error.code == 204) {
        // Problem to load video. Just ignore this issue.
        [self webViewDidFinishLoad:webView];
    } else if (error.code == -1100) {
        // File not found
        UIAlertController *alert = [Alerts getWebNotFoundAlert: lastRequest.lastPathComponent];
        [self presentViewController:alert animated:YES completion:nil];
        [activityView stopAnimating];
        [activityView removeFromSuperview];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Webview did finish load.");
    [activityView stopAnimating];
    [activityView removeFromSuperview];
    
    [webview setScalesPageToFit: YES];
}

@end
