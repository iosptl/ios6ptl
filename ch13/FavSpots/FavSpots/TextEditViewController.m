//
//  TextEditViewController.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "TextEditViewController.h"
#import "Spot.h"

@interface TextEditViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation TextEditViewController

- (void)viewWillAppear:(BOOL)animated {
  self.textView.text = self.spot.notes;
  [self.textView becomeFirstResponder];
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(keyboardWasShown:)
   name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0,
                                                kbSize.height, 0.0);
  self.textView.contentInset = contentInsets;
  self.textView.scrollIndicatorInsets = contentInsets;
}

- (void)viewWillDisappear:(BOOL)animated {
  self.spot.notes = self.textView.text;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
