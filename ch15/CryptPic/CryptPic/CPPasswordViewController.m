//
//  CPPasswordViewController.m
//  CryptPic
//

#import "CPPasswordViewController.h"

@implementation CPPasswordViewController
@synthesize passwordTextField=passwordTextField_;
@synthesize delegate=delegate_;
@synthesize password=password_;

- (void)viewDidAppear:(BOOL)animated {
  [self.passwordTextField becomeFirstResponder];
  self.passwordTextField.text = self.password;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    self.password = self.passwordTextField.text;
    [self.delegate passwordViewController:self didFinishWithPassword:self.password];
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    return NO;
  }
  return YES;
}

@end
