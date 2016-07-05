//
//  ColorWheelImageView.m
//  ColorAtPointOnUIImageView
//
//  Created by jignesh on 22/06/16.
//  Copyright © 2016 jignesh. All rights reserved.
//

#import "ColorWheelImageView.h"
#import "ViewController.h"

@interface ColorWheelImageView(){
    
    CGPoint _touchPoint;
    float _radius;
    UIColor* lastColor;
    
}
@end

@implementation ColorWheelImageView

@synthesize delegate = _delegate;
@synthesize knobView = _knobView;
@synthesize knobSize = _knobSize;

- (void)dealloc{
    self.knobView = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _radius = (MIN(self.frame.size.width, self.frame.size.height) / 2.0) - 1.0;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[_delegate colorWheelDidChangeColor:self];
    
//    if ([self isTouchInsideWellView:[[touches anyObject] locationInView:self]]) {
//        return;
//    }
    
    if ([self isTouchOutSideView:[[touches anyObject] locationInView:self]]) {
        return;
    }
    
    NSLog(@"%@",NSStringFromCGPoint([[touches anyObject] locationInView:self]));
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"Moved: %@",NSStringFromCGPoint([[touches anyObject] locationInView:self]));
    
    [self setTouchPoint:[[touches anyObject] locationInView:self]];
    
//    if ([self isTouchInsideWellView:[[touches anyObject] locationInView:self]]) {
//        return;
//    }
    
    if ([self isTouchOutSideView:[[touches anyObject] locationInView:self]]) {
        return;
    }
    
    lastColor = [self getPixelColorAtLocation:[[touches anyObject] locationInView:self]];
    NSLog(@"color %@",lastColor);
    
    if (lastColor) {
        
        [_delegate colorWheelDidChangeColor:(UIColor*)lastColor];
        
    } else {
        
        NSLog(@"Error");
        
    }
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self setTouchPoint:[[touches anyObject] locationInView:self]];
    
    lastColor = [self getPixelColorAtLocation:_touchPoint];
    NSLog(@"color %@",lastColor);
    [_delegate colorWheelDidChangeColor:(UIColor*)lastColor];
}

-(float)distanceWithCenter:(CGPoint)current with:(CGPoint)SCCenter
{
    CGFloat dx=current.x-SCCenter.x;
    CGFloat dy=current.y-SCCenter.y;
    
    return sqrt(dx*dx + dy*dy);
}

- (BOOL) isTouchInsideWellView:(CGPoint )touchPoint {
    
    CGFloat radius=60;
    CGPoint circleCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = circleCenter.x - touchPoint.x;
    float dy = circleCenter.y - touchPoint.y;
    
    float dist = sqrtf(dx * dx + dy * dy);
    if (dist <= radius){
        NSLog(@"\tYou tapped the inner sector!");
        return true;
    }
    else{
        NSLog(@"\tYou tapped the annulus!");
        return false;
    }
}

- (BOOL) isTouchOutSideView:(CGPoint )touchPoint {
    
    CGPoint circleCenter = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    float dx = circleCenter.x - touchPoint.x;
    float dy = circleCenter.y - touchPoint.y;
    
    float dist = sqrtf(dx * dx + dy * dy);
    if (dist <= _radius){
        return false;
    }
    else{
        return true;
    }
}

- (void)setTouchPoint:(CGPoint)point {
    
    //NSLog(@"%@",NSStringFromCGPoint(point));
    
//    if ([self isTouchInsideWellView:point]) {
//        return;
//    }
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    CGPoint center = CGPointMake(width / 2.0, height / 2.0);
    
    // Check if the touch is outside the wheel
    if (JPColorWheel_PointDistance(center, point) < _radius)
    {
        _touchPoint = point;
    }
    else
    {
        // If so we need to create a drection vector and calculate the constrained point
        CGPoint vec = CGPointMake(point.x - center.x, point.y - center.y);
        
        float extents = sqrtf((vec.x * vec.x) + (vec.y * vec.y));
        
        vec.x /= extents;
        vec.y /= extents;
        
        _touchPoint = CGPointMake(center.x + vec.x * _radius, center.y + vec.y * _radius);
    }
    
    [self updateKnob];
}

- (void)updateKnob
{
    if (!_knobView) {
        
        _knobSize = CGSizeMake(20, 20);
        _touchPoint = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
        
        self.knobView = [[UIView alloc] init];
        self.knobView.bounds = CGRectMake(0, 0, _knobSize.width, _knobSize.height);
        self.knobView.backgroundColor = [UIColor clearColor];
        self.knobView.layer.borderWidth = 5.0;
        self.knobView.layer.borderColor = [[UIColor whiteColor] CGColor];
        self.knobView.layer.cornerRadius = 10;
        self.knobView.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.knobView];
        
    }
    
    _knobView.center = _touchPoint;
    
}

static float JPColorWheel_PointDistance (CGPoint p1, CGPoint p2)
{
    return sqrtf((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

- (UIColor*) getPixelColorAtLocation:(CGPoint)point {
    UIColor* color = nil;
    CGImageRef inImage = self.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil; /* error */ }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        int offset = 4*((w*round(point.y))+round(point.x));
        int alpha =  data[offset];
        int red = data[offset+1];
        int green = data[offset+2];
        int blue = data[offset+3];
        NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
        color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
    }
    
    // When finished, release the context
    CGContextRelease(cgctx); 
    // Free image data memory for the context
    if (data) { free(data); }
    
    return color;
}

- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    unsigned long   bitmapByteCount;
    unsigned long   bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image.
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

-(void) setKnobView:(UIView *)knobView{
    
    _knobView = knobView;
    
}

@end
