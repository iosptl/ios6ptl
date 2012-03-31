//
//  CurvyTextView.m
//  CurvyText
//
//  Created by Rob Napier on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

static const CGFloat kControlPointSize = 13.;

#import "CurvyTextView.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

@interface CurvyTextView ()
@property (nonatomic, assign) CGPoint P0;
@property (nonatomic, assign) CGPoint P1;
@property (nonatomic, assign) CGPoint P2;
@property (nonatomic, assign) CGPoint P3;
@end

@implementation CurvyTextView
@synthesize attributedString=attributedString_;
@synthesize P0=P0_;
@synthesize P1=P1_;
@synthesize P2=P2_;
@synthesize P3=P3_;

- (void)updateControlPoints {
  NSArray *subviews = self.subviews;
  self.P0 = [[subviews objectAtIndex:0] center];
  self.P1 = [[subviews objectAtIndex:1] center];
  self.P2 = [[subviews objectAtIndex:2] center];
  self.P3 = [[subviews objectAtIndex:3] center];
  [self setNeedsDisplay];
}

- (void)addControlPoint:(CGPoint)point color:(UIColor *)color {
  CGRect rect = CGRectMake(0, 0, kControlPointSize, kControlPointSize);
  CAShapeLayer *shapeLayer = [CAShapeLayer layer];
  CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
  shapeLayer.path = path;
  shapeLayer.fillColor = color.CGColor;
  CGPathRelease(path);

  UIView *view = [[UIView alloc] initWithFrame:rect];
  [view.layer addSublayer:shapeLayer];
  
  UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  [view addGestureRecognizer:g];
  [self addSubview:view];
  view.center = point;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      [self addControlPoint:CGPointMake(50, 500) color:[UIColor greenColor]];
      [self addControlPoint:CGPointMake(300, 300) color:[UIColor blackColor]];
      [self addControlPoint:CGPointMake(400, 700) color:[UIColor blackColor]];
      [self addControlPoint:CGPointMake(650, 500) color:[UIColor redColor]];
      [self updateControlPoints];
      self.backgroundColor = [UIColor whiteColor];
      
      CGAffineTransform 
      transform = CGAffineTransformMakeScale(1, -1);
      CGAffineTransformTranslate(transform, 
                                 0,
                                 -self.bounds.size.height);
      self.transform = transform;

    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)g {
  g.view.center = [g locationInView:self];
  [self updateControlPoints];
}


- (void)drawPath {
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path moveToPoint:self.P0];
  [path addCurveToPoint:self.P3
          controlPoint1:self.P1
          controlPoint2:self.P2];
  [[UIColor blueColor] setStroke];
  [path stroke];  
}

static double Bezier(double t, double P0, double P1, double P2,
                     double P3) {
  return 
                   pow(1-t, 3) *     P0
     + 3 *         pow(1-t, 2) * t * P1
     + 3 * (1-t) * pow(t,   2) *     P2
     +             pow(t,   3) *     P3;
}

- (CGPoint)pointForOffset:(double)t {
  double x = Bezier(t, P0_.x, P1_.x, P2_.x, P3_.x);
  double y = Bezier(t, P0_.y, P1_.y, P2_.y, P3_.y);
  return CGPointMake(x, y);
}

static double BezierPrime(double t, double P0, double P1,
                          double P2, double P3) {
  return
    -  3 * pow(1-t, 2) * P0 
    + (3 * pow(1-t, 2) * P1) - (6 * t * (1-t) * P1)
    - (3 * pow(t,   2) * P2) + (6 * t * (1-t) * P2)
    +  3 * pow(t,   2) * P3;
}

- (double)angleForOffset:(double)t {  
  double dx = BezierPrime(t, P0_.x, P1_.x, P2_.x, P3_.x);
  double dy = BezierPrime(t, P0_.y, P1_.y, P2_.y, P3_.y);  
  return atan2(dy, dx);
}

static double Distance(CGPoint a, CGPoint b) {
  CGFloat dx = a.x - b.x;
  CGFloat dy = a.y - b.y;
  return hypot(dx, dy);
}

// Simplistic routine to find the offset along Bezier that is
// aDistance away from aPoint. anOffset is the offset used to
// generate aPoint, and saves us the trouble of recalculating it
// This routine just walks forward until it finds a point at least
// aDistance away. Good optimizations here would reduce the number
// of guesses, but this is tricky since if we go too far out, the
// curve might loop back on leading to incorrect results. Tuning
// kStep is good start.
- (double)offsetAtDistance:(double)aDistance 
                 fromPoint:(CGPoint)aPoint
                    offset:(double)anOffset {
  const double kStep = 0.001; // 0.0001 - 0.001 work well
  double newDistance = 0;
  double newOffset = anOffset + kStep;
  while (newDistance <= aDistance && newOffset < 1.0) {
    newOffset += kStep;
    newDistance = Distance(aPoint, 
                           [self pointForOffset:newOffset]);
  }
  return newOffset;
}

