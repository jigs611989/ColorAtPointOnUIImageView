//
//  ViewController.m
//  ColorAtPointOnUIImageView
//
//  Created by jignesh on 22/06/16.
//  Copyright © 2016 jignesh. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()<ColorWheelImageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imgColorWheel.delegate = self;
    
    UIImageView *_imgKnob = [[UIImageView alloc] init];
    _imgKnob.bounds = CGRectMake(0, 0, 20, 20);
    _imgKnob.center = _imgColorWheel.center;
    _imgKnob.backgroundColor = [UIColor clearColor];
    _imgKnob.layer.borderWidth = 2.0;
    _imgKnob.layer.borderColor = [[UIColor whiteColor] CGColor];
    _imgKnob.layer.cornerRadius = 10;
    _imgKnob.clipsToBounds = YES;
    
    [_imgColorWheel addSubview:_imgKnob];
    
    _imgColorWheel.knobView = _imgKnob;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)colorWheelDidChangeColor:(UIColor *)color{
    _imgSelectedColor.backgroundColor = color;
    
}

- (void)publishColorViaMQTT:(UIColor *)color{
    
}

@end
