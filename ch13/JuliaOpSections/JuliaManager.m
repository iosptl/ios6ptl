//
//  JuliaManager.m
//  JuliaOpSections
//
//  Created by Rob Napier on 8/9/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "JuliaManager.h"

@interface JuliaManager ()
@property (nonatomic, readwrite, strong) NSOperationQueue *queue;
@property (nonatomic, readwrite, strong) NSCache *cache;
@end

@implementation JuliaManager

- (JuliaManager *)initWithSize:(CGSize)aSize {
  self = [super init];
  if (self) {
    _size = aSize;
    _queue = [[NSOperationQueue alloc] init];
    _cache = [NSCache new];
  }
  return self;
}

- (NSOperation *)operationForScale:(CGFloat)scale
                                 seeds:(NSArray *)seeds {

  NSBlockOperation *op = [[NSBlockOperation alloc] init];

  for (NSNumber *seed in seeds) {
    Julia *julia = [self juliaWithSeed:[seed unsignedIntegerValue]];
    if (julia.scale < scale) {
      [op addExecutionBlock:^{
        [julia updateImageForScale:scale];
      }];
    }
  }
//  
//  JuliaOperation *op = [[JuliaOperation alloc] init];
//  op.contentScaleFactor = scale;
//
//  CGRect bounds = self.bounds;
//  op.width = (unsigned)(CGRectGetWidth(bounds) * scale);
//  op.height = (unsigned)(CGRectGetHeight(bounds) * scale);
//
//  srandom(seed);
//
//  op.c = (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;
//  op.blowup = random();
//  op.rScale = random() % 20;  // Biased, but simple is more important
//  op.gScale = random() % 20;
//  op.bScale = random() % 20;
//
//  __weak JuliaOperation *weakOp = op;
//  op.completionBlock = ^{
//    if (! weakOp.isCancelled) {
//      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//        JuliaOperation *strongOp = weakOp;
//        if (strongOp && [self.operations containsObject:strongOp]) {
//          self.imageView.image = strongOp.image;
//          self.label.text = strongOp.description;
//          [self.operations removeObject:strongOp];
//        }
//      }];
//    }
//  };
//
//  if (scale < 0.5) {
//    op.queuePriority = NSOperationQueuePriorityVeryHigh;
//  }
//  else if (scale <= 1) {
//    op.queuePriority = NSOperationQueuePriorityHigh;
//  }
//  else {
//    op.queuePriority = NSOperationQueuePriorityNormal;
//  }
//
//  return op;
}

- (Julia *)juliaWithSeed:(NSUInteger)seed {
  Julia *julia = [self.cache objectForKey:@(seed)];
  if (! julia) {
    julia = [[Julia alloc] initWithSeed:seed size:self.size];
  }
  return julia;
}

- (void)updateImagesForSeeds:(NSArray *)seeds {
  NSUInteger kIterations = 6;

  CGFloat maxScale = [[UIScreen mainScreen] scale];
  CGFloat minScale = maxScale/pow(2, kIterations);

  NSOperation *prevOp;
  for (CGFloat scale = minScale; scale <= maxScale; scale *= 2) {
    NSOperation *op = [self operationForScale:scale seeds:seeds];
    if (prevOp) {
      [op addDependency:prevOp];
    }
    [self.queue addOperation:op];
    prevOp = op;
  }
}

@end
