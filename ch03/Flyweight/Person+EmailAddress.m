//
//  Person+EmailAddress.m
//  Flyweight
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person+EmailAddress.h"

@implementation Person (EmailAddress)
static NSMutableDictionary *sEmailAddressForIdentifier = nil;

+ (void)load {
  sEmailAddressForIdentifier =
  [[NSMutableDictionary alloc] init];
}

- (NSString *)emailAddress {
  return [sEmailAddressForIdentifier
          objectForKey:[self identifier]];
}

- (void)setEmailAddress:(NSString *)anAddress {
  [sEmailAddressForIdentifier setObject:[anAddress copy]
                                 forKey:[self identifier]];
}
@end
