//
//  ViewController.h
//  BlurryText
//
//  Created by Rob Napier on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *label;
- (IBAction)toggleBlur:(id)sender;

@end
