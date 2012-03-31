//
//  CacheProxy.m
//  Person
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CacheProxy.h"
#import <objc/runtime.h>

@implementation CacheProxy
@synthesize object = object_;
@synthesize valueForProperty = valueForProperty_;

// setFoo: => foo
static NSString *propertyNameForSetter(SEL selector) {
  NSMutableString *name =
  [NSStringFromSelector(selector) mutableCopy];
  [name deleteCharactersInRange:NSMakeRange(0, 3)];
  [name deleteCharactersInRange:
   NSMakeRange([name length] - 1, 1)];
  NSString *firstChar = [name substringToIndex:1];
  [name replaceCharactersInRange:NSMakeRange(0, 1)
                      withString:[firstChar lowercaseString]];
  return name;
}

// foo => setFoo:
static SEL setterForPropertyName(NSString *property) {
  NSMutableString *name = [property mutableCopy];
  NSString *firstChar = [name substringToIndex:1];
  [name replaceCharactersInRange:NSMakeRange(0, 1)
                      withString:[firstChar uppercaseString]];
  [name insertString:@"set" atIndex:0];
  [name appendString:@":"];
  return NSSelectorFromString(name);
}

// Getter implementation
static id propertyIMP(id self, SEL _cmd) {
  NSString *propertyName = NSStringFromSelector(_cmd);
  id value = [[self valueForProperty] valueForKey:propertyName];
  if (value == [NSNull null]) {
    return nil;
  }
  
  if (value) {
    return value;
  }
  
  value = [[self object] valueForKey:propertyName];
  [[self valueForProperty] setValue:value
                             forKey:propertyName];
  return value;
}

// Setter implementation
static void setPropertyIMP(id self, SEL _cmd, id aValue) {
  id value = [aValue copy];
  NSString *propertyName = propertyNameForSetter(_cmd);
  [[self valueForProperty] setValue:(value != nil ? value :
                                     [NSNull null])
                             forKey:propertyName];
  [[self object] setValue:value forKey:propertyName];
}

- (id)initWithObject:(id)anObject
          properties:(NSArray *)properties {
  object_ = anObject;
  valueForProperty_ = [[NSMutableDictionary alloc] init];
  for (NSString *property in properties) {
    // Synthesize a getter
    class_addMethod([self class],
                    NSSelectorFromString(property), 
                    (IMP)propertyIMP,
                    "@@:");
    // Synthesize a setter
    class_addMethod([self class], 
                    setterForPropertyName(property), 
                    (IMP)setPropertyIMP,
                    "v@:@");
  }
  return self;
}

- (NSString *)description {
  return [NSString stringWithFormat:@"%@ (%@)", 
          [super description], self.object];
}

- (BOOL)isEqual:(id)anObject {
  return [self.object isEqual:anObject];
}

- (NSUInteger)hash {
  return [self.object hash];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  return [self.object respondsToSelector:aSelector];
}

- (BOOL)isKindOfClass:(Class)aClass {
  return [self.object isKindOfClass:aClass];
}

- (id)forwardingTargetForSelector:(SEL)selector {
  return self.object;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
  return [self.object methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
  [anInvocation setTarget:self.object];
  [anInvocation invoke];
}
@end
