//
//  JuliaCell.m
//  Julia
//
//  Created by Rob Napier on 8/6/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "JuliaCell.h"
#import <complex.h>

//const long double kBlowup = 3; //; 1e2466L; // ~ sqrt(LDBL_MAX)

@interface JuliaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, readwrite, assign) complex long double c;
@property (nonatomic, readwrite, assign) complex long double blowup;
@property (nonatomic, readwrite, assign) NSUInteger rScale;
@property (nonatomic, readwrite, assign) NSUInteger gScale;
@property (nonatomic, readwrite, assign) NSUInteger bScale;
@end

@implementation JuliaCell

complex long double f(complex long double z, complex long double c) {
  return z*z + c;
}

- (void)calculateImage {
  CGRect bounds = self.bounds;
  CGFloat minX = CGRectGetMinX(bounds);
  CGFloat minY = CGRectGetMinY(bounds);
  CGFloat maxX = CGRectGetMaxX(bounds);
  CGFloat maxY = CGRectGetMaxY(bounds);

  NSUInteger width = (unsigned)CGRectGetWidth(bounds);
  NSUInteger height = (unsigned)CGRectGetHeight(bounds);
  
  NSUInteger components = 4;
  uint8_t *bits = calloc(width * height * components, sizeof(*bits));

  complex long double c = self.c;
  long double blowup = self.blowup;
  double scale = 1.5;

  for (NSUInteger y = minY; y < maxY; ++y) {
    for (NSUInteger x = minX; x < maxX; ++x) {
      NSUInteger iteration = 0;
      complex long double z = (2.0 * scale * (x-minX))/width - scale
        + I*((2.0 * scale * (y - minY))/width - scale);
      while (cabsl(z) < blowup && iteration < 256) {
        z = f(z, c);
        ++iteration;
      }
      
      NSUInteger offset = (y * width * components) + (x * components);
      bits[offset+0] = (iteration * self.rScale);
      bits[offset+1] = (iteration * self.bScale);
      bits[offset+2] = (iteration * self.gScale);
    }
  }

  CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(bits,
                                               width,
                                               height,
                                               8,
                                               width * components,
                                               colorspace,
                                               kCGImageAlphaNoneSkipLast);
  CGColorSpaceRelease(colorspace);
  
  UIImage *image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
  self.imageView.image = image;
  free(bits);

}

- (void)configureWithSeed:(NSUInteger)seed
{  
  srandom(seed);
  
  self.c = (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;
  self.blowup = random();
  self.rScale = random() % 20;  // Biased, but repeatable and soimple is more important
  self.gScale = random() % 20;
  self.bScale = random() % 20;
  self.label.text = [NSString stringWithFormat:@"(%.3f, %.3f)",
                     creal(self.c), cimag(self.c)];
  [self calculateImage];
}

@end
