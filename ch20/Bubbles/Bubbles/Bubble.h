//
//  Bubble.h
//  Bubbles
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bubble : NSObject
@property CGPoint center;
@property CGFloat radius;
@property UIColor *color;
@property CGRect bounds;
@property NSInteger growing;
@property NSInteger driftX;
@property NSInteger driftY;
- (id)initInBounds:(CGRect)bounds;
- (void)drift;
@end

