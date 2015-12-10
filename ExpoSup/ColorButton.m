//
//  ColorButton.m
//  ExpoSup
//
//  Created by Aurélien Lebeau on 25/05/13.
//
//

#import "ColorButton.h"

@implementation ColorButton

+(UIButton*) getButton {
    UIButton *button = [[UIButton alloc] init];
    button = [UIButton buttonWithType: UIButtonTypeCustom];
    [button setTitleColor: [[Config instance] color3] forState: UIControlStateNormal];
    button.backgroundColor = [[Config instance] color2];
    button.layer.borderColor = [[Config instance] color3].CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 10.0f;
    [button setTitleColor: [[Config instance] color1] forState:UIControlStateHighlighted];
    return button;
}

+(void) configButton: (UIButton*)button {
    [button setTitleColor: [[Config instance] color3] forState: UIControlStateNormal];
    button.backgroundColor = [[Config instance] color2];
    button.layer.borderColor = [[Config instance] color3].CGColor;
    button.layer.borderWidth = 0.5f;
    button.layer.cornerRadius = 10.0f;
    [button setTitleColor: [[Config instance] color1] forState:UIControlStateHighlighted];
}

@end
