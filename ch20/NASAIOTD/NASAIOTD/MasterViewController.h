//
//  MasterViewController.h
//  NASAIOTD
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
