//
//  FastCall.m
//  Runtime
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FastCall.h"

const NSUInteger kTotalCount = 100000000;

void FastCall() {
  NSMutableString *string = [NSMutableString string];
  NSTimeInterval totalTime = 0;
  NSDate *start = nil;
  NSUInteger count = 0;
  
  // With objc_msgSend
  start = [NSDate date];
  for (count = 0; count < kTotalCount; ++count) {
    [string setString:@"stuff"];
  }
  
  totalTime = -[start timeIntervalSinceNow];
  printf("w/ objc_msgSend = %f\n", totalTime);
  
  // Skip objc_msgSend.
  start = [NSDate date];
  SEL selector = @selector(setString:);
  IMP setStringMethod =[string methodForSelector:selector];
  
  for (count = 0; count < kTotalCount; ++count) {
    setStringMethod(string, selector, @"stuff");
  }
  
  totalTime = -[start timeIntervalSinceNow];
  printf("w/o objc_msgSend  = %f\n", totalTime);
}
