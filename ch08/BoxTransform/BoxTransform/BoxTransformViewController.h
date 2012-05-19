//
//  BoxTransformViewController.h
//  BoxTransform
//
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BoxTransformViewController : UIViewController
@property (nonatomic, readwrite, strong) CALayer *contentLayer;
@property (nonatomic, readwrite, strong) CALayer *topLayer;
@property (nonatomic, readwrite, strong) CALayer *bottomLayer;
@property (nonatomic, readwrite, strong) CALayer *leftLayer;
@property (nonatomic, readwrite, strong) CALayer *rightLayer;
@property (nonatomic, readwrite, strong) CALayer *frontLayer;
@property (nonatomic, readwrite, strong) CALayer *backLayer;

@end
