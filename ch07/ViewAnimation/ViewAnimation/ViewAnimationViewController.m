//
//  ViewAnimationViewController.m
//  ViewAnimation
//

#import "ViewAnimationViewController.h"
#import "CircleView.h"

@implementation ViewAnimationViewController
@synthesize circleView = circleView_;

- (void)viewDidLoad {
  [super viewDidLoad];
  self.circleView = [[CircleView alloc] initWithFrame:
                     CGRectMake(0, 0, 20, 20)];
  self.circleView.center = CGPointMake(100, 20);
  [[self view] addSubview:self.circleView];
  
  UITapGestureRecognizer *g;
  g = [[UITapGestureRecognizer alloc]
       initWithTarget:self
       action:@selector(dropAnimate:)];
  [[self view] addGestureRecognizer:g];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  self.circleView = nil;
}

- (void)dropAnimate:(UIGestureRecognizer *)recognizer {
  [UIView
   animateWithDuration:3 animations:^{
     recognizer.enabled = NO;
     self.circleView.center = CGPointMake(100, 300);
   }
   completion:^(BOOL finished){
     [UIView 
      animateWithDuration:1 animations:^{
        self.circleView.center = CGPointMake(250, 300);
      }
      completion:^(BOOL finished){
        recognizer.enabled = YES;
      }
      ];
   }];
}

@end
