//
//  SlideshowViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 5/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SlideshowViewController.h"

@implementation SlideshowViewController

@synthesize scrollView, portraitImageFrame, landscapeImageFrame, currentImageFrame,portraitAudioOffset,landscapeAudioOffset, currentAudioOffset, landscapeCommentFrame, portraitCommentFrame, currentCommentFrame, currentAudio, portraitFrame, landscapeFrame, sectionTitle;
@synthesize standID;
@synthesize parser;

@synthesize pageControl;
@synthesize currentID;




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
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)addPageControlDotsInFrame:(CGRect)frame Yoffset:(int)y{
    pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = parser.nSlides;
    pageControl.currentPage = 0;
    pageControl.frame = CGRectMake(frame.size.width/2 - pageControl.frame.size.width/2, y, pageControl.frame.size.width, pageControl.frame.size.height);
    pageControl.pageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview: pageControl];
    [self.view bringSubviewToFront: pageControl];
}


- (void)viewWillAppear:(BOOL)animated {
   
    if(parser.nSlides != -1) {
        UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            [self createViewsForLandscape];
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            [self createViewsForPortrait];
        }
    } 
    [super viewWillAppear:YES];
}

- (void)viewDidLoad
{
    parser = [[XMLSlideshowParser alloc] init];
    [parser parseXMLFileAtPath: standID];
    
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setPagingEnabled:YES];
    
    portraitFrame = CGRectMake(0, 0, 768, 900);
    landscapeFrame = CGRectMake(0, 0, 1024, 644);
    
    portraitImageFrame = CGRectMake(0, 0,768,600);
    landscapeImageFrame = CGRectMake(0, 0, 1024, 490);
    currentImageFrame = portraitImageFrame;
    
    portraitCommentFrame = CGRectMake(15,650,738,180);
    landscapeCommentFrame = CGRectMake(15, 500, 994, 130);
    currentCommentFrame = portraitCommentFrame;
    
    portraitAudioOffset = 900;
    landscapeAudioOffset = 650;
    currentAudioOffset = 900;
    [super viewDidLoad];
}

- (void)addArrowsToView:(UIView*)view forID:(int)order {
    //UIImageView *iv;
   
    if(order != 0) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setImage: [UIImage imageNamed: @"leftArrow.png"] forState: UIControlStateNormal];
        button.frame = CGRectMake(2, 350, 50, 100);
        [button addTarget: self action: @selector(goToPrevious:) forControlEvents:UIControlEventTouchUpInside];
        //iv = [[UIImageView alloc] initWithImage: ];
        //iv.frame = CGRectMake(2, 350, 50, 100);
        //[view addSubview:iv];
        [view addSubview: button];
        NSLog(@"Add image button");
    }
    if(order != parser.nSlides-1) {
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setImage: [UIImage imageNamed: @"rightArrow.png"] forState: UIControlStateNormal];
        button.frame = CGRectMake(scrollView.frame.size.width-55, 350, 50, 100);
        [button addTarget: self action: @selector(goToNext:) forControlEvents:UIControlEventTouchUpInside];
        //iv = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"rightArrow.png"]];
        //iv.frame = CGRectMake(scrollView.frame.size.width-55, 350, 50, 100);
        //[view addSubview:iv];
        [view addSubview: button];
        NSLog(@"Add image button");
    }
}

- (void)goToPrevious:(id)sender {
    [self slideWindowUpdate: scrollView];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * (currentID - 1);
    frame.origin.y = 0;
    currentID = currentID - 1;
    currentAudio = [parser.audios objectAtIndex: currentID];
    pageControl.currentPage = currentID;
    [scrollView scrollRectToVisible: frame animated: YES];
}

- (void)goToNext:(id)sender {
    [self slideWindowUpdate: scrollView];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * (currentID + 1);
    frame.origin.y = 0;
    currentID = currentID + 1;
    currentAudio = [parser.audios objectAtIndex: currentID];
    pageControl.currentPage = currentID;
    [scrollView scrollRectToVisible: frame animated: YES];
}



- (void)addImage: (NSString *) imagePath toView: (UIView *) view withFrame:(CGRect)frame {

    
    UIScrollView *zoomView = [[UIScrollView alloc] initWithFrame: frame];
    zoomView.delegate = self;
    zoomView.minimumZoomScale = 1.0;
    zoomView.maximumZoomScale = 5.0;
    zoomView.userInteractionEnabled = YES;
    zoomView.scrollEnabled = YES;
    zoomView.tag = -1;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image =  [UIImage imageWithContentsOfFile: [[LanguageManagement instance] pathForFile: imagePath contentFile: NO]];
    imageView.userInteractionEnabled = YES;
    imageView.tag = -2;
    zoomView.contentSize = frame.size;
    
    [zoomView addSubview: imageView];
    [view addSubview: zoomView];
}

