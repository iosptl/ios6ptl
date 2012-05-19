//
//  KVCTableViewCell.m
//  Chapter13
//

#import "KVCTableViewCell.h"

@implementation KVCTableViewCell
@synthesize target=target_;
@synthesize property=property_;

- (BOOL)isReady {
  return (self.target && [self.property length] > 0);
}

- (void)update {
  self.textLabel.text = self.isReady ?
  [[self.target valueForKeyPath:self.property] description]
  : @"";
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
  return [super initWithStyle:UITableViewCellStyleDefault
              reuseIdentifier:identifier];
}

- (void)removeObservation {
  if (self.isReady) {
    [self.target removeObserver:self 
                     forKeyPath:self.property];
  }
}

- (void)addObservation {
  if (self.isReady) {
    [self.target addObserver:self forKeyPath:self.property 
                     options:0 
                     context:(__bridge void*)self];
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
                      ofObject:(id)object 
                        change:(NSDictionary *)change 
                       context:(void *)context {
  if ((__bridge id)context == self) {
    // Our notification, not our superclass’s
      [self update];
  }
  else {
    [super observeValueForKeyPath:keyPath ofObject:object 
                           change:change context:context];
  }
}

- (void)dealloc {
  if (target_ && [property_ length] > 0) {
    [target_ removeObserver:self forKeyPath:property_];
  }
}

- (void)setTarget:(id)aTarget {
  [self removeObservation];
  target_ = aTarget;
  [self addObservation];
  [self update];
}

- (void)setProperty:(NSString *)aProperty {
  [self removeObservation];
  property_ = aProperty;
  [self addObservation];
  [self update];
}
@end