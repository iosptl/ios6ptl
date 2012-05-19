//
//  BoxTransformViewController.m
//  BoxTransform
//
//  Created by Rob Napier on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BoxTransformViewController.h"

@implementation BoxTransformViewController

@synthesize contentLayer=contentLayer_;
@synthesize topLayer=topLayer_;
@synthesize bottomLayer=bottomLayer_;
@synthesize leftLayer=leftLayer_;
@synthesize rightLayer=rightLayer_;
@synthesize frontLayer=frontLayer_;
@synthesize backLayer=backLayer_;

const CGFloat kSize = 100.;
const CGFloat kPanScale = 1./100.;


- (CALayer *)layerAtX:(CGFloat)x y:(CGFloat)y z:(CGFloat)z 
                color:(UIColor *)color
            transform:(CATransform3D)transform {
  CALayer *layer = [CALayer layer];
  layer.backgroundColor = [color CGColor];
  layer.bounds = CGRectMake(0, 0, kSize, kSize);
  layer.position = CGPointMake(x, y);
  layer.zPosition = z;
  layer.transform = transform;
  [self.contentLayer addSublayer:layer];
  return layer;
}

static CATransform3D MakeSideRotation(CGFloat x, CGFloat y, CGFloat z) {
  return CATransform3DMakeRotation(M_PI_2, x, y, z);
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  CATransformLayer *contentLayer = [CATransformLayer layer];
  contentLayer.frame = self.view.layer.bounds;
  CGSize size = contentLayer.bounds.size;
  contentLayer.transform = 
    CATransform3DMakeTranslation(size.width/2, size.height/2, 0);
  contentLayer.anchorPoint = CGPointMake(0.5, 0.75);
  [self.view.layer addSublayer:contentLayer];
  
  self.contentLayer = contentLayer;
  
  self.topLayer = [self layerAtX:0 y:-kSize/2 z:0
                           color:[UIColor redColor] 
                       transform:MakeSideRotation(1, 0, 0)];
  
  self.bottomLayer = [self layerAtX:0 y:kSize/2 z:0
                              color:[UIColor greenColor]
                          transform:MakeSideRotation(1, 0, 0)];
  
  self.rightLayer = [self layerAtX:kSize/2 y:0 z:0 
                             color:[UIColor blueColor] 
                         transform:MakeSideRotation(0, 1, 0)];
  
  self.leftLayer = [self layerAtX:-kSize/2 y:0 z:0
                            color:[UIColor cyanColor]
                        transform:MakeSideRotation(0, 1, 0)];
  
  self.backLayer = [self layerAtX:0 y:0 z:-kSize/2
                            color:[UIColor yellowColor]
                        transform:CATransform3DIdentity];
  
  self.frontLayer = [self layerAtX:0 y:0 z:kSize/2
                             color:[UIColor magentaColor] 
                         transform:CATransform3DIdentity];
  
  
  UIGestureRecognizer *g = [[UIPanGestureRecognizer alloc] 
                            initWithTarget:self
                            action:@selector(pan:)];
  [self.view addGestureRecognizer:g];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
  CGPoint translation = [recognizer translationInView:self.view];
  CATransform3D transform = CATransform3DIdentity;
  transform = CATransform3DRotate(transform, 
                                  kPanScale * translation.x,
                                  0, 1, 0);
  transform = CATransform3DRotate(transform,
                                  -kPanScale * translation.y,
                                  1, 0, 0);
  self.view.layer.sublayerTransform = transform;
}

@end
