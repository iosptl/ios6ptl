//
//  ViewController.m
//  SimpleOperation
//
//  Created by Rob Napier on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize label=label_;
@synthesize count=count_;
@synthesize queue=queue_;

- (void)addNextOperation {
  __block typeof(self) myself = self;
  NSOperation *op = [NSBlockOperation blockOperationWithBlock:^{
    [NSThread sleepForTimeInterval:1];
    myself.count = myself.count + 1;
  }];
  op.completionBlock = ^{[myself addNextOperation];};
  
  [self.queue addOperation:op];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.queue = [[NSOperationQueue alloc] init];
  self.count = 0;
  [self addNextOperation];
}

- (void)setCount:(NSUInteger)count {
  count_ = count;
  __block typeof(self) myself = self;
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    myself.label.text = [NSString stringWithFormat:@"%d", count];
  }];
}

- (NSUInteger)count {
  return count_;
}

- (void)viewDidUnload {
  self.queue.suspended = YES;
  self.queue = nil;
  [self setLabel:nil];
  [super viewDidUnload];
}


@end
