//
//  JuliaCell.m
//  Julia
//
//  Created by Rob Napier on 8/6/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "JuliaCell.h"
#import "JuliaCalculation.h"


@interface JuliaCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (nonatomic, readwrite, strong) dispatch_queue_t queue;
@property (nonatomic, readwrite, strong) NSMutableSet *calculations;
@end

@implementation JuliaCell

- (void)awakeFromNib {
  self.calculations = [NSMutableSet new];
  self.queue = dispatch_queue_create("JuliaCell", DISPATCH_QUEUE_SERIAL);
}

- (void)prepareForReuse {
  [self.calculations makeObjectsPerformSelector:@selector(cancel)];
  [self.calculations removeAllObjects];
  self.imageView.image = nil;
  self.label.text = @"";
}

- (dispatch_block_t)blockForScale:(CGFloat)scale seed:(NSUInteger)seed
{
  JuliaCalculation *calc = [[JuliaCalculation alloc] init];
  [self.calculations addObject:calc];
  calc.contentScaleFactor = scale;
  
  CGRect bounds = self.bounds;
  calc.width = (unsigned)(CGRectGetWidth(bounds) * scale);
  calc.height = (unsigned)(CGRectGetHeight(bounds) * scale);
  
  srandom(seed);
  
  calc.c = (long double)random()/LONG_MAX + I*(long double)random()/LONG_MAX;
  calc.blowup = random();
  calc.rScale = random() % 20;  // Biased, but repeatable and simple is more important
  calc.gScale = random() % 20;
  calc.bScale = random() % 20;
  
  __weak typeof(self) weakSelf = self;
  return ^{
    if ([calc run]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (!calc.isCancelled) {
//                         NSLog(@"Drawing: %@", calc);
          weakSelf.imageView.image = calc.image;
          weakSelf.label.text = calc.description;
        }
        else {
//                         NSLog(@"Cancelled early:%@", calc);
        }
      });
    }
  };
}

- (void)configureWithSeed:(NSUInteger)seed // queue:(NSOperationQueue *)queue
{
  CGFloat maxScale = [[UIScreen mainScreen] scale];
  self.contentScaleFactor = maxScale;
  
  NSUInteger kIterations = 6;
  JuliaCalculation *prevCalc = nil;
  
  for (CGFloat scale = maxScale/pow(2, kIterations); scale <= maxScale; scale *= 2) {
    dispatch_queue_priority_t priority = DISPATCH_QUEUE_PRIORITY_LOW;
    if (scale < 0.5) {
      priority = DISPATCH_QUEUE_PRIORITY_HIGH;
    }
    else if (scale < 1) {
      priority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
    }
        
    dispatch_queue_t queue = self.queue;
    dispatch_async(self.queue, ^{
      dispatch_set_target_queue(queue, dispatch_get_global_queue(priority, 0));
    });
    
    dispatch_async(self.queue, [self blockForScale:scale seed:seed]);
  }
}

//- (void)dealloc {
//  NSLog(@"Cell dealloc");
//}

@end
