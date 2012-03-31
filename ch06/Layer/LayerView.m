//
//  LayerView.m
//  Layer
//
//  Created by Rob Napier on 7/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LayerView.h"

@implementation LayerView

- (void)drawRect:(CGRect)rect {
  static CGLayerRef sTextLayer = NULL;

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  
  if (sTextLayer == NULL) {
    CGRect textBounds = CGRectMake(0, 0, 200, 100);
    sTextLayer = CGLayerCreateWithContext(ctx, 
                                          textBounds.size, 
                                          NULL);

    CGContextRef textCtx = CGLayerGetContext(sTextLayer);
    CGContextSetRGBFillColor (textCtx, 1.0, 0.0, 0.0, 1);
    UIGraphicsPushContext(textCtx);
    UIFont *font = [UIFont systemFontOfSize:13.0];
    [@"Pushing The Limits" drawInRect:textBounds 
                             withFont:font];
    UIGraphicsPopContext();
  }
  
  CGContextTranslateCTM(ctx, self.bounds.size.width / 2,
                        self.bounds.size.height / 2);
  
  for (NSUInteger i = 0; i < 10; ++i) {
    CGContextRotateCTM(ctx, 2 * M_PI / 10);
    CGContextDrawLayerAtPoint(ctx, 
                              CGPointZero,
                              sTextLayer);
  }
}

@end
