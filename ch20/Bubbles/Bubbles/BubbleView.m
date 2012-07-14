//
//  BubbleView.m
//  Bubbles
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "BubbleView.h"

static const NSUInteger kNumBubbles = 1000;
static const CGFloat kMinimumRadius = 4;
static const CGFloat kMaximumRadius = 30;

@interface Bubble : NSObject
@property CGPoint center;
@property CGFloat radius;
@property UIColor *color;
@property CGRect bounds;
@property NSInteger growing;
@property NSInteger driftX;
@property NSInteger driftY;
- (void)drift;
@end

@implementation Bubble
- (id)initInBounds:(CGRect)bounds
{
  self = [super init];
  if (self) {
    CGFloat centerX = [self randomIntegerBetween:0 and:CGRectGetWidth(bounds)];
    CGFloat centerY = [self randomIntegerBetween:0 and:CGRectGetHeight(bounds)];

    CGFloat radius = [self randomIntegerBetween:kMinimumRadius and:kMaximumRadius];
    self.bounds = bounds;
    self.center = CGPointMake(centerX, centerY);
    self.radius = radius;
    
    self.color = [UIColor colorWithRed:[self randomIntegerBetween:0 and:255]/255.0
                                   green:[self randomIntegerBetween:0 and:255]/255.0
                                    blue:[self randomIntegerBetween:0 and:255]/255.0
                                   alpha:[self randomIntegerBetween:0 and:10]/10.0];
    self.growing = 0;
    self.driftX = 0;
    self.driftY = 0;
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

- (void)drift {
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
@interface BubbleView ()
@property NSMutableArray *bubbles;
@property UILabel *fpsLabel;
@property NSDate *lastUpdate;
@end

@implementation BubbleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      _bubbles = [NSMutableArray new];
      for (NSUInteger i = 0; i <= kNumBubbles; i++) {
        [_bubbles addObject:[[Bubble alloc] initInBounds:self.bounds]];
      }
      _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
      _fpsLabel.opaque = NO;
      _fpsLabel.backgroundColor = [UIColor clearColor];
      _fpsLabel.font = [UIFont boldSystemFontOfSize:32.0];
      _fpsLabel.textColor = [UIColor whiteColor];
      [self addSubview:_fpsLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
  [[UIColor whiteColor] set];
  UIRectFill(self.bounds);
  
  for (NSUInteger i = 0; i <= kNumBubbles; i++) {
    Bubble *bubble = [self.bubbles objectAtIndex:i];
    CGRect rect = CGRectMake(bubble.center.x - bubble.radius,
                             bubble.center.y - bubble.radius,
                             bubble.radius * 2,
                             bubble.radius * 2);
    UIBezierPath *bubblePath = [UIBezierPath bezierPathWithOvalInRect:rect];
    [[bubble color] set];
    [bubblePath fill];
    
    [bubble drift];
  }
  
  NSTimeInterval drawTime = -[self.lastUpdate timeIntervalSinceNow];
  if (drawTime != 0) {
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS: %.0f", 1.0/drawTime];
  }
  self.lastUpdate = [NSDate date];
  dispatch_async(dispatch_get_main_queue(), ^{ [self setNeedsDisplay]; });
}

@end