- (CGRect)addComment: (NSString *) comment toView: (UIView *) view withFrame:(CGRect)frame {
    UITextView  *commentView = [[UITextView alloc] initWithFrame: frame];
    
    commentView.textColor = [[Config instance] color1];
    commentView.font = [[Config instance] smallFont];
    commentView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:[[Config instance] opacity]];
    commentView.editable = NO;
    commentView.text = comment;
    commentView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    [commentView sizeToFit];
    
    if(commentView.frame.size.height > frame.size.height) {
        commentView.frame = frame;
    }
    else {
        commentView.frame = CGRectMake(frame.origin.x, (frame.origin.y + frame.size.height) - commentView.frame.size.height, frame.size.width, commentView.frame.size.height);
    }
    [view addSubview: commentView];
    return commentView.frame;
}

- (int)addTitle:(NSString*) title {
    int originY = 50;
    CGSize available = CGSizeMake(scrollView.frame.size.width - 150, 9999);
    sectionTitle = [[UILabel alloc] init];
    sectionTitle.font = [[Config instance] bigFont];
    sectionTitle.frame = CGRectMake(0, 0, scrollView.frame.size.width - 150, 100);;
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.textColor = [[Config instance] color1];
    sectionTitle.text = title;
    sectionTitle.numberOfLines = 0;
    CGSize sizedToFit = [sectionTitle sizeThatFits: available];
    
    
    sectionTitle.frame = CGRectMake( scrollView.frame.size.width / 2 - sizedToFit.width/2, originY, sizedToFit.width, sizedToFit.height);
    //sectionTitle.frame = CGRectMake(self.view.frame.size.width/2 - sectionTitle.frame.size.width/2, 30, sectionTitle.frame.size.width, sectionTitle.frame.size.height);
    [self.view addSubview: sectionTitle];
    return originY + sizedToFit.height;
}



- (CGRect)createFrameFromPoint:(int)x {
    CGRect frame;
    frame.origin.x = x;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    return frame;
}




- (void)slideWindowUpdate:(UIScrollView *)sView {
    NSLog(@"decelerating offset x: %f", sView.contentOffset.x);
    int pageOffset = sView.contentOffset.x / scrollView.frame.size.width;
    //[self stopButtonClicked:self];
    currentID = pageOffset;
    pageControl.currentPage = currentID;
    [self stopCurrentAudio];
    currentAudio = [parser.audios objectAtIndex: currentID];
    [currentAudio canStart];
    for(int page = fmax(0,(pageOffset - 1)) ; page <= fmin((pageOffset+1),parser.nSlides-1); ++page) {
        
        //NSLog(@"in for: pageOffset = %d, page = %d", pageOffset,page);
        if (![scrollView viewWithTag: page] ) {
            NSLog(@"creating page = %d", page);
            [self createFrameView: page orientation: @""];
        }
    }
    NSLog(@"Page offset %d",pageOffset);
    for(UIView *subview in [scrollView subviews]) {
        if(subview.tag != 0 && (subview.tag < pageOffset - 1 || subview.tag > pageOffset + 1)) {
            [subview removeFromSuperview];
            NSLog(@"remove view %d", subview.tag);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sView {
    if(sView == self.scrollView) {
        [self slideWindowUpdate: sView];
    }
    
}


- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)view {
    NSLog(@"viewForZoomin current id : %d", currentID);
    return [[[scrollView viewWithTag: currentID] viewWithTag: -1] viewWithTag: -2];
}


- (void)createFrameView:(int)num orientation:(NSString*) orientation{
    NSLog(@"CREATION OF FRAME %d", num);
    int width;
    int height;
    CGRect currentMaxImageFrame, imageFrame;
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    // Forcé de mettre un deuxième systeme de vérification de l'orientation. Un seul ne suffisait pas, comme s'il n'avait pas encore fini sa rotation avant de faire cette fonction
    if([orientation isEqualToString:@"landscape"] || ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) && ![orientation isEqualToString:@"portrait"])) {
        width = 1024;
        height = 600;
        currentMaxImageFrame = landscapeFrame;
        NSLog(@"LANDSCAPE");
    }
    else if ([orientation isEqualToString:@"portrait"] || ((toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) && ![orientation isEqualToString:@"landscape"])) {
        width = 768;
        height = 850;
        currentMaxImageFrame = portraitFrame;
        NSLog(@"PORTRAIT");
    }
    
    UIView *view;
    view = [[UIView alloc] initWithFrame: [self createFrameFromPoint: num*scrollView.frame.size.width]];
    view.tag = num;
    Boolean audio = NO;
    Boolean comment = NO;
    
    // On vérifie s'il y a un commentaire et une musique pour savoir comment placer les vues
    if(num < parser.audios.count)
        if([parser.audios objectAtIndex: num] != nil && ![[parser.audios objectAtIndex: num] isEqual:[[AudioViewController alloc] init]] )
            audio = [[parser.audios objectAtIndex: num] addAudioToView: view atY: height width: width startDelayed: YES parent:self];
    
    if(![[parser.comments objectAtIndex: num] isEqualToString:@""])
        comment = YES;
    
    CGRect commentFrame;
    if(comment) {
        if(audio) {
            commentFrame = CGRectMake(currentCommentFrame.origin.x, currentMaxImageFrame.origin.y + currentMaxImageFrame.size.height - 70 - currentCommentFrame.size.height, currentCommentFrame.size.width, currentCommentFrame.size.height);
        }
        else {
            commentFrame = CGRectMake(currentCommentFrame.origin.x, currentMaxImageFrame.origin.y + currentMaxImageFrame.size.height - 10 - currentCommentFrame.size.height, currentCommentFrame.size.width, currentCommentFrame.size.height);
        }
        commentFrame = [self addComment: [parser.comments objectAtIndex: num] toView: view withFrame: commentFrame];
    }
    
    
    NSLog( audio ? @"Audio" : @"Pas d'audio");
    NSLog( comment ? @"Comment" : @"Pas de comment");
    if(!comment && !audio) {
        imageFrame = CGRectMake(currentMaxImageFrame.origin.x, currentMaxImageFrame.origin.y, currentMaxImageFrame.size.width, currentMaxImageFrame.size.height-20);
    } else if(!audio) { // il y a juste un commentaire
        imageFrame = CGRectMake(currentMaxImageFrame.origin.x, currentMaxImageFrame.origin.y, currentMaxImageFrame.size.width, currentMaxImageFrame.size.height - commentFrame.size.height - 50);
    } else if(!comment) { // il y a juste de l'audio
        imageFrame = CGRectMake(currentMaxImageFrame.origin.x, currentMaxImageFrame.origin.y, currentMaxImageFrame.size.width, currentMaxImageFrame.size.height - 90);
    } else if (comment && audio) {
        imageFrame = CGRectMake(currentMaxImageFrame.origin.x, currentMaxImageFrame.origin.y, currentMaxImageFrame.size.width, currentMaxImageFrame.size.height - commentFrame.size.height - 100);
    }
    
    [self addImage: [parser.images objectAtIndex: num] toView: view withFrame: imageFrame];
    [self addArrowsToView: view forID: num];
   


    
    [scrollView addSubview: view];
}


