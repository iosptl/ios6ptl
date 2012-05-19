//
//  DelegateView.m
//  Layers
//
//  Created by Rob Napier on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DelegateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation DelegateView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self.layer setNeedsDisplay];
  }
  return self;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  UIGraphicsPushContext(ctx);
  [[UIColor whiteColor] set];
  UIRectFill(layer.bounds);
  [[UIColor blackColor] set];
  UIFont *font = [UIFont systemFontOfSize:48.0];
  [@"Pushing The Limits" drawInRect:[layer bounds]
                           withFont:font
                      lineBreakMode:UILineBreakModeWordWrap
                          alignment:UITextAlignmentCenter];
  UIGraphicsPopContext();
}

@end
