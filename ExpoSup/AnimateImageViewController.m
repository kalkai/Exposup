//
//  AnimateImageViewController.m
//  ExpoSup
//
//  Created by Aurélien Lebeau on 28/07/13.
//
//

#import "AnimateImageViewController.h"


@implementation AnimateImageViewController

@synthesize parser, standID, animationView,  startButton, currentWidth, titleScreen, comment, tempHeight;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    [self removeSubviews];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        currentWidth = 1024;
        [self createBody];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        currentWidth = 768;
        [self createBody];
    }

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    parser = [[XMLAnimateImageParser alloc] init];
    [parser parseXMLFileAtPath: standID];
    
}
- (void)createBody {
    tempHeight = 0;
    if(![parser.title isEqualToString:@"notitle"])
        tempHeight += [self addTitle];
    
    if(tempHeight<100)
        tempHeight=100;
    
    tempHeight += [self addAnimation];
    tempHeight += [self addAnimateButton];
    
    if(![parser.comment isEqualToString:@"nocomment"])
        tempHeight += [self addComment];
    
    if(currentWidth == 1024)
        [parser.audioFile addAudioToView: self.view atY: 768-60 width: currentWidth startDelayed: NO parent:self];
    else if(currentWidth == 768)
        [parser.audioFile addAudioToView: self.view atY: 1024-60 width: currentWidth startDelayed: NO parent:self];
}

- (int)addAnimation {
    NSMutableArray* images = [[NSMutableArray alloc] init];
    UIImage *toAdd;
    for(int i=0; i < parser.images.count; ++i) {
        toAdd = [UIImage imageWithContentsOfFile: [[LanguageManagement instance] pathForFile:[[parser images]objectAtIndex: i] contentFile: NO]];
        [images addObject: toAdd];
    }
    
    animationView = [[UIImageView alloc] init];
    animationView.image = [images objectAtIndex:0];
    animationView.contentMode = UIViewContentModeScaleAspectFit;
    animationView.animationImages = images;
    animationView.animationDuration = [[parser duration] doubleValue];
    
    
    [self.view addSubview: animationView];
    
    if(currentWidth==768) {
        animationView.frame = CGRectMake(5, tempHeight+10, currentWidth-5, 600);
        return 610;
    }
    else if(currentWidth==1024) {
        animationView.frame = CGRectMake(5, tempHeight+10, currentWidth-5, 400);
        return 410;
    }
    
    return tempHeight;
}

- (int)addAnimateButton {
    startButton = [ColorButton getButton];
    startButton.frame = CGRectMake(currentWidth/2-120/2, tempHeight+20, 120, 50);
    
    if(((parser.autostart == false || parser.repetition == false) || (parser.autostart == true && parser.repetition == false)) && parser.images.count > 1) {
        animationView.animationRepeatCount = 1;
        [startButton addTarget:self action:@selector(startAnimating:) forControlEvents:UIControlEventTouchUpInside];
        [startButton setTitle:[[Labels instance] animateButton] forState: UIControlStateNormal];
        [self.view addSubview: startButton];
        if(parser.autostart == true)
            [animationView startAnimating];
        if(parser.repetition == true)
            animationView.animationRepeatCount = 0;
        
    }
    else  {
        animationView.animationRepeatCount = 0;
        [animationView startAnimating];
        [startButton removeFromSuperview];
    }
    return 50+20;
}

- (int)addTitle  {
    int originY = 50;
    CGSize available = CGSizeMake(currentWidth - 150, 9999);
    titleScreen = [[UILabel alloc] init];
    titleScreen.font = [[Config instance] bigFont];
    titleScreen.frame = CGRectMake(0, 0, currentWidth - 150, 100);;
    titleScreen.backgroundColor = [UIColor clearColor];
    titleScreen.textColor = [[Config instance] color1];
    titleScreen.text = [parser title];
    titleScreen.numberOfLines = 0;
    CGSize sizedToFit = [titleScreen sizeThatFits: available];
    
    
    titleScreen.frame = CGRectMake(currentWidth / 2 - sizedToFit.width/2, originY, sizedToFit.width, sizedToFit.height);
    [self.view addSubview: titleScreen];
    return originY + sizedToFit.height;
}

- (int)addComment {
    CGRect frame;
    if(currentWidth == 768)
        frame = CGRectMake(5, tempHeight+10, currentWidth-10, 140);
    else if(currentWidth == 1024)
        frame = CGRectMake(5, tempHeight+10, currentWidth-10, 100);
        
    comment = [[UITextView alloc] initWithFrame: frame];
    
    comment.textColor = [[Config instance] color1];
    comment.font = [[Config instance] smallFont];
    comment.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:[[Config instance] opacity]];
    comment.editable = NO;
    comment.text = [parser comment];
    comment.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [comment sizeToFit];
    
    if(comment.frame.size.height > frame.size.height) {
        comment.frame = frame;
    }
    else {
        comment.frame = CGRectMake(frame.origin.x, (frame.origin.y + frame.size.height) - comment.frame.size.height, frame.size.width, comment.frame.size.height);
    }
    [self.view addSubview: comment];
    return comment.frame.size.height;
}

- (void)setBodyForWidth:(int)width {
    if(width==768) {
        animationView.frame = CGRectMake(5, 100, width-10, 600);
        startButton.frame = CGRectMake(width/2-50/2, 720, 120, 50);
    }
    else if(width==1024) {
        animationView.frame = CGRectMake(5, 100, width-10, 400);
         startButton.frame = CGRectMake(width/2-50/2, 520, 120, 50);
    }
}

- (IBAction)startAnimating:(id)sender {
    [animationView startAnimating];
    if(parser.autostart == false && parser.repetition == true) {
        [startButton removeFromSuperview];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)removeSubviews {
    UIView *view;
    for(view in [self.view subviews]) {
        if(view.tag != 999) {
            [view removeFromSuperview];
        }
    }
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
    
    [self removeSubviews];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        currentWidth = 1024;
        [self createBody];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        currentWidth = 768;
        [self createBody]; 
    }
}

@end
