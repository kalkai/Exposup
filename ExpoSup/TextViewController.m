//
//  TextViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 4/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "TextViewController.h"

@implementation TextViewController

@synthesize standID, title, argument, buttonsList, parser,audioController, coordY, currentWidth, scrollView, tapGr, clickingFrames, commentToPopup, popover, views, buttonToParagraphIdx, isParagraphOpen, buttonToParagraphView, expandedParagraph, superiorLines, inferiorLines;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self deleteSubviewsFromView: self.view];
    
    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        currentWidth = 1024;
        [self createBodyWithWidth];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        currentWidth = 768;
        [self createBodyWithWidth];
    }
    [super viewWillAppear:YES];
    NSLog(@"end of view will appear");
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */



- (void)addTitle:(NSString*)text {
    title.font = [[Config instance] normalFont];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [[Config instance] color1];
    title.text = text;
    [title sizeToFit];
    title.frame = CGRectMake(currentWidth/2 - title.frame.size.width/2, 30, title.frame.size.width, title.frame.size.height);
    [self.view addSubview: title];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    scrollView = [[UIScrollView alloc] init];
    scrollView.scrollEnabled = YES;
    scrollView.bounces = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.multipleTouchEnabled = YES;
    [self.view addSubview: scrollView];
    scrollView.tag = 1000;
    scrollView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:[[Config instance] opacity] ];
    
    audioController = nil;
    
    parser = [[XMLTextParser alloc] init];
    [parser parseXMLFileAtPath: standID];
    NSLog(@"parse done.");
    
    [self addGesture];
    
    
    scrollView.scrollEnabled = YES;
    [super viewDidLoad];
}

-(void)createBodyWithWidth {
    Boolean audio = NO;
    int startY=100;
    if(parser.audio) {
        if(currentWidth == 768) {
            if([parser.currentAudio addAudioToView:self.view atY:1024-60 width:currentWidth startDelayed:NO parent:self]) {
                scrollView.frame = CGRectMake(0, startY, currentWidth, 1024-startY-70);
                audio = YES;
            }
        }
        else if([parser.currentAudio addAudioToView:self.view atY:768-60 width:currentWidth startDelayed:NO parent:self]) {
            scrollView.frame = CGRectMake(0, startY, currentWidth, 768-startY-70);
            audio = YES;
        }
    }
    if(!audio) {
        if(currentWidth == 768) 
            scrollView.frame = CGRectMake(0, startY, currentWidth, 1024);
        else
            scrollView.frame = CGRectMake(0, startY, currentWidth, 768);
    }
    
    scrollView.contentSize = scrollView.frame.size;
    
    [self addTitle: parser.title];
    
    clickingFrames = [[NSMutableArray alloc] init];
    commentToPopup = [[NSMutableArray alloc] init];
    
    buttonToParagraphIdx = [[NSMutableDictionary alloc] init];
    buttonToParagraphView = [[NSMutableDictionary alloc] init];
    expandedParagraph = [[NSMutableDictionary alloc] init];
    isParagraphOpen = [[NSMutableDictionary alloc] init];
    superiorLines = [[NSMutableDictionary alloc] init];
    inferiorLines = [[NSMutableDictionary alloc] init];
    views = [[NSMutableArray alloc] init];
    argument = [[NSMutableString alloc] init];
    buttonsList = [[NSMutableArray alloc] init];
    
    coordY = 20;   
    [self showAllContent];
}


-(void)showAllContent {

    int imageIdx = 0, citationIdx = 0, subtitleIdx = 0, paragraphIdx = 0;
    for(int i=0; i<parser.results.count; ++i) {
        NSString *obj = [parser.results objectAtIndex: i];
        if ([obj isEqualToString:@"image"]) {
            coordY += [self addImage: imageIdx];
            ++imageIdx;
        }
        else if ([obj isEqualToString:@"citation"]) {
            coordY += [self addCitation: citationIdx];
            ++citationIdx;
        }
        else if ([obj isEqualToString:@"subtitle"]) {
            coordY += [self addSubtitle: subtitleIdx];
            ++subtitleIdx;
        }
        else if ([obj isEqualToString:@"paragraph"]) {
            coordY += [self addText: paragraphIdx];
            ++paragraphIdx;
        }
    }
    scrollView.contentSize = CGSizeMake(currentWidth, coordY+100);
}

