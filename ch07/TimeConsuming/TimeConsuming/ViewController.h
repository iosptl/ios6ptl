//
//  ViewController.h
//  TimeConsuming
//
//  Created by Rob Napier on 9/17/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activity;
- (IBAction)doSomething:(id)sender;
@end
