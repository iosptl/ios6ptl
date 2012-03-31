//
//  RESTRequest.h
//  iHotelApp
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

#import "RESTError.h"

@interface RESTRequest : ASIFormDataRequest

@property (nonatomic, strong) RESTError *restError;

-(NSMutableDictionary*) responseDictionary;
@end
