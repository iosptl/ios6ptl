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
#import "NSCoder+RNMapKit.h"

static NSString * const kSpotURIKey = @"kSpotURIKey";
static NSString * const kRegionKey = @"kRegionKey";
static NSString * const kNameKey = @"kNameKey";

@implementation DetailViewController

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder {
  [super encodeRestorableStateWithCoder:coder];

  NSManagedObjectID *spotID = self.spot.objectID;
  NSAssert(! [spotID isTemporaryID], @"Spot must not be temporary during state saving. %@", self.spot);
  
  [coder encodeObject:[spotID URIRepresentation] forKey:kSpotURIKey];
  [coder RN_encodeMKCoordinateRegion:self.mapView.region forKey:kRegionKey];
  [coder encodeObject:self.nameTextField.text forKey:kNameKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
  [super decodeRestorableStateWithCoder:coder];
  
  NSURL *spotURI = [coder decodeObjectForKey:kSpotURIKey];

  NSManagedObjectContext *
  context = [[ModelController sharedController]
             managedObjectContext];
  NSManagedObjectID *
  spotID = [[context persistentStoreCoordinator]
            managedObjectIDForURIRepresentation:spotURI];
  if (spotID) {
    self.spot = (Spot *)[context objectWithID:spotID];
  }
  
  if ([coder containsValueForKey:kRegionKey]) {
    self.mapView.region = [coder RN_decodeMKCoordinateRegionForKey:kRegionKey];
  }
  
  if ([coder containsValueForKey:kNameKey]) {
    self.nameTextField.text = [coder decodeObjectForKey:kNameKey];
  }
}

- (void)viewDidLoad
{
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
  
  UIGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNoteTap:)];
  [self.noteTextView addGestureRecognizer:g];
  [self configureView];
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
