//
//  MadelCell.h
//  Mandel
//
//  Created by Rob Napier on 8/6/12.
//

#import <UIKit/UIKit.h>
#import "Julia.h"

@interface JuliaCell : UICollectionViewCell
@property (nonatomic, readwrite, strong) Julia *julia;
@end
