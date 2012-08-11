//
//  TextEditViewController.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "TextEditViewController.h"
#import "Spot.h"
#import "NSCoder+FavSpots.h"

static NSString * const kSpotKey = @"kSpotKey";

@interface TextEditViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation TextEditViewController

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [super encodeRestorableStateWithCoder:coder];
  
  [coder RN_encodeSpot:self.spot forKey:kSpotKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  [super decodeRestorableStateWithCoder:coder];
  
  _spot = [coder RN_decodeSpotForKey:kSpotKey];
}

- (void)setSpot:(Spot *)spot {
  _spot = spot;
  [self configureView];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self configureView];
}

- (void)configureView {
  self.textView.text = self.spot.notes;
}

- (void)viewDidAppear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter]
   addObserver:self
   selector:@selector(keyboardWasShown:)
   name:UIKeyboardDidShowNotification object:nil];
  [self.textView becomeFirstResponder];  
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
