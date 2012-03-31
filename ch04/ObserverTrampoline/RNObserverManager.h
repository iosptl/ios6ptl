//
//  RNObserverManager.h
//  ObserverTrampoline
//
//  Created by Rob Napier on 9/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/*
 Trampoline to simplify sending messages to responding targets. In
 order to call -someClass:didSomethingToObject: (from the 
 <SomeClass> protocol) on all your observers who implement it:
 
 id observerManager =
   [[RNObserverManager alloc]
     initWithProtocol:@protocol(SomeClassListener)
            observers:observers];
 [observerManager someClass:self didSomethingToObject:someObject];
 
 The message *must* be part of the given protocol. It is safe to
 reuse this trampoline. Generally if you do this, you will want to
 store it as an "id" so that you can pass arbitrary messages to it.
*/

@interface RNObserverManager : NSObject

- (id)initWithProtocol:(Protocol *)protocol
             observers:(NSSet *)observers;
- (void)addObserver:(id)observer;
- (void)removeObserver:(id)observer;

@end
