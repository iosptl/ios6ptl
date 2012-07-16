//
//  ViewController.m
//  AutoReturn
//
//  Created by Rob Napier on 8/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize outputLabel=outputLabel_;

- (BOOL)textField:(UITextField *)textField 
        shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    self.outputLabel.text = [textField text];
    [textField resignFirstResponder];
    return NO;
  }
  return YES;
}

@end
