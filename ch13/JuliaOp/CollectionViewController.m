//
//  CollectionViewController.m
//  Mandel
//
//  Created by Rob Napier on 8/6/12.
//

#import "CollectionViewController.h"
#import "JuliaCell.h"
#include <sys/sysctl.h>

@interface CollectionViewController ()
@property (nonatomic, readwrite, strong) NSOperationQueue *queue;
@end

@implementation CollectionViewController

unsigned int countOfCores() {
  unsigned int ncpu;
  size_t len = sizeof(ncpu);
  sysctlbyname("hw.ncpu", &ncpu, &len, NULL, 0);
  
  return ncpu;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.queue = [[NSOperationQueue alloc] init];
  self.queue.maxConcurrentOperationCount = countOfCores();
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  JuliaCell *
  cell = [self.collectionView
          dequeueReusableCellWithReuseIdentifier:@"Julia"
          forIndexPath:indexPath];
  [cell configureWithSeed:indexPath.row queue:self.queue];
  return cell;
}

@end
