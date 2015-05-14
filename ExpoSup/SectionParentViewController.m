//
//  SectionViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 25/03/13.
//
//

#import "SectionParentViewController.h"
#import "SectionViewController.h"

@interface SectionParentViewController ()

@end

@implementation SectionParentViewController

@synthesize scanButton,returnButton, showReturn, swipeArea, gesture, volumeLabel, animationView, volumeViewSlider, isPageWithAudio, numberOfPagesToPop, navController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    returnButton = [ColorButton getButton];
    showReturn = YES;
    isPageWithAudio = NO;
    numberOfPagesToPop = [NSNumber numberWithInt: 1];

}

- (void)viewWillAppear:(BOOL)animated {
    //[self setPageWithAudio];
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        returnButton.frame = CGRectMake(1024-90, 15, 80 , 50);
        //swipeArea.frame = CGRectMake(1024/2 - swipeArea.frame.size.width/2, 5, swipeArea.frame.size.width, swipeArea.frame.size.height);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        returnButton.frame = CGRectMake(768-90, 15, 80 , 50);
        //swipeArea.frame = CGRectMake(768/2 - swipeArea.frame.size.width/2, 5, swipeArea.frame.size.width, swipeArea.frame.size.height);
    }
    //[self addArrowToView: swipeArea];
    //volumeViewSlider.frame = CGRectMake(swipeArea.frame.origin.x, -swipeArea.frame.size.height , swipeArea.frame.size.width, swipeArea.frame.size.height);
    [self createBackButtons];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createBackButtons {
    [returnButton removeFromSuperview];
    [scanButton removeFromSuperview];
    scanButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    scanButton.frame = CGRectMake(5, 5, 85, 85);
    
    [scanButton setBackgroundImage: [UIImage imageWithContentsOfFile: [[Config instance]backButtonToScan]] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(popToScanView:) forControlEvents:UIControlEventTouchUpInside];
    scanButton.tag = 999;
    [self.view addSubview:scanButton];
    
    if(showReturn) {
        [returnButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
        [returnButton setTitle: [[Labels instance] backButtonLabel] forState: UIControlStateNormal];
            returnButton.tag = 999;
        [self.view addSubview: returnButton];
    }
    
    
}


- (UIView*)createBackToScanButton {
    UIButton *button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    button.frame = CGRectMake(5, 5, 85, 85);
    
    [button setBackgroundImage: [UIImage imageWithContentsOfFile: [[Config instance]backButtonToScan]] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popToScanView:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (IBAction)popView:(id)sender {
   
    int previousIndex = [self.navigationController viewControllers].count - 2; // -1 is current index

    if( ((UIViewController*)[[self.navigationController viewControllers] objectAtIndex:previousIndex]).class == [SectionViewController class]) {
        SectionViewController *tmpSection = (SectionViewController*)[[self.navigationController viewControllers] objectAtIndex:previousIndex];
        if([tmpSection.numberOfPagesToPop intValue] == 2) {
            [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:previousIndex - 1] animated:YES];
        
            return;
        }
    }

    
    [self.navigationController popViewControllerAnimated:YES]; // Retour sur la page de section

    
}

- (IBAction)popToScanView:(id)sender {
    int indexOfScanPage = 2;
    if(![[Config instance] showChildMode] && ![[Config instance] showGuideMode]) {
        indexOfScanPage = 1;
    }
    
    [[[self.navigationController viewControllers] objectAtIndex: indexOfScanPage] viewDidLoad];
    [[[self.navigationController viewControllers] objectAtIndex: indexOfScanPage] viewWillAppear:YES];
    [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex: indexOfScanPage] animated:YES];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        returnButton.frame = CGRectMake(1024-90, 15, 80 , 50);
        //swipeArea.frame = CGRectMake(1024/2 - swipeArea.frame.size.width/2, 0, swipeArea.frame.size.width, swipeArea.frame.size.height);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        returnButton.frame = CGRectMake(768-90, 15, 80 , 50);
        //swipeArea.frame = CGRectMake(768/2 - swipeArea.frame.size.width/2, 0, swipeArea.frame.size.width, swipeArea.frame.size.height);
    }
    //[self addArrowToView: swipeArea];
    //volumeViewSlider.frame = CGRectMake(swipeArea.frame.origin.x, -swipeArea.frame.size.height , swipeArea.frame.size.width, swipeArea.frame.size.height);
}
/*
-(void)swipe:(UISwipeGestureRecognizer*)gesture {
    [self showVolumeView: self];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(hideVolumeView:) userInfo:nil repeats:NO];
}

-(void)showVolumeView:(id)sender {
    //volumeViewSlider.frame = CGRectMake(swipeArea.frame.origin.x, -swipeArea.frame.size.height , swipeArea.frame.size.width, swipeArea.frame.size.height);

    [UIView animateWithDuration:  0.4
                     animations:^{
                         volumeViewSlider.frame = CGRectMake(swipeArea.frame.origin.x, swipeArea.frame.origin.y + 20, swipeArea.frame.size.width, swipeArea.frame.size.height);
                     }
    ];
    
    animationView.hidden = YES;
    volumeLabel.hidden = YES;
}

-(void)hideVolumeView:(id)sender {
    [UIView animateWithDuration:  0.4
                     animations:^{
                         volumeViewSlider.frame = CGRectMake(swipeArea.frame.origin.x, -swipeArea.frame.size.height, swipeArea.frame.size.width, swipeArea.frame.size.height);
                     }
     ];
    
    animationView.hidden = NO;
    volumeLabel.hidden = NO;
}
*/

@end
