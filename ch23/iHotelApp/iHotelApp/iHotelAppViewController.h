//
//  iHotelAppViewController.h
//  iHotelApp
//

#import <UIKit/UIKit.h>
#import "RESTEngine.h"

@interface iHotelAppViewController : UIViewController<RESTEngineDelegate> {
    
}

@property (nonatomic, strong) RESTRequest *menuRequest; 

-(IBAction) loginButtonTapped:(id) sender;
-(IBAction) fetchMenuItems:(id) sender;

-(IBAction) simulateServerError:(id) sender;
-(IBAction) simulateRequestError:(id) sender;
@end
