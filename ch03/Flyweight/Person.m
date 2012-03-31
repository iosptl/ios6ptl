//
//  Person.m
//  Flyweight
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize identifier=identifier_;
@synthesize name=name_;

- (Person *)initWithIdentifier:(NSString *)anIdentifier {
  if ((self = [super init])) {
    identifier_ = [anIdentifier copy];
  }
  return self;
}

@end
