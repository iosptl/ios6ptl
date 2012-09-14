//
//  KVCTableViewController.m
//

#import "KVCTableViewController.h"
#import "DataModel.h"

@implementation KVCTableViewController

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  // countOfItems is a KVC method, but you can call it directly
  // rather than creating an "items" proxy.
  return [[DataModel sharedModel] countOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  
  UITableViewCell *cell =
  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault 
            reuseIdentifier:CellIdentifier];
  }
  
  DataModel *model = [DataModel sharedModel];
  id object = [model objectInItemsAtIndex:indexPath.row];
  cell.textLabel.text = [object description];
  
  return cell;
}
@end
