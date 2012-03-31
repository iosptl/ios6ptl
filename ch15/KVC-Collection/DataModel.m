//
//  DataModel.m
//

#import "DataModel.h"

@interface DataModel ()
@property (nonatomic, readwrite, assign) NSUInteger count;
@end

@implementation DataModel
@synthesize count=count_;

+ (DataModel*)sharedModel {
  static DataModel *sharedModel;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{ sharedModel = [DataModel new]; });
  return sharedModel;
}

- (NSUInteger)countOfItems {
  return self.count;
}

- (id)objectInItemsAtIndex:(NSUInteger)index {
  return [NSNumber numberWithInt:index * 2];
}

- (void)addItem {
  self.count++;
}

@end
