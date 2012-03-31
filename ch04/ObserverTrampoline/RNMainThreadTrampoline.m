//
//  MainThreadTrampoline.m
//  
//
//  Created by Rob Napier on 9/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RNMainThreadTrampoline.h"

@implementation RNMainThreadTrampoline
@synthesize target = target_;

- (id)initWithTarget:(id)aTarget {
	if ((self = [super init])) {
		target_ = aTarget;
	}
	return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
	return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	[invocation setTarget:self.target];
  [invocation retainArguments];
	[invocation performSelectorOnMainThread:@selector(invoke)
                               withObject:nil
                            waitUntilDone:NO];
}

@end