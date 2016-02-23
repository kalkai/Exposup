//
//  QuizViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/04/13.
//
//

#import "QuizViewController.h"

@interface QuizViewController ()

@end

@implementation QuizViewController

@synthesize  fileName, parser, questionView, currentQuestionNum, currentQuestion, buttons, goodAnswers, answersGiven, answersForQuestion, resultsScrollview, shouldPrintResults;

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
    self.previousOrientation = UIInterfaceOrientationPortrait;
    
	parser = [[XMLQuizParser alloc] init];
    if(![parser parseXMLFileAtPath: fileName]){
        UIAlertController* alert = [[UIAlertController alloc] init];
        if([XMLParser getState] == FILE_EMPTY) {
            alert = [Alerts getQuizNotFoundAlert:fileName];
        }
        else if([XMLParser getState] == PARSING_ERROR) {
            alert = [Alerts getParsingErrorAlert:[XMLLabelsParser getLastErrorFilePath] error:[XMLLabelsParser getLastErrorDescription]];
        }
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    currentQuestionNum = 0;
    goodAnswers = 0;
    buttons = [[NSMutableArray alloc] init];
    answersGiven = [[NSMutableArray alloc] init];
    answersForQuestion = [[NSMutableArray alloc] init];
    
    resultsScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 768, 1024 - 100)];
    shouldPrintResults = NO;
    
    [self printViewForQuestion: 0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    UIInterfaceOrientation toInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(self.previousOrientation != toInterfaceOrientation) {
        self.previousOrientation = toInterfaceOrientation;
        if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight || toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            UIView *view;
            int center = 1024/2;
            for(view in [self.view subviews]) {
                if(view.tag != 999) {
                    int difference = view.frame.origin.x - 768/2;
                    view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }
            }
            resultsScrollview.frame = CGRectMake(0, 100, 1024, 768 - 100);
        }
        else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
            UIView *view;
            int center = 768/2;
            for(view in [self.view subviews]) {
                if(view.tag != 999) {
                    int difference = view.frame.origin.x - 1024/2;
                    view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
                }
            }
            resultsScrollview.frame = CGRectMake(0, 100, 768, 1024 - 100);
        }
        [self updateResults];
    }
}


- (void)updateQuestion:(int)num atOriginY:(int) yOffset toView:(UIView*)view {
     NSString *question = [parser.questions objectAtIndex: num];
    int center = view.frame.size.width/2;
    
    CGSize available = CGSizeMake(view.frame.size.width - 100, 9999);
    currentQuestion = [[UILabel alloc] init];
    currentQuestion.frame =  CGRectMake(0, 0, self.view.frame.size.width - 100, 100);
    currentQuestion.lineBreakMode = NSLineBreakByWordWrapping;
    currentQuestion.backgroundColor = [UIColor clearColor];
    currentQuestion.textColor = [[Config instance] color1];
    currentQuestion.font = [[Config instance] normalFont];
    currentQuestion.text = question;
    currentQuestion.numberOfLines = 0;
    
    
    CGSize sizedToFit = [currentQuestion sizeThatFits: available];
    
    
    currentQuestion.frame = CGRectMake( center-sizedToFit.width/2, yOffset, sizedToFit.width, sizedToFit.height);
    [view addSubview: currentQuestion];
}

