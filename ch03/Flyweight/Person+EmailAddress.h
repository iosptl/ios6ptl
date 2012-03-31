//
//  Person+EmailAddress.h
//  Flyweight
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@interface Person (EmailAddress)
@property (readwrite, copy) NSString *emailAddress;
@end
