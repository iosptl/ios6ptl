//
//  GraphView.m
//  Graph
//

#import "GraphView.h"

@implementation GraphView
@synthesize values=values_;
@synthesize timer=timer_;

const double kXScale = 5.0;
const double kYScale = 100.0;

static inline CGAffineTransform
CGAffineTransformMakeScaleTranslate(CGFloat sx, CGFloat sy,
                                    CGFloat dx, CGFloat dy)
{
  return CGAffineTransformMake(sx, 0.f, 0.f, sy, dx, dy);
}

- (void)awakeFromNib {
  [self setContentMode:UIViewContentModeRight];
  values_ = [NSMutableArray array];
  timer_ = [NSTimer scheduledTimerWithTimeInterval:0.25
                                            target:self 
                                          selector:@selector(updateValues:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)updateValues:(NSTimer *)timer {
  double nextValue = sin(CFAbsoluteTimeGetCurrent())
                      + ((double)rand()/(double)RAND_MAX);
  [self.values addObject:
                    [NSNumber numberWithDouble:nextValue]];
  CGSize size = self.bounds.size;
  CGFloat maxDimension = MAX(size.height, size.width);
  NSUInteger maxValues =
                  floorl(maxDimension / kXScale);

  if ([self.values count] > maxValues) {
    [self.values removeObjectsInRange:
     NSMakeRange(0, [self.values count] - maxValues)];
  }
  
  [self setNeedsDisplay];
}

- (void)dealloc {
  [timer_ invalidate];
}

- (void)drawRect:(CGRect)rect {
  if ([self.values count] == 0) {
    return;
  }
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();  
  CGContextSetStrokeColorWithColor(ctx, 
                             [[UIColor redColor] CGColor]);
  CGContextSetLineJoin(ctx, kCGLineJoinRound);
  CGContextSetLineWidth(ctx, 5);

  CGMutablePathRef path = CGPathCreateMutable();
  
  CGFloat yOffset = self.bounds.size.height / 2;
  CGAffineTransform transform = 
  CGAffineTransformMakeScaleTranslate(kXScale, kYScale,
                                      0, yOffset);
  
  double y = [[self.values objectAtIndex:0] doubleValue];
  CGPathMoveToPoint(path, &transform, 0, y);
  
  for (NSUInteger x = 1; x < [self.values count]; ++x) {
    y = [[self.values objectAtIndex:x] doubleValue];
    CGPathAddLineToPoint(path, &transform, x, y);
  }

  CGContextAddPath(ctx, path);
  CGPathRelease(path);
  CGContextStrokePath(ctx);
}

@end
