//
//  main.m
//  ISASwizzle
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+SetClass.h"
#import "MYNotificationCenter.h"

@interface Observer : NSObject
@end

@implementation Observer

- (void)somthingHappened:(NSNotification*)note {
  NSLog(@"Something happened");
}
@end

int main(int argc, char *argv[])
{
  int retVal = 0;
  @autoreleasepool {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc setClass:[MYNotificationCenter class]];
    Observer *observer = [[Observer alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:@selector(somthingHappened:)
                                                 name:@"SomethingHappenedNotification"
                                               object:nil];
  }
  return retVal;
}
