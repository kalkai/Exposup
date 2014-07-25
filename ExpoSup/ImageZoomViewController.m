//
//  ImageZoomViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 10/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "ImageZoomViewController.h"



@implementation ImageZoomViewController

@synthesize parser, imageView, scrollView, clickingFrames, tapGr, popover, currentScale, title, opacity;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    [self deletePopups];
    [parser.audio deleteFromView];
    
    scrollView.zoomScale = 1.0;
    if( [popover isPopoverVisible]) {
        [popover dismissPopoverAnimated: YES];
    }
    
    CGRect frame;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        frame = CGRectMake(0, 0, 1024, 570);
        scrollView.frame = frame;
        [parser.audio addAudioToView: self.view atY: 700 width: 1024 startDelayed: NO parent:self];
        imageView.frame = frame;
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        frame = CGRectMake(0, 0, 768, 900);
        scrollView.frame = frame;
        [parser.audio addAudioToView: self.view atY: 960 width: 768 startDelayed: NO parent:self];
        imageView.frame = frame;
    }
    scrollView.contentSize = frame.size;
    
    [self createPopups];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


- (void)addTitle {
    title.font = [[Config instance] normalFont];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [[Config instance] color1];
    title.text = parser.title;
    NSLog(@"title %@", parser.title);
    [title sizeToFit];
    title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width, title.frame.size.height);
    [self.view addSubview: title];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currentScale = 1.0;
    [self addGesture];
    //self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:[[Config instance] opacity]];
    parser = [[XMLZoomParser alloc] init];
    [parser parseXMLFileAtPath: self.fileName];
    
 
    if(parser.imagePath != nil) {
    
        //CGRect frame = CGRectMake(0, 0, 768, 600);
        [self addTitle];
        
        //scrollView = [[UIScrollView alloc] init];
        scrollView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha: 0];
        scrollView.scrollEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = YES;
        scrollView.minimumZoomScale = 1.0;
        scrollView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView setAutoresizesSubviews: YES];
        [scrollView setBouncesZoom:YES];
        scrollView.userInteractionEnabled = YES;
        scrollView.autoresizesSubviews = YES;
        scrollView.clipsToBounds = YES;
        scrollView.canCancelContentTouches = YES;
        scrollView.delaysContentTouches = YES;
        
        scrollView.tag = -1;
        scrollView.delegate = self;
        //scrollView.contentSize = frame.size;
        scrollView.scrollEnabled = YES;
        //scrollView.frame = frame;
        scrollView.multipleTouchEnabled = YES;
        
        
        imageView = [[UIImageView alloc] initWithFrame: scrollView.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image =  [UIImage imageWithContentsOfFile: [[LanguageManagement instance] pathForFile: parser.imagePath contentFile: NO]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = -2;
        
        
        [scrollView addSubview: imageView];
        [self.view addSubview: scrollView];
        
    }
}


- (CGFloat)getScale {
    CGFloat widthScale = self.view.frame.size.width / imageView.image.size.width;
    CGFloat heightScale = self.view.frame.size.height / imageView.image.size.height;

    return MIN(widthScale, heightScale);
}

//utile pour connaitre la nouvelle frame de l'image mise à l'échelle
- (CGRect)frameForImage:(UIImage*)image inViewAspectFit:(UIImageView*)view {
    float imageRatio = image.size.width / image.size.height;
    float viewRatio = view.frame.size.width / view.frame.size.height;
    scrollView.maximumZoomScale = 3 / [self getScale];
    
    if(imageRatio < viewRatio) {
        float scale = view.frame.size.height / image.size.height;
        float width = scale * image.size.width;
        float topLeftX = (view.frame.size.width - width) * 0.5;
        return CGRectMake(topLeftX, 0, width, view.frame.size.height);
    }
    else {
        float scale = view.frame.size.width / image.size.width;
        float height = scale * image.size.height;
        float topLeftY = (view.frame.size.height - height) * 0.5;
        return CGRectMake(0, topLeftY, view.frame.size.width, height);
    }
}

