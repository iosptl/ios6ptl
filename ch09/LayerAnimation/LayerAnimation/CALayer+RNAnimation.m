//
//  CALayer+RNAnimation.m
//  Actions
//
//  Created by Rob Napier on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CALayer+RNAnimation.h"

@implementation CALayer (CALayer_RNAnimation)

- (void)setValue:(id)value
      forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay {
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  [self setValue:value forKeyPath:keyPath];
  CABasicAnimation *anim;
  anim = [CABasicAnimation animationWithKeyPath:keyPath];
  anim.duration = duration;
  anim.beginTime = CACurrentMediaTime() + delay;
  anim.fillMode = kCAFillModeBoth;
  anim.fromValue = [[self presentationLayer] valueForKey:keyPath];
  anim.toValue = value;
  [self addAnimation:anim forKey:keyPath];
  [CATransaction commit];
}

@end
