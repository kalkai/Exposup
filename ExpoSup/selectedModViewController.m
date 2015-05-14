//
//  selectedModViewController.m
//  ExpostitionSupport
//
//  Created by Aurélien Lebeau on 2/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SelectedModViewController.h"

@implementation SelectedModViewController
@synthesize modChosen, confirm,change;
@synthesize modText;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*if(![[Config instance] showChildMode] && ![[Config instance] showGuideMode]) {
        [self performSegueWithIdentifier:@"toScan" sender: self];
    }
    else {*/
    
        [change setTitle: [[Labels instance] modifyMod] forState: UIControlStateNormal];
        [confirm setTitle:[[Labels instance] confirmMod] forState: UIControlStateNormal];
    
        [ColorButton configButton: confirm];
        [ColorButton configButton: change];
    
    
    
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if([appDelegate.mod isEqualToString: @"Adult"]) {
            modChosen.text = [[Labels instance] adultButton];
        }
        else if([appDelegate.mod isEqualToString: @"Guide"]) {
            modChosen.text = [[Labels instance] guideButton];
        }
        else if([appDelegate.mod isEqualToString: @"Child"]) {
            modChosen.text = [[Labels instance] childButton];
        }
        modChosen.font = [[Config instance] bigFont];
        modChosen.textColor = [[Config instance] color1];
        [modChosen sizeToFit];
        // on va placer le label au centre. On prend la moitié de l'écran et on décale à gauche de la moitié du label.
        modChosen.frame = CGRectMake(self.view.frame.size.width/2 - modChosen.frame.size.width/2, 100, modChosen.frame.size.width, modChosen.frame.size.height);
    //}
}


- (void)viewDidUnload
{
    [self setModChosen:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)popView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