-(int)addText:(int)textIdx {
    if(![[parser.synopsis objectAtIndex: textIdx] isEqualToString: @"nosynopsis"]) {
        UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(25, coordY, currentWidth-45, 50)];
        textView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
        
        NSString *text =  [parser.synopsis objectAtIndex: textIdx];
        [textView setText: text];
        
        textView.font = [[Config instance] smallFont];
        textView.textColor = [[Config instance] color1];
        textView.textAlignment = NSTextAlignmentJustified;
        
        textView.userInteractionEnabled = NO;
        textView.scrollEnabled = NO;
        textView.editable = NO;
        
        CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
        CGRect newFrame = textView.frame;
        newFrame.size.height = textViewSize.height;
        textView.frame = newFrame;

        
        [scrollView addSubview: textView];
        [views addObject: textView];
        
        
        
        [self searchPopupsInView: textView];
        
        [buttonToParagraphIdx setObject: [NSNumber numberWithInt:textIdx] forKey: [NSNumber numberWithInt:views.count]];
        [isParagraphOpen setObject: [NSNumber numberWithBool: NO] forKey: [NSNumber numberWithInt: views.count]];
        
        UIButton *more = [ColorButton getButton];
        more.tag = views.count;
        
        [more setTitle: [[Labels instance] expandSynopsis] forState: UIControlStateNormal];
        [more addTarget:self action:@selector(expandParagraph:) forControlEvents:UIControlEventTouchUpInside];
        [more sizeToFit];
        more.frame = CGRectMake(currentWidth - 50 - more.frame.size.width, textView.frame.origin.y + textView.frame.size.height + 5, more.frame.size.width + 25, more.frame.size.height + 5);
        
        
        [scrollView addSubview: more];
        [views addObject: more];
    
        return more.frame.size.height + textView.frame.size.height + 50;
    }
    else {
        UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(25, coordY, currentWidth-45, 50)];
        textView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
        
        textView.userInteractionEnabled = NO;
        textView.scrollEnabled = NO;
        textView.editable = NO;
        NSString *text =  [parser.paragraphs objectAtIndex: textIdx];
        [textView setText: text];
        
        textView.font = [[Config instance] smallFont];
        textView.textColor = [[Config instance] color1];
        textView.textAlignment = NSTextAlignmentJustified;
        
        CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
        CGRect newFrame = textView.frame;
        newFrame.size.height = textViewSize.height;
        textView.frame = newFrame;
        
        [scrollView addSubview: textView];
        [views addObject: textView];
        
        
        //[self searchPopupsInView: textView];
        
        return textView.frame.size.height + 50;
    }
    return 0;
}