- (void)createPopups {
    clickingFrames = [[NSMutableArray alloc] init];
    CGRect newFrame = [self frameForImage: imageView.image inViewAspectFit: imageView];
    float scale = newFrame.size.width / imageView.image.size.width;
    int centerHeight = scrollView.frame.size.height/2;
    int centerWidth = scrollView.frame.size.width/2;
    int topOfImage = centerHeight - newFrame.size.height/2;
    int leftOfImage = centerWidth - newFrame.size.width/2;

    for(int i=0; i < parser.popupContent.count; ++i) {
        // upperLeft et bottomRight :  i = x    i+1 = y
        
        int x1 = leftOfImage + [[parser.upperLeft objectAtIndex: (i*2)] intValue] * scale;
        int y1 = topOfImage + [[parser.upperLeft objectAtIndex: (i*2)+1] intValue] * scale;
        int x2 = leftOfImage + [[parser.bottomRight objectAtIndex: (i*2)] intValue] * scale;
        int y2 = topOfImage + [[parser.bottomRight objectAtIndex: (i*2)+1] intValue] * scale;
        NSLog(@"x1 %d x2 %d  y1 %d  y2 %d", x1, x2, y1, y2);
        
        CGRect frame = CGRectMake(x1, y1, x2-x1, y2-y1);
        UIView *view = [[UIView alloc] initWithFrame: frame];
        view.backgroundColor = [[Config instance] color6];
        
        [imageView addSubview: view];
        [clickingFrames addObject: [NSValue valueWithCGRect: frame]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    currentScale = scale;
    NSLog(@"scale = %f", scale);
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)addGesture {
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touches:)];
    [tapGr setNumberOfTapsRequired:1];
    [scrollView addGestureRecognizer:tapGr];
}


- (IBAction)touches:(id)sender {
    NSLog(@"touche tap x: %f", [tapGr locationInView: scrollView].x );
    NSLog(@"touche tap y: %f", [tapGr locationInView: scrollView].y );
    for(int i=0; i < clickingFrames.count; ++i) {
        CGRect tempRect = [[clickingFrames objectAtIndex: i] CGRectValue];
        CGRect scaleRect = CGRectMake(tempRect.origin.x * currentScale, tempRect.origin.y * currentScale , tempRect.size.width * currentScale, tempRect.size.height * currentScale);
        if(CGRectContainsPoint(scaleRect, [tapGr locationInView: scrollView])) {
            NSLog(@"touche tap x: %f", [tapGr locationInView: scrollView].x);
            NSLog(@"touche tap y: %f", [tapGr locationInView: scrollView].y);
            
            if( [popover isPopoverVisible]) {
                [popover dismissPopoverAnimated: YES];
            }
            else {
                [self showPopup:scaleRect atIndex: i];
                
            }
        }
    }
    
}

- (void)showPopup:(CGRect)rect atIndex:(int)idx{
    UIViewController *popup = [[UIViewController alloc] init];
    popup.view.backgroundColor = [UIColor clearColor];
    
    UITextView *tv = [[UITextView alloc] init];
    tv.editable = NO;
    tv.scrollEnabled = NO;
    tv.text = [parser.popupContent objectAtIndex: idx];
    tv.backgroundColor = [[Config instance] color2];
    tv.font = [[Config instance] smallFont];
    tv.textColor = [[Config instance] color1];
    tv.frame = CGRectMake(0, 0, 350, 250);
    NSLog(@"height %f", tv.contentSize.height);
    CGRect newFrame = CGRectMake(tv.frame.origin.x, tv.frame.origin.y, tv.frame.size.width, tv.contentSize.height);
    tv.frame = newFrame;
    
    
    
    [popup.view addSubview: tv];
    popover = [[UIPopoverController alloc] initWithContentViewController: popup];
    
    popover.popoverContentSize = tv.frame.size;
    [popover presentPopoverFromRect: rect
                             inView: scrollView
           permittedArrowDirections: UIPopoverArrowDirectionAny
                           animated: YES];
}


- (void)deletePopups {
    UIView *view;
    for(view in [imageView subviews]) {
        [view removeFromSuperview];
    }
}



- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self deletePopups];
    [parser.audio deleteFromView];
    
    scrollView.zoomScale = 1.0;
    currentScale = 1.0;
    if( [popover isPopoverVisible]) {
        [popover dismissPopoverAnimated: YES];
    }
    
    CGRect frame;
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        frame = CGRectMake(0, 0, 1024, 570);
        opacity.frame = CGRectMake(0, 0, 1024, 768);
        scrollView.frame = frame;
        [parser.audio addAudioToView: self.view atY: 700 width: 1024 startDelayed: NO parent:self];
        imageView.frame = frame;
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        frame = CGRectMake(0, 0, 768, 829);
        opacity.frame = CGRectMake(0, 0, 768, 1024);
        scrollView.frame = frame;
        [parser.audio addAudioToView: self.view atY: 960 width: 768 startDelayed: NO parent:self];
        imageView.frame = frame;
    }
    scrollView.contentSize = frame.size;
    [self createPopups];
}


@end