- (void)prepareContext:(CGContextRef)context forRun:(CTRunRef)run {
  CFDictionaryRef attributes = CTRunGetAttributes(run);

  // Set font
  CTFontRef runFont = CFDictionaryGetValue(attributes, 
                                           kCTFontAttributeName);
  CGFontRef cgFont = CTFontCopyGraphicsFont(runFont, NULL);
  CGContextSetFont(context, cgFont);
  CGContextSetFontSize(context, CTFontGetSize(runFont));
  CFRelease(cgFont);
  
  // Set color
  CGColorRef color = (CGColorRef)CFDictionaryGetValue(attributes,
                                  kCTForegroundColorAttributeName);
  CGContextSetFillColorWithColor(context, color);
}

- (NSMutableData *)glyphDataForRun:(CTRunRef)run {
  NSMutableData *data;
  CFIndex glyphsCount = CTRunGetGlyphCount(run);
  const CGGlyph *glyphs = CTRunGetGlyphsPtr(run);
  size_t dataLength = glyphsCount * sizeof(*glyphs);
  if (glyphs) {
    data = [NSMutableData dataWithBytesNoCopy:(void*)glyphs 
                                length:dataLength freeWhenDone:NO];
  }
  else {
    data = [NSMutableData dataWithLength:dataLength];
    CTRunGetGlyphs(run, CFRangeMake(0, 0), data.mutableBytes);
  }
  return data;
}

- (NSMutableData *)advanceDataForRun:(CTRunRef)run {
  NSMutableData *data;
  CFIndex glyphsCount = CTRunGetGlyphCount(run);
  const CGSize *advances = CTRunGetAdvancesPtr(run);
  size_t dataLength = glyphsCount * sizeof(*advances);
  if (advances) {
    data = [NSMutableData dataWithBytesNoCopy:(void*)advances
                                       length:dataLength
                                 freeWhenDone:NO];
  }
  else {
    data = [NSMutableData dataWithLength:dataLength];
    CTRunGetAdvances(run, CFRangeMake(0, 0), data.mutableBytes);
  }
  return data;
}

- (void)drawText {
  if ([self.attributedString length] == 0) { return; }
  
  // Initialize the text matrix (transform). This isn't reset
  // automatically, so it might be in any state.  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);

  // Create a typeset line object
  CTLineRef line = CTLineCreateWithAttributedString(
                        (__bridge CFTypeRef)self.attributedString);
  
  // The offset is where you are in the curve, from [0, 1]
  double offset = 0.;
  
  // Fetch the runs and process one at a time
  CFArrayRef runs = CTLineGetGlyphRuns(line);
  CFIndex runCount = CFArrayGetCount(runs);
  for (CFIndex runIndex = 0; runIndex < runCount; ++runIndex) {
    CTRunRef run = CFArrayGetValueAtIndex(runs, runIndex);

    // Apply the attributes from the run to the current context
    [self prepareContext:context forRun:run];
    
    // Fetch the glyphs as a CGGlyph* array
    NSMutableData *glyphsData = [self glyphDataForRun:run];
    CGGlyph *glyphs = [glyphsData mutableBytes];

    // Fetch the advances as a CGSize* array. An advance is the
    // distance from one glyph to another.
    NSMutableData *advancesData = [self advanceDataForRun:run];
    CGSize *advances = [advancesData mutableBytes];
    
    // Loop through the glyphs and display them
    CFIndex glyphCount = CTRunGetGlyphCount(run);
    for (CFIndex glyphIndex = 0;
         glyphIndex < glyphCount && offset < 1.0; 
         ++glyphIndex) {

      // You're going to modify the transform, so save the state
      CGContextSaveGState(context);

      // Calculate the location and angle. This could be any
      // function, but here you use a Bezier curve
      CGPoint glyphPoint = [self pointForOffset:offset];      
      double angle = [self angleForOffset:offset];
      
      // Rotate the context
      CGContextRotateCTM(context, angle);

      // Translate the context after accounting for rotation
      CGPoint 
      translatedPoint = CGPointApplyAffineTransform(glyphPoint,
                            CGAffineTransformMakeRotation(-angle));
      CGContextTranslateCTM(context,
                            translatedPoint.x, translatedPoint.y);      

      // Draw the glyph
      CGContextShowGlyphsAtPoint(context, 0, 0,
                                 &glyphs[glyphIndex], 1);
      
      // Move along the curve in proportion to the advance.
      offset = [self offsetAtDistance:advances[glyphIndex].width
                            fromPoint:glyphPoint offset:offset];
      CGContextRestoreGState(context);
    }
  }
}

- (void)drawRect:(CGRect)rect {
  [self drawPath];
  [self drawText];
}

@end
