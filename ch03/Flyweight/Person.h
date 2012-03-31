//
//  Person.h
//  Flyweight
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (readonly, copy) NSString *identifier;
@property (readwrite, copy) NSString *name;

- (Person *)initWithIdentifier:(NSString *)anIdentifier;
@end
