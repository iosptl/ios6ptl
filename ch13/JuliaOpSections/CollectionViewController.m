//
//  CollectionViewController.m
//  Mandel
//
//  Created by Rob Napier on 8/6/12.
//

#import "CollectionViewController.h"
#import "JuliaCell.h"
#import "JuliaManager.h"

@interface CollectionViewController ()
@property (nonatomic, readwrite, strong) JuliaManager *juliaManager;
@end

@implementation CollectionViewController

- (void)awakeFromNib {
  UICollectionViewFlowLayout *layout = (id)self.collectionView.collectionViewLayout;
  self.juliaManager = [[JuliaManager alloc] initWithSize:layout.itemSize];
}

- (void)viewDidAppear:(BOOL)animated {
  [self.juliaManager updateImagesForSeeds:[self.collectionView.visibleCells valueForKey:@"seed"]];
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
  cell.julia = [self.juliaManager juliaWithSeed:indexPath.row];
  return cell;
}

@end
