//
//  STViewController.m
//  SimpleThread
//
//  Created by Rob Napier on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "STViewController.h"
#import "SimpleCounterThread.h"
#import "RunLoopThread.h"

@implementation STViewController
@synthesize label=label_;
@synthesize count=count_;
@synthesize thread=thread_;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.count = 0;
//  self.thread = [[SimpleCounterThread alloc] initWithDelegate:self];
  self.thread = [[RunLoopThread alloc] initWithDelegate:self];
  [self.thread start];
}

// Thread-safe
- (NSUInteger)count {
  @synchronized(self) {
    return count_;
  }
}

// Thread-safe
- (void)setCount:(NSUInteger)count {
  @synchronized(self) {
    count_ = count;
    NSString *string = [NSString stringWithFormat:@"%d", count];
    [self.label performSelectorOnMainThread:@selector(setText:) 
                                 withObject:string
                              waitUntilDone:NO];
  }
}

- (void)setThread:(CounterThread *)thread {
  if (thread != thread_) {
    [thread_ stop];
    thread_ = thread;
  }
}

- (void)viewDidUnload {
  [self.thread stop];
  self.thread = nil;
}

@end