- (void)expandParagraph:(id)sender {
    UIButton *triggeredButton = ((UIButton*)sender);
    int paragraphIdx = triggeredButton.tag; 
    
    int paragraphSpacing = 50;
    
    if(![[isParagraphOpen objectForKey: [NSNumber numberWithInt: paragraphIdx]] boolValue]) {
        [isParagraphOpen setObject: [NSNumber numberWithBool:YES] forKey: [NSNumber numberWithInt: paragraphIdx]];
        //[triggeredButton setImage: [UIImage imageNamed: @"moins.png"] forState: UIControlStateNormal];
        [triggeredButton setTitle: [[Labels instance] contractSynopsis] forState: UIControlStateNormal];
        
        UITextView *paragraph = (UITextView*)[views objectAtIndex: paragraphIdx - 1];

        NSString *newText = [parser.paragraphs objectAtIndex: [[buttonToParagraphIdx objectForKey: [NSNumber numberWithInt:paragraphIdx]] intValue]];
        //NSLog(@"OldView = %@", [views objectAtIndex: paragraphIdx-1]);
        //NSLog(@"NewText = %@", newText);
        
        
        
        
        UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(25, paragraph.frame.origin.y + paragraph.frame.size.height + paragraphSpacing, currentWidth-45, 50)];
        textView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
        
        textView.font = [[Config instance] smallFont];
        textView.textColor = [[Config instance] color1];
        textView.textAlignment = NSTextAlignmentJustified;
        
        textView.userInteractionEnabled = NO;
        textView.scrollEnabled = NO;
        textView.editable = NO;
        [textView setText: newText];
        
        
        [scrollView addSubview: textView];
        
                
        
        
        [buttonToParagraphView setObject: textView forKey: [NSNumber numberWithInteger: paragraphIdx]];
            
        
        CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
        CGRect newFrame = textView.frame;
        newFrame.size.height = textViewSize.height;
        textView.frame = newFrame;
        
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + textView.frame.size.height);
        
        UIView *superiorLine = [[UIView alloc] initWithFrame:CGRectMake(0, textView.frame.origin.y - 3, currentWidth, 1)];
        superiorLine.backgroundColor = [[Config instance] color1];
        [scrollView addSubview: superiorLine];
        
        UIView *inferiorLine = [[UIView alloc] initWithFrame:CGRectMake(0, textView.frame.origin.y + textView.frame.size.height + 3, currentWidth, 1)];
        inferiorLine.backgroundColor = [[Config instance] color1];
        [scrollView addSubview: inferiorLine];
        
        [superiorLines setObject: superiorLine forKey: [NSNumber numberWithInteger: paragraphIdx]];
        [inferiorLines setObject: inferiorLine forKey: [NSNumber numberWithInteger: paragraphIdx]];
        
        //[self searchPopupsInView: textView];
                
        for(int i=paragraphIdx + 1; i < views.count; ++i) {
            UIView *view = [views objectAtIndex: i];
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + textView.frame.size.height, view.frame.size.width, view.frame.size.height);
        }
        
        NSNumber *expandedViewIndex;
        for(expandedViewIndex in [buttonToParagraphView allKeys]) {
            if([expandedViewIndex intValue] > paragraphIdx + 1) {
                UIView *view = [buttonToParagraphView objectForKey: expandedViewIndex];
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + textView.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        
        for(expandedViewIndex in [superiorLines allKeys]) {
            if([expandedViewIndex intValue] > paragraphIdx) {
                UIView *view = [superiorLines objectForKey: expandedViewIndex];
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + textView.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        
        for(expandedViewIndex in [inferiorLines allKeys]) {
            if([expandedViewIndex intValue] > paragraphIdx) {
                UIView *view = [inferiorLines objectForKey: expandedViewIndex];
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y + textView.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        
        CGRect frame;
        for(int i=0; i < clickingFrames.count; i++) {
            NSValue *value;
            value = [clickingFrames objectAtIndex: i];
            frame = [value CGRectValue];
            
            if(frame.origin.y > textView.frame.origin.y) {
                frame = CGRectMake(frame.origin.x, frame.origin.y + textView.frame.size.height, frame.size.width, frame.size.height);
                [clickingFrames replaceObjectAtIndex: i withObject: [NSValue valueWithCGRect: frame]];
            }
        }
        // La recherche de popup dans le nouveau paragraphe vient après le décalage de tous les clicking frames (sinon les nouvelles frames seront également décallées)
        [self searchPopupsInView: textView];
        
    } else if([[isParagraphOpen objectForKey: [NSNumber numberWithInt: paragraphIdx]] boolValue]) {
        [isParagraphOpen setObject: [NSNumber numberWithBool:NO] forKey: [NSNumber numberWithInt: paragraphIdx]];
        //[triggeredButton setImage: [UIImage imageNamed: @"plus.png"] forState: UIControlStateNormal];
        [triggeredButton setTitle: [[Labels instance] expandSynopsis] forState: UIControlStateNormal];
        
        UITextView *viewToRemove = [buttonToParagraphView objectForKey: [NSNumber numberWithInteger: paragraphIdx]];
        [buttonToParagraphView removeObjectForKey:  [NSNumber numberWithInteger: paragraphIdx] ];
        
        UIView *line = [superiorLines objectForKey:[NSNumber numberWithInteger: paragraphIdx]];
        [line removeFromSuperview];
        line = [inferiorLines objectForKey:[NSNumber numberWithInteger: paragraphIdx]];
        [line removeFromSuperview];
        
        [superiorLines removeObjectForKey: [NSNumber numberWithInteger: paragraphIdx]];
        [inferiorLines removeObjectForKey: [NSNumber numberWithInteger: paragraphIdx]];
        
        for(int i=paragraphIdx + 1; i < views.count; ++i) {
            UIView *view = [views objectAtIndex: i];
            view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - viewToRemove.frame.size.height, view.frame.size.width, view.frame.size.height);
        }
        
        NSNumber *expandedViewIndex;
        for(expandedViewIndex in [buttonToParagraphView allKeys]) {
            if([expandedViewIndex intValue] > paragraphIdx + 1) {
                UIView *view = [buttonToParagraphView objectForKey: expandedViewIndex];
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - viewToRemove.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        for(expandedViewIndex in [superiorLines allKeys]) {
            if([expandedViewIndex intValue] > paragraphIdx ) {
                UIView *view = [superiorLines objectForKey: expandedViewIndex];
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - viewToRemove.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        
        for(expandedViewIndex in [inferiorLines allKeys]) {
            if([expandedViewIndex intValue] > paragraphIdx) {
                UIView *view = [inferiorLines objectForKey: expandedViewIndex];
                view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y - viewToRemove.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        
        CGRect frame;
        for(int i=0; i < clickingFrames.count; i++) {
            NSValue *value;
            value = [clickingFrames objectAtIndex: i];
            frame = [value CGRectValue];
            //NSLog(@"ViewToRemove from %f to %f", viewToRemove.frame.origin.y, viewToRemove.frame.origin.y + viewToRemove.frame.size.height);
            
            //NSLog(@"Frame from %f to %f", frame.origin.y, frame.origin.y + frame.size.height);
            
            if(frame.origin.y > viewToRemove.frame.origin.y + viewToRemove.frame.size.height) {
                frame = CGRectMake(frame.origin.x, frame.origin.y - viewToRemove.frame.size.height, frame.size.width, frame.size.height);
                [clickingFrames replaceObjectAtIndex: i withObject: [NSValue valueWithCGRect: frame]];
            }
            else if(frame.origin.y > viewToRemove.frame.origin.y && frame.origin.y < (viewToRemove.frame.origin.y + viewToRemove.frame.size.height)) {
                [clickingFrames removeObjectAtIndex: i];
                i--; // on enlève un objet à la liste, tout se décale vers la gauche, donc il faut décrémenter i 
            }
        }
        
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height - viewToRemove.frame.size.height);
        [viewToRemove removeFromSuperview];
    }
}

- (int)addCitation:(int)citationIdx {
    coordY += 30;
    UITextView *textView = [[UITextView alloc] initWithFrame: CGRectMake(55, coordY, currentWidth-100, 50)];
    textView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    
    textView.font = [[Config instance] quoteFont];
    
    textView.textColor = [[Config instance] color1];
    textView.textAlignment = NSTextAlignmentJustified;
    
    NSString *leftPointing = [NSString stringWithUTF8String: "\xC2\xAB "];
    NSString *rightPointing = [NSString stringWithUTF8String: " \xC2\xBB"];
    
    NSString *text =  [leftPointing stringByAppendingString: [[parser.citations objectAtIndex: citationIdx] stringByAppendingString: rightPointing]];
    
    textView.userInteractionEnabled = NO;
    textView.scrollEnabled = NO;
    textView.editable = NO;

    [textView setText: text];
    
    CGSize textViewSize = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    CGRect newFrame = textView.frame;
    newFrame.size.height = textViewSize.height;
    textView.frame = newFrame;
    
    [scrollView addSubview: textView];
    [views addObject: textView];
    
    
    

    UILabel *author = [[UILabel alloc] init];

    author.backgroundColor = [UIColor clearColor];
    author.textColor = [[Config instance] color1];
    author.font = [[Config instance] normalFont];
    author.text = [parser.authors objectAtIndex: citationIdx];
    [author sizeToFit];
    author.frame = CGRectMake(scrollView.frame.size.width/2 - author.frame.size.width/2, coordY + textView.frame.size.height + 10, author.frame.size.width,  author.frame.size.height);
    [scrollView addSubview: author];
    [views addObject: author];
    
    return textView.frame.size.height + author.frame.size.height + 90;
}

- (int)addSubtitle:(int)subtitleIdx {
    coordY += 20;
    int width = currentWidth-100;
    CGRect frame;
    UILabel *subtitle = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, width, 10)];
    subtitle.text = [parser.subtitles objectAtIndex: subtitleIdx];
    subtitle.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
    subtitle.font = [[Config instance] bigFont];
    subtitle.textColor = [[Config instance] color5];
    subtitle.numberOfLines = 0;
    [subtitle sizeToFit];

    if([[parser.locations objectAtIndex: subtitleIdx] isEqualToString:@"gauche"]) {
        frame = CGRectMake(30, coordY, subtitle.frame.size.width, subtitle.frame.size.height);
    } else if([[parser.locations objectAtIndex: subtitleIdx] isEqualToString:@"droite"]) {
        frame = CGRectMake(currentWidth - 25 - subtitle.frame.size.width, coordY, subtitle.frame.size.width, subtitle.frame.size.height);
    } else {
        frame = CGRectMake(currentWidth/2 - subtitle.frame.size.width /2, coordY, subtitle.frame.size.width, subtitle.frame.size.height);
    }
    subtitle.frame = frame;
    
    
    
    [scrollView addSubview: subtitle];
    [views addObject: subtitle];
    
    return subtitle.frame.size.height + 30;
}



- (int)addImage:(int)imageIdx {

    UIImage *image = [UIImage imageWithContentsOfFile: [[LanguageManagement instance] pathForFile: [parser.images objectAtIndex: imageIdx] contentFile: NO]];
    if(image != nil) {
        float newWidth = image.size.width;
        float newHeight = image.size.height;
        
        
        int maxImageWidth = (currentWidth/2)+100;
        
        if(image.size.width > maxImageWidth || ![[parser.adjusts objectAtIndex: imageIdx] isEqualToString: @"non"]) {
            newWidth = maxImageWidth;
            float oldWidth = image.size.width;
            float scaleFactor = newWidth / oldWidth;
            newHeight = image.size.height * scaleFactor;
        }

        float ratio =
        768 / (float)currentWidth;
        float maxHeight = (float)(1000 * ratio);
        if(newHeight > maxHeight) {
            newHeight = maxHeight;
            float scaleFactor = newHeight / image.size.height;
            newWidth = image.size.width * scaleFactor;
        }
        
        
        UIButton *button = [UIButton buttonWithType: UIButtonTypeCustom];
        [button setBackgroundImage: image forState: UIControlStateNormal];
        
        button.contentMode = UIViewContentModeScaleToFill;

        button.imageView.frame = CGRectMake(0, 0, newWidth, newHeight);
        
        button.frame = CGRectMake(25 + (maxImageWidth/2 - newWidth/2), coordY, newWidth, newHeight);
        [buttonsList addObject: button];
        button.tag = imageIdx;
        
        
        
        NSString *type = [parser.linksTypes objectAtIndex: imageIdx];
        if([type isEqualToString: @"text"]) {
            [self addLine: button.frame index: imageIdx];
            [button addTarget: self action:@selector(toText:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if([type isEqualToString: @"slideshow"]) {
            [self addLine: button.frame index: imageIdx];
            [button addTarget: self action:@selector(toSlideshow:) forControlEvents: UIControlEventTouchUpInside];
        }
        else if([type isEqualToString: @"movie"]) {
            [self addLine: button.frame index: imageIdx];
            [button addTarget: self action:@selector(toMovie:) forControlEvents: UIControlEventTouchUpInside];
        }
        else if([type isEqualToString: @"zoom"]) {
            [self addLine: button.frame index: imageIdx];
            [button addTarget: self action:@selector(toZoom:) forControlEvents: UIControlEventTouchUpInside];
        }
        else if([type isEqualToString: @"audio"]) {
            [self addLine: button.frame index: imageIdx];
            [button addTarget: self action:@selector(handleAudio:) forControlEvents: UIControlEventTouchUpInside];
        }
        [scrollView addSubview: button];
        [views addObject: button];
        
        float startComment = maxImageWidth + 50;
        if(![[parser.comments objectAtIndex: imageIdx] isEqualToString: @"nil"]) {
            UILabel *commentView = [[UILabel alloc] initWithFrame: CGRectMake(startComment, coordY + newHeight/3, currentWidth - startComment - 25, 75)];
            
            commentView.font = [[Config instance] smallFont];
            commentView.textColor = [[Config instance] color1];
            commentView.backgroundColor = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.0 ];
            commentView.numberOfLines = 0;
            commentView.text = [parser.comments objectAtIndex: imageIdx];
            
            [scrollView addSubview: commentView];
            [views addObject: commentView];
        }
        
        if(![[parser.sources objectAtIndex: imageIdx] isEqualToString: @"nil"]) {
            UILabel *sourceView = [[UILabel alloc] initWithFrame: CGRectMake(startComment, coordY + newHeight - 50,  currentWidth - startComment - 25, 50)];
            
            sourceView.font = [[Config instance] tinyFont];
            sourceView.textColor = [[Config instance] color1];
            sourceView.backgroundColor = [UIColor clearColor];
            sourceView.numberOfLines = 2;
            
            sourceView.text = [parser.sources objectAtIndex: imageIdx];
            
            [scrollView addSubview: sourceView];
            [views addObject: sourceView];
        }
        
        return newHeight + 20;
    }
    else {
        Alerts *alert = [[Alerts alloc] init];
        [alert showImageNotFoundAlert:self file:[[LanguageManagement instance] pathForFile: [parser.images objectAtIndex: imageIdx] contentFile: NO]];
    }
    
    
    return 0;
}

- (void)addLine:(CGRect)frame index:(int)imageIdx{
    if([[parser.linksContours objectAtIndex:imageIdx] isEqualToString: @"oui"]) {
        UIView *line = [[UIView alloc] initWithFrame: CGRectMake(frame.origin.x-3, frame.origin.y-3, frame.size.width+6, frame.size.height+6)];
        line.backgroundColor = [[Config instance] color6Full];
        [scrollView addSubview: line];
    }
}


- (void)searchPopupsInView:(UITextView*)view  {
    XMLDictionaryParser *dictionary = [XMLDictionaryParser instance];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:view.text];
    
    for(int i=0; i < dictionary.words.count; ++i) {
        [self addPopUpIfNeeded: view forWord: [dictionary.words objectAtIndex: i] withComment: [dictionary.definitions objectAtIndex: i]  attributedString: attributedString];
    }
    [attributedString addAttribute: NSFontAttributeName
                             value: [[Config instance] smallFont]
                             range: NSMakeRange(0, attributedString.length)];
    view.attributedText = attributedString;
}

- (void)addPopUpIfNeeded:(UITextView*)textView forWord:(NSString*)word withComment:(NSString*)comment attributedString:(NSMutableAttributedString*) attributedString{
    NSRange range = [self searchRangeOfWord: word inView:textView attributedString: attributedString];
    if(range.location != NSNotFound) {
        [self addToClickingFrames: range inView: textView ];
        [commentToPopup addObject: comment];
    }
}

- (void)addToClickingFrames:(NSRange)range inView:(UITextView*)textView  {
    int error = 5;
    CGRect frame = [self frameOfTextRange:range inTextView: textView];
    //frame par rapport à la texte view mais tap gérée par la scrollview
    //frame.origin.x = frame.origin.x ;
    
    frame.origin.y =  textView.frame.origin.y + frame.origin.y  - error;
    
    frame.size.width = frame.size.width + 4*error;
    frame.size.height = frame.size.height + 2*error;
    [clickingFrames addObject: [NSValue valueWithCGRect: frame]];
    
    
    //utile pour voir la zone cliquable
    /*UIView *view = [[UIView alloc] initWithFrame: frame];
    view.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0.6];
    [scrollView addSubview: view];*/
}

- (NSRange)searchRangeOfWord:(NSString*)word inView:(UITextView*)textView attributedString:(NSMutableAttributedString*) attributedString {
    NSRange range = [textView.text rangeOfString: word  options: NSCaseInsensitiveSearch];

    if(range.location != NSNotFound) {
            
        [attributedString addAttribute: NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInt: NSUnderlineStyleSingle]
                    range: range];
        
        [attributedString addAttribute: NSForegroundColorAttributeName
                    value: [[Config instance] color4]
                    range: range];
       
    }
    return range;
}


- (void)viewDidAppear:(BOOL)animated {
    
    
}

- (void)viewDidUnload
{
    
    [self setScrollView:nil];
    [self setTitle:nil];
    [super viewDidUnload];
}


- (void)addGesture {
    tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touches)];
    [tapGr setNumberOfTapsRequired:1];
    [scrollView addGestureRecognizer:tapGr];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touche");
}

- (void)touches {
   // NSValue *value;
    // Pour débug des zones cliquables
    /*for(UIView *sub in [scrollView subviews])
        if(sub.tag == 123)
            [sub removeFromSuperview];*/

    /*for(value in clickingFrames) {
        CGRect frame = [value CGRectValue];
               UIView *view = [[UIView alloc] initWithFrame: frame];
         Pour débug des zones cliquables
        view.tag = 123;
        view.backgroundColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:0.6];
        [scrollView addSubview: view];
    }*/
    
    for(int i=0; i < clickingFrames.count; ++i) {
        CGRect tempRect = [[clickingFrames objectAtIndex: i] CGRectValue];
        if(CGRectContainsPoint(tempRect, [tapGr locationInView: scrollView])) {
            //NSLog(@"touche tap x: %f", [tapGr locationInView: scrollView].x);
           // NSLog(@"touche tap y: %f", [tapGr locationInView: scrollView].y);
            
            if( [popover isPopoverVisible]) {
                [popover dismissPopoverAnimated: YES];
            }
            else {
                [self showPopup:tempRect atIndex: i];
                
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
    tv.text = [commentToPopup objectAtIndex: idx];
    tv.backgroundColor = [[Config instance] color2];
    tv.font = [[Config instance] smallFont];
    tv.textColor = [[Config instance] color1];
    tv.frame = CGRectMake(0, 0, 350, 250);

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



- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView*)textView {
    UITextPosition *beginning = textView.beginningOfDocument;
    //NSLog(@"begnning %@", beginning);
    UITextPosition *start = [textView positionFromPosition: beginning offset: range.location];
    // NSLog(@"start %@", start);
    UITextPosition *end = [textView positionFromPosition: start offset: range.length];
    // NSLog(@"end %@", end);
    UITextRange *textRange = [textView textRangeFromPosition: start toPosition: end];
    CGRect rect = [textView firstRectForRange: (UITextRange *)textRange];
    return [textView convertRect: rect fromView: textView];
}


-(IBAction)toText:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.links objectAtIndex: idx];
    NSLog(@"cliqué text object idx %@", argument);
    
    TextViewController *txtVC = (TextViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"txtVC"];
    NSLog(@"textvc = %@", txtVC);
    txtVC.standID = argument;

    [self.navigationController pushViewController: txtVC animated: YES];
}

-(IBAction)toSlideshow:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.links objectAtIndex: idx];
    NSLog(@"cliqué slideshow object idx %@", argument);
    [self performSegueWithIdentifier: @"toSlideshow" sender: self];
}

-(IBAction)toMovie:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.links objectAtIndex: idx];
    NSLog(@"cliqué Movie %@", argument);
    [self performSegueWithIdentifier: @"toMovie" sender: self];
}

-(IBAction)toZoom:(id)sender {
    int idx = ((UIButton*)sender).tag;
    argument = [parser.links objectAtIndex: idx];
    NSLog(@"cliqué zoom %@", argument);
    [self performSegueWithIdentifier: @"toZoom" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if( [segue.identifier isEqualToString:@"toSlideshow"] ) {
        SlideshowViewController *slideshowVC = [segue destinationViewController];
        slideshowVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"toMovie"] ) {
        MovieViewController *movieVC = [segue destinationViewController];
        movieVC.standID = argument;
    }
    else if( [segue.identifier isEqualToString:@"toZoom"] ) {
        ImageZoomViewController *zoomVC = [segue destinationViewController];
        zoomVC.fileName = argument;
        //NSLog(@"segue with filename : %@", argument);
    }
}


- (void)deleteSubviewsFromView:(UIView*)view {
    UIView *child;
    for(child in [view subviews]) {
        if(child.tag != 999 && child.tag != 1000 && child.tag != 1002) {
            [child removeFromSuperview];
        }
        // 1000 is the tag of the scrollview
        if(child.tag == 1000) {
            [self deleteSubviewsFromView: child];
        }
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self deleteSubviewsFromView: self.view];

    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        currentWidth = 1024;
        [self createBodyWithWidth];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        currentWidth = 768;
        [self createBodyWithWidth];
    }
    
}

- (IBAction)handleAudio:(id)sender {
    if(![self stopAudio: sender]) {
        [self startAudio: sender];
    }
}

- (Boolean)startAudio:(id)sender {
    UIButton *button = ((UIButton*)sender);
    int idx = button.tag;
    argument = [parser.links objectAtIndex: idx];
    audioController = [[AudioViewController alloc] init];
    audioController.file = argument;
    [audioController addAudioAndPlayOnceToView: self.view parent:self];
    
    [audioController addVolumeButton: scrollView Yoffset: button.frame.origin.y  Xoffset:button.frame.origin.x + button.frame.size.width + 10 ];
    return true;
}

- (Boolean)stopAudio:(id)sender {
    if(audioController != nil) {
        Boolean result = [audioController tryToStop: self];
        [audioController removeVolumeIcon];
        audioController = nil;
        return result;
    }
    return false;
}

@end
