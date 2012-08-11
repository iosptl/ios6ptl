//
//  DetailViewController.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "DetailViewController.h"
#import "ModelController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setSpot:(Spot *)newSpot
{
  if (_spot != newSpot) {
    _spot = newSpot;
    
    // Update the view.
    [self configureView];
  }
}

- (void)configureView
{
  if (self.spot) {
    Spot *spot = self.spot;
    self.nameTextField.text = spot.name;
    self.locationLabel.text = [NSString stringWithFormat:@"(%.3f, %.3f)",
                               spot.latitude, spot.longitude];
    self.noteTextView.text = spot.notes;
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(spot.latitude, spot.longitude);
  }
}

- (void)viewDidLoad
{
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{

}

@end
