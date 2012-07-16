//
//  MYNotificationCenter.m
//  ISASwizzle
//
//  Created by Rob Napier on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MYNotificationCenter.h"

@implementation MYNotificationCenter
- (void)addObserver:(id)observer selector:(SEL)aSelector
               name:(NSString *)aName object:(id)anObject
{
  NSLog(@"Adding observer: %@", observer);
  [super addObserver:observer selector:aSelector name:aName 
              object:anObject];
}
@end
