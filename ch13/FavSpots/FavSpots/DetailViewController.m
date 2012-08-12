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
#import "ModelController.h"
#import "NSCoder+FavSpots.h"

static NSString * const kSpotKey = @"kSpotKey";
static NSString * const kRegionKey = @"kRegionKey";
static NSString * const kNameKey = @"kNameKey";

@interface DetailViewController ()
@property (nonatomic, readwrite, strong) NSString *restoreNameTextField;
@property (nonatomic, readwrite, assign) MKCoordinateRegion restoreRegion;
@end

@implementation DetailViewController

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [super encodeRestorableStateWithCoder:coder];

  [coder RN_encodeSpot:self.spot forKey:kSpotKey];
  [coder RN_encodeMKCoordinateRegion:self.mapView.region forKey:kRegionKey];
  [coder encodeObject:self.nameTextField.text forKey:kNameKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  [super decodeRestorableStateWithCoder:coder];
  
  _spot = [coder RN_decodeSpotForKey:kSpotKey];
  
  self.restoreRegion = [coder RN_decodeMKCoordinateRegionForKey:kRegionKey];
  self.restoreNameTextField = [coder decodeObjectForKey:kNameKey];
}

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
  if (self.restoreNameTextField) {
    self.nameTextField.text = self.restoreNameTextField;
    self.restoreNameTextField = nil;
  }
  else {
    self.nameTextField.text = spot.name;
  }

  if (self.restoreRegion.span.latitudeDelta != 0) {
    self.mapView.region = self.restoreRegion;
    self.restoreRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(0, 0), 0, 0);
  }
  else {
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(spot.latitude, spot.longitude);
  }
  
  self.locationLabel.text = [NSString stringWithFormat:@"(%.3f, %.3f)",
                             spot.latitude, spot.longitude];
  self.noteTextView.text = spot.notes;

  
  
  [self.mapView removeAnnotations:self.mapView.annotations];
  [self.mapView addAnnotation:[[MapViewAnnotation alloc] initWithSpot:spot]];
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
