//
//  ViewController.m
//  TimeConsuming
//
//  Created by Rob Napier on 9/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize activity=activity_;

- (void)somethingTimeConsuming {
  [NSThread sleepForTimeInterval:5];
}

- (IBAction)doSomething:(id)sender {
  [sender setEnabled:NO];
  [self.activity startAnimating];
  
  dispatch_queue_t bgQueue = dispatch_get_global_queue(
                                                       DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  
  dispatch_async(bgQueue, ^{
    [self somethingTimeConsuming];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.activity stopAnimating];
      [sender setEnabled:YES];
    });
  });
}

@end
