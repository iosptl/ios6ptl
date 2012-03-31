//
//  KVCTableViewCell.h
//  Chapter13
//

#import <UIKit/UIKit.h>

@interface KVCTableViewCell : UITableViewCell
- (id)initWithReuseIdentifier:(NSString*)identifier;
@property (nonatomic, readwrite, strong) id target;
@property (nonatomic, readwrite, copy) NSString *property;
@end
