//
//  ViewController.m
//  Bubbles
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  BubbleView *bubbleView = [[BubbleView alloc] initWithFrame:self.view.bounds];
  [self.view addSubview:bubbleView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return YES;
}

@end
