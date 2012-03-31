//
//  main.m
//  Flyweight
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"
#import "Person+EmailAddress.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    Person *person = [[Person alloc] initWithIdentifier:@"someone"];
    person.name = @"A Name";
    person.emailAddress = @"myaddress@example.org";
  }
}
