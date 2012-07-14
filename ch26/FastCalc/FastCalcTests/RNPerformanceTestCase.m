//
//  RNPerformanceTestCase.m
//  
//
//  Created by Rob Napier on 7/14/12.
//
//

#import "RNPerformanceTestCase.h"
#import "RNPerformanceTestObserver.h"

static RNPerformanceTestObserver *observer;

@implementation RNPerformanceTestCase

+ (void)initialize {
  if (self == [RNPerformanceTestCase class]) {
    observer = [RNPerformanceTestObserver new];
  }
}

- (void)setUp {
  _startTime = CACurrentMediaTime();
}

- (void)tearDown {
  _stopTime = CACurrentMediaTime();
}

@end
