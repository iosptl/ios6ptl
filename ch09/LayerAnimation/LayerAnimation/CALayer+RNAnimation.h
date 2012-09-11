//
//  CALayer+RNAnimation.h
//  Actions
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (RNAnimation)
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath
        duration:(CFTimeInterval)duration
           delay:(CFTimeInterval)delay;
@end
