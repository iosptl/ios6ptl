//
//  RunLoopThread.h
//  SimpleThread
//
//  Created by Rob Napier on 8/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CounterThread.h"

@interface RunLoopThread : CounterThread
@property (strong, nonatomic) NSTimer *timer;
@end
