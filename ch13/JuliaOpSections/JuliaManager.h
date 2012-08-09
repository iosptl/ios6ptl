//
//  JuliaManager.h
//  JuliaOpSections
//
//  Created by Rob Napier on 8/9/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Julia.h"

@interface JuliaManager : NSObject
@property (nonatomic, readonly, assign) CGSize size;

- (JuliaManager *)initWithSize:(CGSize)size;
- (Julia *)juliaWithSeed:(NSUInteger)seed;
- (void)updateImagesForSeeds:(NSArray *)seeds;
@end
