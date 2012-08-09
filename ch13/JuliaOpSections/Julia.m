//
//  Julia.m
//  JuliaOpSections
//
//  Created by Rob Napier on 8/9/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "Julia.h"

@interface Julia ()
@property (nonatomic, readwrite, strong) UIImage *image;
@end

@implementation Julia

- (NSString *)description
{
  return [NSString stringWithFormat:@"(%.3f, %.3f)@%.2f",
          creal(self.c), cimag(self.c), self.scale];
}

- (Julia *)initWithSeed:(NSUInteger)aSeed size:(CGSize)aSize {
  self = [super init];
  if (self) {
    _seed = aSeed;
    _size = aSize;

    srandom(aSeed);
    _c = (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;
    _blowup = random();
    _rScale = random() % 20;  // Biased, but simple is more important
    _gScale = random() % 20;
    _bScale = random() % 20;
  }
  return self;
}

- (void)updateImageForScale:(NSUInteger)scale {
  [self ]
}

@end
