//
//  RESTEngine.h
//  iHotelApp
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "RESTRequest.h"

#define BASE_URL @"http://api.example.com" // CHANGE THIS IN YOUR APP
#define LOGIN_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/loginwaiter"]
#define MENU_ITEMS_URL [NSString stringWithFormat:@"%@%@", BASE_URL, @"/menuitem"]

#define kAccessTokenDefaultsKey @"ACCESS_TOKEN"

@protocol RESTEngineDelegate <NSObject>
@optional
-(void) loginSucceeded:(NSString*) accessToken;
-(void) loginFailedWithError:(NSError*) error;
-(void) menuFetchSucceeded:(NSMutableArray*) menuItems;
-(void) menuFetchFailed:(NSError*) error;
@end

@interface RESTEngine : NSObject {

    NSString *_accessToken;
}

@property (nonatomic, unsafe_unretained) id<RESTEngineDelegate> delegate;
@property (nonatomic, strong) ASINetworkQueue *networkQueue;
@property (nonatomic, strong) NSString *accessToken;

-(id) initWithLoginName:(NSString*) loginName password:(NSString*) password;
-(RESTRequest*) fetchMenuItems;
-(NSMutableArray*) localMenuItems;
-(void) fetchWrongMenu;
@end
