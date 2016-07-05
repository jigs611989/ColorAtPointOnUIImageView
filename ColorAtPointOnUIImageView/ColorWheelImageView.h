//
//  ColorWheelImageView.h
//  ColorAtPointOnUIImageView
//
//  Created by jignesh on 22/06/16.
//  Copyright © 2016 jignesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ColorWheelImageViewDelegate <NSObject>
@required
- (void)colorWheelDidChangeColor:(UIColor*)color;
- (void)publishColorViaMQTT:(UIColor*)color;
@end

@interface ColorWheelImageView : UIImageView

@property(nonatomic, retain)UIView* knobView;
@property(nonatomic, assign)CGSize knobSize;
@property(nonatomic, assign)id <ColorWheelImageViewDelegate> delegate;

@end
