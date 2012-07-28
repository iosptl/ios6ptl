//
//  main.m
//  Person
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Person.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    Person *person = [[Person alloc] init];
    [person setGivenName:@"Bob"];
    [person setSurname:@"Jones"];
    
    NSLog(@"%@ %@", [person givenName], [person surname]);
  }
}
