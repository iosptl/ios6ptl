//
//  RESTError.h
//  iHotelApp
//

#import <Foundation/Foundation.h>
#define kRequestErrorDomain @"HTTP_ERROR"
#define kBusinessErrorDomain @"BIZ_ERROR" // rename this appropriately

@interface RESTError : NSError {

}

@property (nonatomic, strong) NSString *message;
@property (nonatomic, weak) NSString *errorCode;

- (NSString*) localizedOption;

-(id) initWithDictionary:(NSMutableDictionary*) jsonObject;
@end
