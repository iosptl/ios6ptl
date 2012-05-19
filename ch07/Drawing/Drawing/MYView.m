//
//  MYSmarterView.m
//  Drawing
//
//  Created by Rob Napier on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MYView.h"

@implementation MYView

- (UIImage *)reverseImageForText:(NSString *)text {
  const size_t kImageWidth = 200;
  const size_t kImageHeight = 200;
  CGImageRef textImage = NULL;
  UIFont *font = [UIFont boldSystemFontOfSize:17.0];
    
  UIGraphicsBeginImageContext(CGSizeMake(kImageWidth, kImageHeight));  
  [[UIColor redColor] set];
  [text drawInRect:CGRectMake(0, 0, kImageWidth, kImageHeight)
          withFont:font];

  textImage = UIGraphicsGetImageFromCurrentImageContext().CGImage;
  
  UIGraphicsEndImageContext();
  
  return [UIImage imageWithCGImage:textImage
                             scale:1.0
                 orientation:UIImageOrientationUpMirrored];
}

- (void)drawRect:(CGRect)rect {
  [[UIColor colorWithRed:0 green:0 blue:1 alpha:0.1] set];
  // Generate a bitmap, reverse it and draw it
  [[self reverseImageForText:@"Hello World"] drawAtPoint:CGPointMake(50, 150)];
  UIRectFillUsingBlendMode(CGRectMake(100, 100, 100, 100),kCGBlendModeNormal);
}


@end
