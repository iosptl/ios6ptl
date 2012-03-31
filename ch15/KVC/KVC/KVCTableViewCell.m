//
//  KVCTableViewCell.m
//

#import "KVCTableViewCell.h"

@implementation KVCTableViewCell
@synthesize target=target_;
@synthesize property=property_;

- (BOOL)isReady {
  // Only display something if configured
  return (self.target && [self.property length] > 0);
}

- (void)update {
  NSString *text;
  if (self.isReady) {
    // Ask the target for the value of its property that has the
    // name given in self.property. Then convert that into a human
    // readable string
    id value = [self.target valueForKeyPath:self.property];
    text = [value description];
  }
  else {
    text = @"";
  }
  self.textLabel.text = text;
}

- (id)initWithReuseIdentifier:(NSString *)identifier {
  return [self initWithStyle:UITableViewCellStyleDefault
             reuseIdentifier:identifier];
}

- (void)setTarget:(id)aTarget {
  target_ = aTarget;
  [self update];
}

- (void)setProperty:(NSString *)aProperty {
  property_ = aProperty;
  [self update];
}
@end