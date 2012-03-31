//
//  BoxViewController.m
//  Box
//
//  Created by Rob Napier on 7/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoxViewController.h"

@implementation BoxViewController
@synthesize topLayer=topLayer_;
@synthesize bottomLayer=bottomLayer_;
@synthesize leftLayer=leftLayer_;
@synthesize rightLayer=rightLayer_;
@synthesize frontLayer=frontLayer_;
@synthesize backLayer=backLayer_;

const CGFloat kSize = 100.;
const CGFloat kPanScale = 1./100.;


- (CALayer *)layerWithColor:(UIColor *)color transform:(CATransform3D)transform {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [color CGColor];
  layer.bounds = CGRectMake(0, 0, kSize, kSize);
  layer.position = self.view.center;
  layer.transform = transform;
  [self.view.layer addSublayer:layer];
  return layer;
}

CATransform3D MakePerspetiveTransform(void);
CATransform3D MakePerspetiveTransform() {
  CATransform3D perspective = CATransform3DIdentity;
  perspective.m34 = -1./2000.;
  return perspective;
}

- (void)viewDidLoad
{
  CATransform3D transform;
  
  [super viewDidLoad];
  transform = CATransform3DMakeTranslation(0, -kSize/2, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
  self.topLayer = [self layerWithColor:[UIColor redColor] 
                             transform:transform];
  
  transform = CATransform3DMakeTranslation(0, kSize/2, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 1.0, 0, 0);
  self.bottomLayer = [self layerWithColor:[UIColor greenColor]
                                transform:transform];

  transform = CATransform3DMakeTranslation(kSize/2, 0, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
  self.rightLayer = [self layerWithColor:[UIColor blueColor] 
                               transform:transform];
  
  transform = CATransform3DMakeTranslation(-kSize/2, 0, 0);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
  self.leftLayer = [self layerWithColor:[UIColor cyanColor]
                              transform:transform];
  
  transform = CATransform3DMakeTranslation(0, 0, -kSize/2);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
  self.backLayer = [self layerWithColor:[UIColor yellowColor]
                              transform:transform];
  
  transform = CATransform3DMakeTranslation(0, 0, kSize/2);
  transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 0);
  self.frontLayer = [self layerWithColor:[UIColor magentaColor] 
                               transform:transform];

  self.view.layer.sublayerTransform = MakePerspetiveTransform();  
  
  UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] 
                            initWithTarget:self
                            action:@selector(pan:)];
  [self.view addGestureRecognizer:g];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self.view];
  CATransform3D transform = MakePerspetiveTransform();
  transform = CATransform3DRotate(transform, 
                                  kPanScale * translation.x,
                                  0, 1, 0);
  transform = CATransform3DRotate(transform,
                                  -kPanScale * translation.y,
                                  1, 0, 0);
  self.view.layer.sublayerTransform = transform;
}

@end
