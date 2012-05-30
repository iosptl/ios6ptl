//
//  KVCTableViewController.m
//  Chapter13
//

#import "KVCTableViewController.h"
#import "KVCTableViewCell.h"
#import "RNTimer.h"

@interface KVCTableViewController ()
@property (readwrite, strong) RNTimer *timer;
@property (readwrite, strong) NSDate *now;
@end

@implementation KVCTableViewController
@synthesize timer=_timer;
@synthesize now=_now;

- (void)updateNow {
  self.now = [NSDate date];
}

- (void)viewDidLoad {
  [self updateNow];

  __weak id weakSelf = self;
  self.timer =
      [RNTimer repeatingTimerWithTimeInterval:1
                                        block:^{
                                          [weakSelf updateNow];
                                        }];
}

- (void)viewDidUnload {
  self.timer = nil;
  self.now = nil;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"KVCTableViewCell";
  
  KVCTableViewCell *cell = [tableView
             dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[KVCTableViewCell alloc]
            initWithReuseIdentifier:CellIdentifier];
    [cell setProperty:@"now"];
    [cell setTarget:self];
  }
    
  return cell;
}

@end
