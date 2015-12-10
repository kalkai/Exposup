//
//  QuizViewController.h
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/04/13.
//
//

#import <UIKit/UIKit.h>
#import "SectionViewController.h"
#import "XMLQuizParser.h"
#include <stdlib.h> //for random

@interface QuizViewController : SectionParentViewController

@property (assign, nonatomic) int currentQuestionNum;

@property (assign, nonatomic) int goodAnswers;
@property (strong, nonatomic) NSMutableArray *answersGiven;
@property (strong, nonatomic) NSMutableArray *answersForQuestion; //array of array of answers

@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) XMLQuizParser *parser;
@property (strong, nonatomic) UIView *questionView;

@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UILabel *currentQuestion;

@property (strong, nonatomic) UIScrollView *resultsScrollview;
@property (assign, nonatomic) Boolean shouldPrintResults;

- (IBAction)verifyAnswer:(id)sender;

@end
