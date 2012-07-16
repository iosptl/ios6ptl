//
//  CacheProxy.h
//  Person
//
//  Created by Rob Napier on 8/22/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheProxy : NSProxy
- (id)initWithObject:(id)anObject
          properties:(NSArray *)properties;
@end

@interface CacheProxy ()
@property (readonly, strong) id object;
@property (readonly, strong)
NSMutableDictionary *valueForProperty;
@end
