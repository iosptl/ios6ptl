//
//  RNObserverManager.m
//  ObserverTrampoline
//
//  Created by Rob Napier on 9/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RNObserverManager.h"

@interface RNObserverManager ()
@property (nonatomic, readonly, strong) NSMutableSet *observers;
@property (nonatomic, readonly, strong) Protocol *protocol;
@end

@implementation RNObserverManager

@synthesize observers = observers_;
@synthesize protocol = protocol_;

- (id)initWithProtocol:(Protocol *)protocol
             observers:(NSSet *)observers {
	if ((self = [super init])) {
		protocol_ = protocol;
		observers_ = [NSMutableSet setWithSet:observers];
	}
	return self;
}

- (void)addObserver:(id)observer {
  NSAssert([observer conformsToProtocol:self.protocol], 
           @"Observer must conform to protocol.");
	[self.observers addObject:observer];
}

- (void)removeObserver:(id)observer {
	[self.observers removeObject:observer];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
	NSMethodSignature *
  result = [super methodSignatureForSelector:sel];
  if (result) {
   return result; 
  }
  
  // Look for a required method
	struct objc_method_description desc = 
             protocol_getMethodDescription(self.protocol,
                                           sel, YES, YES);
	if (desc.name == NULL) {
		// Couldn't find it. Maybe it's optional
		desc = protocol_getMethodDescription(self.protocol,
                                         sel, NO, YES);
	}
  
	if (desc.name == NULL) {
    // Couldn't find it. Raise NSInvalidArgumentException
		[self doesNotRecognizeSelector:sel];
		return nil;
  }
  
  return [NSMethodSignature signatureWithObjCTypes:desc.types];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
	SEL selector = [invocation selector];
	for (id responder in self.observers) {
		if ([responder respondsToSelector:selector]) {
			[invocation setTarget:responder];
			[invocation invoke];
		}
	}
}

@end
