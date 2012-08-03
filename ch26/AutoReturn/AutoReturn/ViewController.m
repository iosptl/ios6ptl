//
//  ViewController.m
//  AutoReturn
//
//  Created by Rob Napier on 8/23/11.
//

#import "ViewController.h"

@implementation ViewController

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
