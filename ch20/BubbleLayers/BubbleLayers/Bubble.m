//
//  Bubble.m
//  Bubbles
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "Bubble.h"

static const CGFloat kMinimumRadius = 4;
static const CGFloat kMaximumRadius = 30;

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                    CGFloat dx, CGFloat dy)
{
  return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}


@implementation Bubble
@synthesize center=_center;
@synthesize radius = _radius;

- (id)initInContainerBounds:(CGRect)bounds
{
  self = [super init];
  if (self) {
    self.opaque = YES;
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-0.5, -0.5, 1, 1)].CGPath;

    CGFloat centerX = [self randomIntegerBetween:0 and:CGRectGetWidth(bounds)];
    CGFloat centerY = [self randomIntegerBetween:0 and:CGRectGetHeight(bounds)];
    CGFloat radius = [self randomIntegerBetween:kMinimumRadius and:kMaximumRadius];

    self.center = CGPointMake(centerX, centerY);
    self.radius = radius;
    
    self.fillColor = [UIColor colorWithRed:[self randomIntegerBetween:0 and:255]/255.0
                                 green:[self randomIntegerBetween:0 and:255]/255.0
                                  blue:[self randomIntegerBetween:0 and:255]/255.0
                                 alpha:[self randomIntegerBetween:0 and:10]/10.0].CGColor;
    self.growing = 0;
    self.driftX = 0;
    self.driftY = 0;
    [self setNeedsDisplay];
  }
  return self;
}

- (NSInteger)adjustDrift:(NSInteger)oldDrift {
  NSInteger driftAdjust = [self randomIntegerBetween:0 and:100];
  if (driftAdjust == 0) {
    return -1;
  }
  else if (driftAdjust == 1) {
    return 1;
  }
  else {
    return oldDrift;
  }
}

- (void)updateTransform
{
  self.affineTransform = CGAffineTransformMakeScaleTranslate(self.radius/4, self.radius/4, self.center.x, self.center.y);
}

- (CGPoint)center
{
  return _center;
}

- (void)setCenter:(CGPoint)center {
  _center = center;
  [self updateTransform];
}

- (CGFloat)radius
{
  return _radius;
}

- (void)setRadius:(CGFloat)radius {
  _radius = radius;
  [self updateTransform];
}

- (void)drift {
  [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];

  self.driftX = [self adjustDrift:self.driftX];
  self.driftY = [self adjustDrift:self.driftY];
  self.growing = [self adjustDrift:self.growing];
  
  CGPoint center = self.center;
  center.x += self.driftX;
  center.y += self.driftY;
  self.center = center;
  
  self.radius += self.growing;
}

- (BOOL)randomBOOL {
  return (arc4random_uniform(2) == 1);
}

- (NSUInteger)randomIntegerBetween:(NSUInteger)min and:(NSUInteger)max {
  return arc4random_uniform(max - min) + min;
}

@end