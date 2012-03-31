//
//  DecorationViewController.m
//  Decoration
//
//  Created by Rob Napier on 7/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DecorationViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation DecorationViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  CALayer *layer;
  layer = [CALayer layer];
  layer.frame = CGRectMake(100, 100, 100, 100);
  layer.cornerRadius = 10;
  layer.backgroundColor = [[UIColor redColor] CGColor];
  layer.borderColor = [[UIColor blueColor] CGColor];
  layer.borderWidth = 5;
  layer.shadowOpacity = 0.5;
  layer.shadowOffset = CGSizeMake(3.0, 3.0);
  [self.view.layer addSublayer:layer];
  
  layer = [CALayer layer];
  layer.frame = CGRectMake(150, 150, 100, 100);
  layer.cornerRadius = 10;
  layer.backgroundColor = [[UIColor greenColor] CGColor];
  layer.borderWidth = 5;
  layer.shadowOpacity = 0.5;
  layer.shadowOffset = CGSizeMake(3.0, 3.0);
  [self.view.layer addSublayer:layer];
  
}

@end
