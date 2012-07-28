//
//  ConnectionViewController.h
//  Connection
//
//  Created by Rob Napier on 8/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, readwrite, strong) NSURLConnection *connection;
@end