- (void)createButtonFromCenter:(int)center Yoffset:(int)y forIndex:(int)index forAnswer:(NSString*)answer{
    UIButton *ans = [ColorButton getButton];
    [ans setTitle:answer forState:UIControlStateNormal];
    [ans addTarget:self action:@selector(verifyAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [ans sizeToFit];
    ans.tag = index;
    ans.frame = CGRectMake( center - 550/2, y, 550, ans.frame.size.height*2);
    [self.view  addSubview:ans];
    [buttons addObject: ans];
    
}

- (void)updateButtons:(int)num {
    NSString *correctAnswer = [parser.correctAnswers objectAtIndex: num];
    NSMutableArray *tmpAnswers = [parser.falseAnswers objectAtIndex: num];
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    [answers addObject: correctAnswer];
    for(int i=0; i < tmpAnswers.count; ++i)
        [answers addObject: [tmpAnswers objectAtIndex: i]];
    [answersForQuestion addObject: answers];
    
    int center = self.view.frame.size.width/2;
    int beginIDX = arc4random() % 4;
    NSLog(@"begin %d",beginIDX);
    
    int y = 300;
    [self createButtonFromCenter: center Yoffset: y forIndex: beginIDX forAnswer: [answers objectAtIndex: beginIDX]];
    y += 100;
    [self createButtonFromCenter: center Yoffset: y forIndex: (beginIDX+1)%4 forAnswer: [answers objectAtIndex: (beginIDX+1)%4]];
    y += 100;
    [self createButtonFromCenter: center Yoffset: y forIndex: (beginIDX+2)%4 forAnswer: [answers objectAtIndex: (beginIDX+2)%4]];
    y += 100;
    [self createButtonFromCenter: center Yoffset: y forIndex: (beginIDX+3)%4 forAnswer: [answers objectAtIndex: (beginIDX+3)%4]];
    
}

- (void)printViewForQuestion:(int)num {
    [self updateQuestion: num atOriginY: 150 toView: self.view];
    [self updateButtons: num];
}

- (IBAction)verifyAnswer:(id)sender {
    NSInteger answerReceived = ((UIButton*)sender).tag;
    [answersGiven addObject: [NSNumber numberWithInteger: answerReceived]];
    NSLog(@"Réponse reçue : %ld", (long)answerReceived);
    if(answerReceived == 0) { // la bonne réponse se trouvait en index 0
        NSLog(@"correct answer");
        goodAnswers++;
    }
    else NSLog(@"wrong answer");
    if(currentQuestionNum < parser.questions.count - 1) { // on affiche la suivante
        [self removePreviousQuestion];
        currentQuestionNum++;
        [self printViewForQuestion: currentQuestionNum];
    }
    else {
        [self printResults];
    }
    //NSLog(@"Verifying answer...");
}

-(void) updateResults {
    if(shouldPrintResults) {
        for(UIView *subview in resultsScrollview.subviews) {
            [subview removeFromSuperview];
        }
        
        [self printResults];
    }
}

- (void)printResults {
    [self removePreviousQuestion];
    shouldPrintResults = YES;
    
    UILabel *lab = [[UILabel alloc] init];
    lab.backgroundColor = [UIColor clearColor];
    lab.text = [NSString stringWithFormat: @"Résultats : %d / %d !", goodAnswers, parser.questions.count]; // stringByAppendingString: [@" sur " stringByAppendingString: [NSString stringWithFormat: @"%"] ]];
    lab.textColor = [[Config instance] color1];
    lab.font = [[Config instance] smallFont];
    [lab sizeToFit];
    lab.frame = CGRectMake( resultsScrollview.frame.size.width / 2 - lab.frame.size.width / 2, 10, lab.frame.size.width, lab.frame.size.height);
    [resultsScrollview addSubview: lab];
    
    
    
    int totalHeight = lab.frame.origin.y + lab.frame.size.height + 40;;
    //resultsScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 300, 768, 1000)];
    NSLog(@"Scroll view = %@", resultsScrollview);
    resultsScrollview.scrollEnabled = YES;
    for(int i=0; i < parser.questions.count; ++i) {
        [self updateQuestion: i atOriginY: totalHeight toView: resultsScrollview];
        
        int answerGiven = [[answersGiven objectAtIndex: i] integerValue];
        UILabel *answer = [[UILabel alloc] init];
        answer.backgroundColor = [UIColor clearColor];
        answer.text = [[answersForQuestion objectAtIndex: i] objectAtIndex: 0];
        answer.font = [[Config instance] normalFont];
        if(answerGiven == 0) // la bonne réponse est à l'index 0
            answer.textColor = [UIColor greenColor];
        else answer.textColor = [UIColor redColor];
        [answer sizeToFit];
        answer.frame = CGRectMake(resultsScrollview.frame.size.width/ 2 - answer.frame.size.width / 2, currentQuestion.frame.origin.y + currentQuestion.frame.size.height + 20, answer.frame.size.width, answer.frame.size.height);
        
        totalHeight = answer.frame.origin.y + answer.frame.size.height + 30;
        [resultsScrollview addSubview: answer];
    }
    resultsScrollview.contentSize = CGSizeMake(resultsScrollview.frame.size.width, totalHeight);
    [self.view addSubview: resultsScrollview];
}

- (void)removePreviousQuestion {
    [currentQuestion removeFromSuperview];
    UIButton *but;
    for(but in buttons) {
        NSLog(@"delete button");
        [but removeFromSuperview];
    }
    buttons = nil;
    buttons = [[NSMutableArray alloc] init];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UIView *view;
        int center = 1024/2;
        for(view in [self.view subviews]) {
            if(view.tag != 999) {
                int difference = view.frame.origin.x - 768/2;
                view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
        }
        resultsScrollview.frame = CGRectMake(0, 100, 1024, 768 - 100);
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        UIView *view;
        int center = 768/2;
        for(view in [self.view subviews]) {
            if(view.tag != 999) {
                int difference = view.frame.origin.x - 1024/2;
                view.frame = CGRectMake(center + difference, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
            }
        }
        resultsScrollview.frame = CGRectMake(0, 100, 768, 1024 - 100);
    }
    [self updateResults];
}

@end
