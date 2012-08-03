//
//  ViewController.m
//  Columns
//
//  Created by Rob Napier on 8/26/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
#import "ColumnView.h"

@implementation ViewController


- (void)viewDidLoad
{
  [super viewDidLoad];
  NSString *path = [[NSBundle mainBundle]
                    pathForResource:@"Lipsum" ofType:@"txt"];
	NSString *kLipsum = [[NSString alloc]
               initWithContentsOfFile:path
               encoding:NSUTF8StringEncoding
               error:NULL];
    
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
  [style setAlignment:NSTextAlignmentJustified];
  NSDictionary *attributes = @{NSParagraphStyleAttributeName: style};
  	
  NSAttributedString *
  attrString = [[NSAttributedString alloc] initWithString:kLipsum
                                               attributes:attributes];
  
  ColumnView *columnView = [[ColumnView alloc] initWithFrame:self.view.bounds];
  
	columnView.attributedString = attrString;
  
  [self.view addSubview:columnView];
}

@end
