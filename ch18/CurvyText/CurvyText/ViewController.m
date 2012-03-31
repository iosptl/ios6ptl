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
  
  CTFontRef baseFont, boldFont, bigFont;
  
  CFStringRef string = CFSTR
  (
   "You can display text along a curve, with fi "
   "ligatures, bold, color, and big text."
   );
  
  // Create the mutable attributed string
  CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(NULL, 0);
  CFAttributedStringReplaceString(attrString, 
                                  CFRangeMake(0, 0),
                                  string);
  
  // Set the base font
  baseFont = CTFontCreateUIFontForLanguage(kCTFontUserFontType,
                                           16.0,
                                           NULL);
  CFIndex length = CFStringGetLength(string);
  CFAttributedStringSetAttribute(attrString,
                                 CFRangeMake(0, length),
                                 kCTFontAttributeName, 
                                 baseFont);
  
  // Apply bold by finding the bold version of the current font.
  boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont,
                                                0,
                                                NULL,
                                                kCTFontBoldTrait,
                                                kCTFontBoldTrait);
  CFAttributedStringSetAttribute(attrString,
                                 CFStringFind(string, 
                                              CFSTR("bold"),
                                              0),
                                 kCTFontAttributeName, 
                                 boldFont);
  
  // Apply color
  CGColorRef color = [[UIColor redColor] CGColor];
  CFAttributedStringSetAttribute(attrString,
                                 CFStringFind(string,
                                              CFSTR("color"), 
                                              0),
                                 kCTForegroundColorAttributeName,
                                 color);

  // Apply big text
  bigFont = CTFontCreateUIFontForLanguage(kCTFontUserFontType,
                                          36.0,
                                          NULL);
  CFAttributedStringSetAttribute(attrString,
                                 CFStringFind(string,
                                              CFSTR("big text"), 
                                              0),
                                 kCTFontAttributeName,
                                 bigFont);
  
  curvyTextView.attributedString = (__bridge_transfer id)attrString;
  CFRelease(baseFont);
  CFRelease(boldFont);
  CFRelease(bigFont);
}

@end
