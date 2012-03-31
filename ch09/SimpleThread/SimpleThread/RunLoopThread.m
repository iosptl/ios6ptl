//
//  RunLoopThread.m
//  SimpleThread
//
//  Created by Rob Napier on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RunLoopThread.h"

@implementation RunLoopThread
@synthesize timer=timer_;

- (void)processThread {
  if (! self.timer) {
    self.timer = [NSTimer 
                  scheduledTimerWithTimeInterval:1
                  target:self
                  selector:@selector(updateDelegate)
                  userInfo:nil
                  repeats:YES];
  }
  
  NSRunLoop *runLoop = [NSRunLoop currentRunLoop];

  [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}

- (void)setTimer:(NSTimer *)timer {
  if (timer != timer_) {
    [timer_ invalidate];
    timer_ = timer;
  }
}

- (void)dealloc {
  [timer_ invalidate], timer_ = nil;
}

@end
