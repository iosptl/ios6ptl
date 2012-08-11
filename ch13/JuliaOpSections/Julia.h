//
//  Julia.h
//  JuliaOpSections
//
//  Created by Rob Napier on 8/9/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <complex.h>

@interface Julia : NSObject
@property (nonatomic, readonly) NSUInteger seed;
@property (nonatomic, readonly) CGSize size;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) complex long double c;
@property (nonatomic, readonly) complex long double blowup;
@property (nonatomic, readonly) NSUInteger rScale;
@property (nonatomic, readonly) NSUInteger gScale;
@property (nonatomic, readonly) NSUInteger bScale;
@property (nonatomic, readonly, strong) UIImage *image;

- (Julia *)initWithSeed:(NSUInteger)seed size:(CGSize)size;
- (void)updateImageForScale:(NSUInteger)scale;
@end
