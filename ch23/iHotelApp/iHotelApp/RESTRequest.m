//
//  RESTRequest.m
//  iHotelApp
//

#import "RESTRequest.h"

@implementation RESTRequest
@synthesize restError;

-(NSMutableDictionary*) responseDictionary
{
	return [[self responseString] mutableObjectFromJSONString];
}

- (void)requestFinished
{  
  // even when request completes without a HTTP Status code, it might be a benign error
  
  NSMutableDictionary *errorDict = [[self responseDictionary] objectForKey:@"error"];
  
  if(errorDict)
  {
    self.restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain 
                                                code:[[errorDict objectForKey:@"code"] intValue]
                                            userInfo:errorDict];
    [super failWithError:self.restError];
  }
	else 
	{		
		[super requestFinished]; // normal successful request
	}	
}

-(void) failWithError:(NSError *)theError
{
  NSMutableDictionary *errorDict = [[self responseDictionary] objectForKey:@"error"];

  if(errorDict == nil)
  {
    self.restError = [[RESTError alloc] initWithDomain:kRequestErrorDomain 
                                              code:[theError code]
                                          userInfo:[theError userInfo]];
  }
  else
  {
    self.restError = [[RESTError alloc] initWithDomain:kBusinessErrorDomain 
                                                code:[[errorDict objectForKey:@"code"] intValue]
                                            userInfo:errorDict];    
  }
    
  [super failWithError:theError];
}

@end
