//
//  DetailViewController.m
//  FavSpots
//
//  Created by Rob Napier on 8/11/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "DetailViewController.h"
#import "ModelController.h"
#import "MapViewAnnotation.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)viewDidLoad
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
  
  UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNoteTap:)];
  [self.noteTextView addGestureRecognizer:g];
}

- (void)handleNoteTap:(UIGestureRecognizer *)g {
  [self performSegueWithIdentifier:@"editNote" sender:self];
}

- (void)dismissKeyboard
{
  [self.nameTextField resignFirstResponder];
}

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
  Spot *spot = self.spot;
  self.nameTextField.text = spot.name;
  self.locationLabel.text = [NSString stringWithFormat:@"(%.3f, %.3f)",
                             spot.latitude, spot.longitude];
  self.noteTextView.text = spot.notes;
  CLLocationCoordinate2D center = CLLocationCoordinate2DMake(spot.latitude, spot.longitude);
  self.mapView.centerCoordinate = center;
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView addAnnotation:[[MapViewAnnotation alloc] initWithSpot:spot]];
  
  MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, 1000, 1000);
  [self.mapView setRegion:region animated:YES];

}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self configureView];
}

- (void)viewWillDisappear:(BOOL)animated
{
  self.spot.name = self.nameTextField.text;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([[segue identifier] isEqualToString:@"editNote"]) {
    [[segue destinationViewController] setSpot:self.spot];
  }
}

@end
