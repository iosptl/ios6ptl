//
//  GraphView.h
//  Graph
//
//  Created by Rob Napier on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView
@property (nonatomic, readonly, strong) NSMutableArray *values;
@property (nonatomic, readonly, strong) NSTimer *timer;
@end
