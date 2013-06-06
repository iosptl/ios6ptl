//
//  PullToRefreshViewController.m
//  Steinlogic Consulting and Training Pte Ltd
//
//  Created by Mugunth on 20/5/2011 (Based on Enormego's code)
//  Copyright 2011 Steinlogic. All rights reserved.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

//

#import "PullToRefreshViewController.h"
@interface PullToRefreshViewController (/*Private Methods*/)
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@end


@implementation PullToRefreshViewController
@synthesize numberOfSections = _numberOfSections;
@synthesize endReached = _endReached;

-(BOOL) loading
{
  return _loading;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.loading = NO;
  
  if(NSClassFromString(@"UIRefreshControl")) {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshedByPullingTable:) forControlEvents:UIControlEventValueChanged];
  }
  else
  {
    
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    
    self.refreshHeaderView.keyNameForDataStore = [NSString stringWithFormat:@"%@_LastRefresh", [self class]];
    self.tableView.showsVerticalScrollIndicator = YES;
    [self.tableView addSubview:self.refreshHeaderView];
  }  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if(self.searchDisplayController.searchResultsTableView == scrollView) return;
  if(NSClassFromString(@"UIRefreshControl")) return;
	if (self.refreshHeaderView.state == EGOOPullRefreshLoading) {
		CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
		offset = MIN(offset, 60);
		scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
	} else if (scrollView.isDragging) {
    if (self.refreshHeaderView.state == EGOOPullRefreshPulling && scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !self.loading) {
			[self.refreshHeaderView setState:EGOOPullRefreshNormal];
		} else if (self.refreshHeaderView.state == EGOOPullRefreshNormal && scrollView.contentOffset.y < -65.0f && !self.loading) {
			[self.refreshHeaderView setState:EGOOPullRefreshPulling];
		}
    
    if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
  }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if(self.searchDisplayController.searchResultsTableView == scrollView) return;
  if(NSClassFromString(@"UIRefreshControl")) return;
  if (scrollView.contentOffset.y <= - 65.0f && !self.loading) {
    self.loading = YES;
    
		[self.refreshHeaderView setState:EGOOPullRefreshLoading];
		[self.tableView reloadData];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
    [self doRefresh];
	}
}

-(void) refreshedByPullingTable:(id) sender {
  
  [self.refreshControl beginRefreshing];
  [self doRefresh];
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [self.refreshControl endRefreshing];
  });
}

-(void) doRefresh
{
  NSLog(@"Override doRefresh in subclass. This line should not appear on console");
}


-(void) loadMore  {
  
  NSLog(@"Override loadMore in subclass. This line should not appear on console");
}


-(void) setLoading:(BOOL)loading
{
  if(NSClassFromString(@"UIRefreshControl")) return;
  _loading = loading;
  
  [UIView beginAnimations:nil context:NULL];
  
  if(loading)
  {
    [self.refreshHeaderView setState:EGOOPullRefreshLoading];
    [UIView setAnimationDuration:0.2];
		self.tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
  }
  else
  {
    [self.refreshHeaderView setState:EGOOPullRefreshNormal];
    [self.refreshHeaderView setCurrentDate];
    
    [UIView setAnimationDuration:.3];
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
  }
  [UIView commitAnimations];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  {
  
  return self.numberOfSections + 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
  
  if(section == self.numberOfSections && !self.endReached)
    return 1;
  
  // this condition should not happen.
  return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  if(indexPath.section == self.numberOfSections)  {
    
      static NSString *CellIdentifier = @"LoadingCell";
      
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil)
      {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
          UIActivityIndicatorView *newSpin = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
          [newSpin startAnimating];
          [newSpin setFrame:CGRectMake( 15, 12, 20, 20) ];
          [newSpin setTag:101];
          [cell addSubview:newSpin];
      }
      
      [(UIActivityIndicatorView *)[cell viewWithTag:101] startAnimating];      
      
      
    cell.textLabel.text = NSLocalizedString(@"Loading…", @"");
    cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:1.0];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:16];
		// other initialization goes here
    [self loadMore];
		return cell;
  }
  
  // this condition should not happen.
  return nil;
}
@end
