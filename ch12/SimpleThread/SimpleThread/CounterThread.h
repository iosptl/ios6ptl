//
//  CounterThread.h
//  SimpleThread
//
//  Created by Rob Napier on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CounterThreadDelegate <NSObject>
@property (assign) NSUInteger count;
@end

@interface CounterThread : NSThread
@property (strong) id<CounterThreadDelegate> delegate;
@property (assign) BOOL shouldRun;

- (CounterThread *)initWithDelegate:(id)delegate;

- (void)stop;

// Methods for our subclasses
- (void)processThread;
- (void)updateDelegate;

@end
