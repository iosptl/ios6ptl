//
//  JuliaCell.m
//  Julia
//
//  Created by Rob Napier on 8/6/12.
//

#import "JuliaCell.h"
#import "JuliaOperation.h"

@interface JuliaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, readwrite, strong) NSMutableArray *operations;
@end

@implementation JuliaCell

- (void)setJulia:(Julia *)aJulia {
  if (_julia) {
    [_julia removeObserver:self forKeyPath:@"image"];
  }
  
  _julia = aJulia;
  self.imageView.image = _julia.image;
  self.label.text = _julia.description;
  
  if (_julia) {
    [_julia addObserver:self forKeyPath:@"image" options:0 context:(__bridge void*)self];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
  if (context == (__bridge void*)self) {
    if ([keyPath isEqualToString:@"image"]) {
      Julia *julia = object;
      self.imageView.image = julia.image;
    }
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object
                           change:change context:context];
  }
}


- (void)prepareForReuse {
  self.julia = nil;
}

//
//- (void)awakeFromNib {
//  self.operations = [NSMutableArray new];
//}
//
//- (JuliaOperation *)operationForScale:(CGFloat)scale
//                                 seed:(NSUInteger)seed {
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
//}
//
//- (void)configureWithSeed:(NSUInteger)seed {
//
//  
//  
//  CGFloat maxScale = [[UIScreen mainScreen] scale];
//  self.contentScaleFactor = maxScale;
//
//  NSUInteger kIterations = 6;
//  CGFloat minScale = maxScale/pow(2, kIterations);
//
//  JuliaOperation *prevOp = nil;
//  for (CGFloat scale = minScale; scale <= maxScale; scale *= 2) {
//    JuliaOperation *op = [self operationForScale:scale seed:seed];
//    if (prevOp) {
//      [op addDependency:prevOp];
//    }
//    [self.operations addObject:op];
//    [queue addOperation:op];
//    prevOp = op;
//  }
//}
//
@end
