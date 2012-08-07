//
//  JuliaCell.m
//  Julia
//
//  Created by Rob Napier on 8/6/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "JuliaCell.h"
#import "JuliaOperation.h"

@interface JuliaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, readwrite, strong) JuliaOperation *operation;
@end

@implementation JuliaCell

- (void)configureWithSeed:(NSUInteger)seed queue:(NSOperationQueue *)queue
{
  [self.operation cancel];
  self.imageView.image = nil;
  
  self.contentScaleFactor = [[UIScreen mainScreen] scale];
  
  JuliaOperation *op = [[JuliaOperation alloc] init];
  self.operation = op;
  op.contentScaleFactor = self.contentScaleFactor;
  
  CGRect bounds = self.bounds;
  op.width = (unsigned)(CGRectGetWidth(bounds) * self.contentScaleFactor);
  op.height = (unsigned)(CGRectGetHeight(bounds) * self.contentScaleFactor);
  
  srandom(seed);
  
  op.c = (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;
  self.label.text = op.description;
  
  op.blowup = random();
  op.rScale = random() % 20;  // Biased, but repeatable and simple is more important
  op.gScale = random() % 20;
  op.bScale = random() % 20;
  
  __weak typeof(self) weakSelf = self;
  __weak typeof(op) weakOp = op;
  op.completionBlock = ^{
    NSLog(@"Complete: %@", weakOp);
    if (! weakOp.isCancelled) {
      NSLog(@"Drawing: %@", weakOp);
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        weakSelf.imageView.image = weakOp.image;
      }];
    }
  };
  
  [queue addOperation:op];
}

@end
