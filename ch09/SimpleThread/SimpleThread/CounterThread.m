//
//  CounterThread.m
//  SimpleThread
//
//  Created by Rob Napier on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CounterThread.h"

@implementation CounterThread
@synthesize delegate=delegate_;
@synthesize shouldRun=shouldRun_;

- (CounterThread *)initWithDelegate:(id)delegate {
  if ((self = [super init])) {
    self.delegate = delegate;
  }
  return self;
}

- (void)stop {
  self.shouldRun = NO;
}

- (void)processThread {
  // Subclasses must override and call updateDelegate
  NSAssert(NO, @"Abstract method. Must be overridden");
}

- (void)updateDelegate {
  // Whatever interesting work we want to do.
  // This call is made on a background thread, so make sure
  // it’s threadsafe
  self.delegate.count = self.delegate.count + 1;
}

- (void)main {
  @autoreleasepool {
    self.shouldRun = YES;
    while (self.shouldRun) {
      @autoreleasepool {
        [self processThread];
      }
    }
  }
}

@end
