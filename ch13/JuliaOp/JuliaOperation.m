//
//  JuliaOperation.m
//  Julia
//
//  Created by Rob Napier on 8/7/12.
//

#import "JuliaOperation.h"

@interface JuliaOperation ()
@property (nonatomic, readwrite, strong) UIImage *image;
@end

@implementation JuliaOperation


complex long double f(complex long double z, complex long double c) {
  return z*z + c;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"(%.3f, %.3f)", creal(self.c), cimag(self.c)];
}

- (void)main
{
  NSLog(@"Starting: %@", self);
  NSUInteger height = self.height;
  NSUInteger width = self.width;
  
  NSUInteger components = 4;
  uint8_t *bits = calloc(width * height * components, sizeof(*bits));
  
  complex long double c = self.c;
  long double blowup = self.blowup;
  double scale = 1.5;
  
  for (NSUInteger y = 0; y < height; ++y) {
    for (NSUInteger x = 0; x < width; ++x) {
      if (self.isCancelled) {
        NSLog(@"Cancelling: %@", self);
        return;
      }
      NSUInteger iteration = 0;
      complex long double z = (2.0 * scale * x)/width - scale
      + I*((2.0 * scale * y)/width - scale);
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
  
  self.image = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)
                                       scale:self.contentScaleFactor
                                 orientation:UIImageOrientationUp];
  free(bits);
  NSLog(@"Finishing: %@", self);
}

@end
