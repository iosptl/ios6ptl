//
//  STViewController.h
//  SimpleThread
//
//  Created by Rob Napier on 8/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CounterThread.h"

@interface STViewController : UIViewController <CounterThreadDelegate>

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (assign) NSUInteger count;
@property (strong, nonatomic) CounterThread *thread;
@end
