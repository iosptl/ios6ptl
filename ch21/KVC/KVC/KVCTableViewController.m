//
//  KVCTableViewController.m
//

#import "KVCTableViewController.h"
#import "KVCTableViewCell.h"

@implementation KVCTableViewController

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
    // You want the "intValue" of the row's NSNumber.
    // The property will be the same for every row, so you set it
    // here in the cell construction section.
    cell.property = @"intValue";
  }
  
  // Each row's target is an NSNumber representing that integer
  // Since each row has a different object (NSNumber), you set
  // the target here, in the cell configuration section.
  cell.target = [NSNumber numberWithInt:indexPath.row];
  
  return cell;
}

@end
