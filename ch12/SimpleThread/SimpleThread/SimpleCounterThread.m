//
//  SimpleCounterThread.m
//  SimpleThread
//
//  Created by Rob Napier on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SimpleCounterThread.h"

@implementation SimpleCounterThread

- (void)processThread {
  [NSThread sleepForTimeInterval:1];
  [self updateDelegate];
}

@end
