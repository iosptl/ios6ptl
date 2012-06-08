//
//  iHotelAppViewController.h
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESTfulEngine.h"

@interface iHotelAppViewController : UIViewController {
    
}

@property (nonatomic) RESTfulOperation *menuRequest; 

-(IBAction) loginButtonTapped:(id) sender;
-(IBAction) fetchMenuItems:(id) sender;

-(IBAction) simulateServerError:(id) sender;
-(IBAction) simulateRequestError:(id) sender;
@end
