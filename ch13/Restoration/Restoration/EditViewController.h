//
//  EditViewController.h
//  Restoration
//
//  Created by Rob Napier on 8/10/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController <UITextViewDelegate>
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UITextView *textview;

@end
