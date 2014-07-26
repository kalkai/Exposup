//
//  RotateViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 3/04/13.
//
//

#import "RotateViewController.h"

@interface RotateViewController ()

@end

@implementation RotateViewController

@synthesize previousOrientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    previousOrientation = toInterfaceOrientation;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //[self setBackgroundImage: [[Config instance] backgroundLandscape]];
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage: [UIImage imageWithContentsOfFile: [[Config instance] backgroundLandscape]]];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //[self setBackgroundImage: [[Config instance] backgroundPortrait]];
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage: [UIImage imageWithContentsOfFile: [[Config instance] backgroundPortrait]]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    previousOrientation = toInterfaceOrientation;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        //[self setBackgroundImage: [[Config instance] backgroundLandscape]];
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage: [UIImage imageWithContentsOfFile: [[Config instance] backgroundLandscape]]];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        //[self setBackgroundImage: [[Config instance] backgroundPortrait]];
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage: [UIImage imageWithContentsOfFile: [[Config instance] backgroundPortrait]]];
    }
    
    previousOrientation = [[UIApplication sharedApplication] statusBarOrientation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundImage:(NSString*)backFile {
    if([self.navigationController.view viewWithTag: 1999])
        [[self.navigationController.view viewWithTag: 1999] removeFromSuperview];
    UIImageView *myBack = [[UIImageView alloc] initWithImage: [UIImage imageWithContentsOfFile: backFile]];
    [self.navigationController.view addSubview: myBack];
    myBack.tag = 1999;
    [self.navigationController.view sendSubviewToBack: myBack];
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"tointerfaceorientation %d", toInterfaceOrientation);
    previousOrientation = toInterfaceOrientation;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage: [UIImage imageWithContentsOfFile: [[Config instance] backgroundLandscape]]];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.view.backgroundColor = [[UIColor alloc] initWithPatternImage: [UIImage imageWithContentsOfFile: [[Config instance] backgroundPortrait]]];
    }
}


@end
