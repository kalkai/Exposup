//
//  WebViewController.m
//  exposup
//
//  Created by Aurélien Lebeau on 15/12/15.
//
//

#import "WebViewController.h"

@implementation WebViewController

@synthesize webview, fileName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        webview.frame = CGRectMake(0, 100, 1024, 668);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        webview.frame = CGRectMake(0, 100, 768, 924);
    }
    [super viewWillAppear:YES];
   
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
    
    NSString *filePath = [[LanguageManagement instance] pathForFile: fileName contentFile: NO];
    NSData *data = [NSData  dataWithContentsOfFile: filePath];
    [webview loadData: data MIMEType:@"text/xml" textEncodingName:@"UTF-8" baseURL:[NSURL URLWithString:@""]];
    [webview setScalesPageToFit:false];

    
    
    [self.view addSubview: webview];
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
    
   // what to do
}

@end
