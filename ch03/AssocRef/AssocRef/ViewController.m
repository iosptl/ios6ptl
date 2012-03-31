//
//  ViewController.m
//  AssocRef
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>

@implementation ViewController
@synthesize buttonLabel=buttonLabel_;

static const char kRepresentedObject;

- (IBAction)doSomething:(id)sender {
  UIAlertView *alert = [[UIAlertView alloc]
                        initWithTitle:@"Alert" message:nil
                        delegate:self
                        cancelButtonTitle:@"OK"
                        otherButtonTitles:nil];
  objc_setAssociatedObject(alert, &kRepresentedObject, 
                           sender,
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  [alert show];
  
}

- (void)alertView:(UIAlertView *)alertView 
clickedButtonAtIndex:(NSInteger)buttonIndex {
  UIButton *sender = objc_getAssociatedObject(alertView, 
                                              &kRepresentedObject);
  self.buttonLabel.text = [[sender titleLabel] text];
}

- (void)viewDidUnload {
  [self setButtonLabel:nil];
  [super viewDidUnload];
}
@end