- (void)stopCurrentAudio {
    if(currentAudio != nil && ![currentAudio isEqual:[[AudioViewController alloc] init]] ) {
        [currentAudio stopButtonClicked:self];
    }
}

- (void)createViewsForPortrait {
    scrollView = [[UIScrollView alloc] init];
    
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:(CGSizeMake( parser.nSlides  * 768 , 900))];

    scrollView.frame = CGRectMake(0, 124, 768, 900);
    
    [self addTitle: [parser title]];
    
    currentImageFrame = portraitImageFrame;
    currentCommentFrame = portraitCommentFrame;
    currentAudioOffset = portraitAudioOffset;
    
    
    [self createFrameView: 0 orientation:@"portrait"];
    currentAudio = [parser.audios objectAtIndex: 0];
    [currentAudio canStart];
    if(parser.nSlides > 1)
        [self createFrameView: 1 orientation:@"portrait"];
    
    
    [self.view addSubview: scrollView];
    [self createBackButtons];
}

- (void)createViewsForLandscape {
    scrollView = [[UIScrollView alloc] init];
    
    scrollView.delegate = self;
    [scrollView setScrollEnabled:YES];
    [scrollView setPagingEnabled:YES];
    [scrollView setContentSize:(CGSizeMake( parser.nSlides  * 1024 , 644))];
    
    
    scrollView.frame = CGRectMake(0, 124, 1024, 644);
    
    [self addTitle: [parser title]];
    
    currentImageFrame = landscapeImageFrame;
    currentCommentFrame = landscapeCommentFrame;
    currentAudioOffset = landscapeAudioOffset;
    
    [self createFrameView: 0 orientation:@"landscape"];
    currentAudio = [parser.audios objectAtIndex: 0];
    [currentAudio canStart];
    if(parser.nSlides > 1)
        [self createFrameView: 1 orientation:@"landscape"];
    
    [self.view addSubview: scrollView];
    [self createBackButtons];

}

- (void)deleteSubviews {
    UIView *view;
    for(view in [scrollView subviews]) {
        if(view.tag != 999) {
            [view removeFromSuperview];
        }
    }
    [sectionTitle removeFromSuperview];
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
    
    [self deleteSubviews];
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [self createViewsForLandscape];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [self createViewsForPortrait];
    }
    
}




@end
