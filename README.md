
Purpose

- To get color of a pixel at touch point. 
- You can set knob in UIImageView.
- Also color at point when moving knob

Advantage/Benefits
- Simple to use

How to Use

- Add UIImage view and select any image
- Change class name to "ColorWheelImageView"
- Set delegate "ColorWheelImageViewDelegate"
- Implement method


- (void)colorWheelDidChangeColor:(UIColor *)color{
    
    _imgSelectedColor.backgroundColor = color;

}


- For more detail download project and run.

Note : Code is in Objective C but you can use it in Swift project via Bridge


