//
//  BubbleView.m
//  Bubbles
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "BubbleView.h"
#import "Bubble.h"
#import <objc/runtime.h>

static const NSUInteger kNumBubbles = 500;

@interface BubbleView ()
@property NSMutableArray *bubbles;
@property UILabel *fpsLabel;
@property NSDate *lastUpdate;
@end

@implementation BubbleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      _bubbles = [NSMutableArray new];
      for (NSUInteger i = 0; i <= kNumBubbles; i++) {
        Bubble *bubble = [[Bubble alloc] initInContainerBounds:self.bounds];
        [_bubbles addObject:bubble];
        [self.layer addSublayer:bubble];
      }
      _fpsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 100)];
      _fpsLabel.opaque = NO;
      _fpsLabel.backgroundColor = [UIColor clearColor];
      _fpsLabel.font = [UIFont boldSystemFontOfSize:32.0];
      _fpsLabel.textColor = [UIColor whiteColor];
      _fpsLabel.shadowColor = [UIColor blackColor];
      [self addSubview:_fpsLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//  [[UIColor whiteColor] set];
//  UIRectFill(self.bounds);
  
  for (NSUInteger i = 0; i <= kNumBubbles; i++) {
    Bubble *bubble = [self.bubbles objectAtIndex:i];
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

