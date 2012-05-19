//
//  FlowerTransformView.m
//  Transforms
//
//  Created by Rob Napier on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FlowerTransformView.h"

@implementation FlowerTransformView

- (void)awakeFromNib {
  self.contentMode = UIViewContentModeRedraw;
}

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                    CGFloat dx, CGFloat dy)
{
  return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

- (void)drawRect:(CGRect)rect { 
  CGSize size = self.bounds.size;
  CGFloat margin = 10;

  [[UIColor redColor] set];
  UIBezierPath *path = [UIBezierPath bezierPath];
  [path addArcWithCenter:CGPointMake(0, -1)
                  radius:1
              startAngle:-M_PI
                endAngle:0
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(1, 0)
                  radius:1
              startAngle:-M_PI_2
                endAngle:M_PI_2
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(0, 1)
                  radius:1
              startAngle:0
                endAngle:M_PI
               clockwise:YES];
  [path addArcWithCenter:CGPointMake(-1, 0)
                  radius:1
              startAngle:M_PI_2
                endAngle:-M_PI_2
               clockwise:YES];
  
  CGFloat scale = floor((MIN(size.height, size.width)
                         - margin) / 4);
  
  CGAffineTransform transform;
  transform = CGAffineTransformMakeScaleTranslate(scale, 
                                                  scale,
                                              size.width/2,
                                            size.height/2);
  [path applyTransform:transform];
  [path fill];
}


@end
