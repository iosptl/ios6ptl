//
//  KVC_CollectionViewController.m
//

#import "RootViewController.h"
#import "DataModel.h"

@implementation RootViewController
@synthesize countLabel=countLabel_;
@synthesize entryLabel=entryLabel_;

- (void)refresh {
  DataModel *model = [DataModel sharedModel];

  // There is no property called "items" in DataModel. KVC will
  // automatically create a proxy for you.
  NSArray *items = [model valueForKey:@"items"];
  NSUInteger count = [items count];
  self.countLabel.text = [NSString stringWithFormat:@"%d", count];
  
  if (count > 0) {
    self.entryLabel.text = [[items objectAtIndex:(count-1)]
                            description];
  } else {
    self.entryLabel.text = @"";
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self refresh];
  [super viewWillAppear:animated];
}

- (IBAction)performAdd {
  [[DataModel sharedModel] addItem];
  [self refresh];
}

@end
