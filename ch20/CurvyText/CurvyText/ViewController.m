//
//  ViewController.m
//  CurvyText
//
//  Created by Rob Napier on 8/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "CurvyTextView.h"
#import <CoreText/CoreText.h>

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  CurvyTextView *curvyTextView = [[CurvyTextView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:curvyTextView];
  
  NSMutableAttributedString *attrString =
  [[NSMutableAttributedString alloc] initWithString:
   @"You can display text along a curve, with fi "
   @"ligatures, bold, color, and big text."
   ];
  
  // Set the base font
  [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, [attrString length])];
  [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16.0] range:[attrString.string rangeOfString:@"bold"]];
  [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[attrString.string rangeOfString:@"color"]];
  [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:36.0] range:[attrString.string rangeOfString:@"big text"]];

  curvyTextView.attributedString = attrString;
}

@end
