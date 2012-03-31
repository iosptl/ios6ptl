//
//  KVCTableViewCell.h
//

#import <UIKit/UIKit.h>

@interface KVCTableViewCell : UITableViewCell

- (id)initWithReuseIdentifier:(NSString*)identifier;

// Object to display.
@property (nonatomic, readwrite, strong) id target;

// Name of property of object to display
@property (nonatomic, readwrite, copy) NSString *property;
@end
