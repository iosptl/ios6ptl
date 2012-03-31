//
//  ViewController.h
//  AssocRef
//
//  Created by Rob Napier on 9/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *buttonLabel;
- (IBAction)doSomething:(id)sender;
@end
