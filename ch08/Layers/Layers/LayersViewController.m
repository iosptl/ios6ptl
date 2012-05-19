//
//  LayersViewController.m
//  Layers
//

#import "LayersViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DelegateView.h"

@implementation LayersViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIImage *image = [UIImage imageNamed:@"pushing.png"];
  self.view.layer.contents = (__bridge id)[image CGImage];
  
  UIGestureRecognizer *g;
  g = [[UITapGestureRecognizer alloc] 
       initWithTarget:self
       action:@selector(performFlip:)];
  [self.view addGestureRecognizer:g];
}

- (void)performFlip:(UIGestureRecognizer *)recognizer {
  UIView *delegateView = [[DelegateView alloc] initWithFrame:self.view.frame];
  [UIView transitionFromView:self.view toView:delegateView duration:1 options:UIViewAnimationOptionTransitionFlipFromRight completion:nil];
}

@end
