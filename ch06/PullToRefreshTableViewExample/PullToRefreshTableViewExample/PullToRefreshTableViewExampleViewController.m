//
//  PullToRefreshTableViewExampleViewController.m
//  PullToRefreshTableViewExample
//
//  Created by Mugunth Kumar M on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PullToRefreshTableViewExampleViewController.h"

@implementation PullToRefreshTableViewExampleViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) loadingComplete  {
    
    self.loading = NO;
}
-(void) doRefresh  {
    
    [self performSelector:@selector(loadingComplete) withObject:nil afterDelay:2];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1000;
}


// table with with built in cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Row %d", indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"ios5"];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
