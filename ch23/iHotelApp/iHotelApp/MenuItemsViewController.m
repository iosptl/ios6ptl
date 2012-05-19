//
//  MenuItemsViewController.m
//  iHotelApp
//

#import "MenuItemsViewController.h"
#import "iHotelAppAppDelegate.h"
#import "MenuItem.h"
#import "AppCache.h"

@implementation MenuItemsViewController
@synthesize menuItems;

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}


- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];  
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

-(void) updateUI
{
  [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
  NSMutableArray *cachedItems = [AppCache getCachedMenuItems];
  
  if(cachedItems == nil)
    self.menuItems = [AppDelegate.engine localMenuItems];
  else
    self.menuItems = cachedItems;
  
  if([AppCache isMenuItemsStale])
    self.menuItems = [AppDelegate.engine localMenuItems];
  
  [self updateUI];

  [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{  
  [AppCache cacheMenuItems:self.menuItems];
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  // Return the number of rows in the section.
  return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell...
  MenuItem *thisItem = [self.menuItems objectAtIndex:indexPath.row];
  cell.textLabel.text = thisItem.name;
  return cell;
}


@end
