//
//  Bubble.h
//  Bubbles
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bubble : CAShapeLayer
@property CGPoint center;
@property CGFloat radius;
//@property UIColor *color;
@property CGRect containerBounds;
@property NSInteger growing;
@property NSInteger driftX;
@property NSInteger driftY;
- (id)initInContainerBounds:(CGRect)containerBounds;
- (void)drift;
@end

