//
//  DetailViewController.h
//  Restoration
//
//  Created by Rob Napier on 8/10/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;
@end
