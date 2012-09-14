//
//  DataModel.h
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

+ (DataModel*)sharedModel;

- (void)addItem;
- (NSUInteger)countOfItems;
- (id)objectInItemsAtIndex:(NSUInteger)index;
@end
