//
//  LayerAnimationViewController.m
//  LayerAnimation
//
//  Created by Rob Napier on 7/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LayerAnimationViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation LayerAnimationViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  CALayer *squareLayer = [CALayer layer];
  squareLayer.backgroundColor = [[UIColor redColor] CGColor];
  squareLayer.frame = CGRectMake(100, 100, 20, 20);
  [self.view.layer addSublayer:squareLayer];

  UIView *squareView = [UIView new];
  squareView.backgroundColor = [UIColor blueColor];
  squareView.frame = CGRectMake(200, 100, 20, 20);
  [self.view addSubview:squareView];
  
  [self.view addGestureRecognizer:
   [[UITapGestureRecognizer alloc] 
    initWithTarget:self
    action:@selector(drop:)]];
}

- (void)drop:(UIGestureRecognizer *)recognizer {
  [CATransaction setAnimationDuration:2.0];
  NSArray *layers = self.view.layer.sublayers;
  CALayer *layer = [layers objectAtIndex:0];
  CGPoint toPoint = CGPointMake(200, 250);
  [layer setPosition:toPoint];

  CABasicAnimation *anim = [CABasicAnimation
                            animationWithKeyPath:@"opacity"];
  anim.fromValue = [NSNumber numberWithDouble:1.0];
  anim.toValue = [NSNumber numberWithDouble:0.0];
  anim.autoreverses = YES;
  anim.repeatCount = INFINITY;
  anim.duration = 2.0;
  [layer addAnimation:anim forKey:@"anim"]; 

  NSArray *views = self.view.subviews;
  UIView *view = [views objectAtIndex:0];
  [view setCenter:CGPointMake(100, 250)];
}

@end