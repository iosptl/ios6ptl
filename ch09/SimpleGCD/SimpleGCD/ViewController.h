//
//  ViewController.h
//  SimpleGCD
//
//  Created by Rob Napier on 8/15/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (assign) NSUInteger count;
@property (assign) dispatch_queue_t queue;
@property (assign) BOOL shouldRun;
@end
