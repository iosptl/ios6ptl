//
//  ViewController.m
//  SimpleGCD
//
//  Created by Rob Napier on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize label = label_;
@synthesize queue = queue_;
@synthesize count = count_;
@synthesize shouldRun = shouldRun_;

- (void)addNextOperation {
  __block typeof(self) myself = self;
  double delayInSeconds = 1.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 
                                          delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, self.queue, ^(void){
    myself.count = myself.count + 1;
    [self addNextOperation];
  });
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.queue = dispatch_queue_create("net.robnapier.SimpleGCD.ViewController",
                                     DISPATCH_QUEUE_CONCURRENT);
  self.count = 0;
  [self addNextOperation];
}

- (void)viewDidUnload {
  dispatch_suspend(self.queue);
  dispatch_release(self.queue);
  self.queue = nil;
  [self setLabel:nil];
  [super viewDidUnload];
}

- (NSUInteger)count {
  __block NSUInteger count;
	dispatch_sync(self.queue, ^{
		count = count_;
	});
	return count;
}

- (void)setCount:(NSUInteger)count {
  count_ = count;
  __block typeof(self) myself = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    myself.label.text = [NSString stringWithFormat:@"%d", count];
  });
}

static void q() {
  dispatch_queue_t low = dispatch_queue_create("low", 
                                               DISPATCH_QUEUE_SERIAL);
  dispatch_queue_t high = dispatch_queue_create("high",
                                                DISPATCH_QUEUE_SERIAL);
  dispatch_set_target_queue(low, high);

  // Dispatch a low-priority block:
  dispatch_async(low, ^{ /* Low priority block */ });
  

  // Dispatch a 
  dispatch_suspend(low);
  dispatch_async(high, ^{ 
    /* High priority block */
    dispatch_resume(low);
  });
  
  
  static char kMyKey;
//  char *data = malloc(5);
//  strncpy("test", data, 5);
  CFStringRef value = CFStringCreateWithCString(NULL, "Test", kCFStringEncodingUTF8);
  dispatch_queue_set_specific(low, &kMyKey, (void*)value, (dispatch_function_t)CFRelease);
}

@end
