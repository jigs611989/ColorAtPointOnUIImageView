//
//  ViewController.h
//  ColorAtPointOnUIImageView
//
//  Created by jignesh on 22/06/16.
//  Copyright © 2016 jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ColorWheelImageView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet ColorWheelImageView *imgColorWheel;

@property (weak, nonatomic) IBOutlet UIImageView *imgSelectedColor;

//- (void) pickedColor:(UIColor*)color;

@end

