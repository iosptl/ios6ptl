//
//  KVCTableViewController.m
//  Chapter13
//

#import "KVCTableViewController.h"
#import "KVCTableViewCell.h"

@interface KVCTableViewController ()
@property (readwrite, strong) NSTimer *timer;
@property (readwrite, strong) NSDate *now;
@end

@implementation KVCTableViewController
@synthesize timer=timer_;
@synthesize now=now_;

- (void)updateNow {
  self.now = [NSDate date];
}

- (void)viewDidLoad {
  [self updateNow];
  self.timer = [NSTimer
    scheduledTimerWithTimeInterval:1
                            target:self
                          selector:@selector(updateNow)
                          userInfo:nil 
                           repeats:YES];
}

- (void)viewDidUnload {
  [self.timer invalidate];
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

- (void)dealloc {
  [timer_ invalidate];
}

@end
