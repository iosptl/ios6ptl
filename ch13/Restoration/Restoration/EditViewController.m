//
//  EditViewController.m
//  Restoration
//
//  Created by Rob Napier on 8/10/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetailItem:(id)newDetailItem
{
  if (_detailItem != newDetailItem) {
    _detailItem = newDetailItem;
    
    // Update the view.
    [self configureView];
  }
}

- (void)configureView
{
  // Update the user interface for the detail item.
  
  if (self.detailItem) {
    self.textview.text = [self.detailItem valueForKey:@"note"];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[self detailItem] setValue:self.textview.text forKey:@"note"];
  [[[self detailItem] managedObjectContext] save:NULL];
}


@end
