//
//  PullToRefreshTableViewExampleAppDelegate.h
//  PullToRefreshTableViewExample
//
//  Created by Mugunth Kumar M on 23/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScrollingExampleViewController;

@interface InfiniteScrollingExampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, strong) IBOutlet UIWindow *window;

@property (nonatomic, strong) IBOutlet InfiniteScrollingExampleViewController *viewController;

@end
