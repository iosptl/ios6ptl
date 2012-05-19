//
//  RESTEngine.m
//  iHotelApp
//

#import "RESTEngine.h"
#import "MenuItem.h"

@implementation RESTEngine
@synthesize delegate;
@synthesize networkQueue;


-(NSString*) accessToken
{
    if(!_accessToken)
    {
      [self willChangeValueForKey:@"AccessToken"];
        _accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessTokenDefaultsKey];
      [self didChangeValueForKey:@"AccessToken"];
    }
    
    return _accessToken;
}
-(void) setAccessToken:(NSString *) aAccessToken
{
    [self willChangeValueForKey:@"AccessToken"];
    _accessToken = aAccessToken;
    [self didChangeValueForKey:@"AccessToken"];
    
    // if you are going to have multiple accounts support, 
    // it's advisable to store the access token as a serialized object    
    // this code will break when a second RESTEngine object is instantiated and a new token is issued for him

    [[NSUserDefaults standardUserDefaults] setObject:self.accessToken forKey:kAccessTokenDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (RESTRequest*) prepareRequestForURLString:(NSString*) urlString
{
    RESTRequest *request = [RESTRequest requestWithURL:[NSURL URLWithString:urlString]];  
    if(self.accessToken)
        [request setPostValue:self.accessToken forKey:@"AccessToken"];
  
  return request;
}


#pragma mark -
#pragma mark Custom Methods

// Add your custom methods here
-(id) initWithLoginName:(NSString*) loginName password:(NSString*) password
{
  self.networkQueue = [ASINetworkQueue queue];
  [self.networkQueue setMaxConcurrentOperationCount:6];
  [self.networkQueue setDelegate:self];
  [self.networkQueue go];
  
  ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:LOGIN_URL]];
  
	[request setUsername:loginName];
	[request setPassword:password];	
  
  [request setDelegate:self];
  
	[request setDidFinishSelector:@selector(loginDone:)];
	[request setDidFailSelector:@selector(loginFailed:)];	
	
	[self.networkQueue addOperation:request];
  
  return self;
}

- (void)loginDone:(ASIHTTPRequest *)request
{
	NSDictionary *responseDict = [[request responseString] mutableObjectFromJSONString];	
    self.accessToken = [responseDict objectForKey:@"accessToken"];	
	if([self.delegate respondsToSelector:@selector(loginSucceeded:)])
		[self.delegate performSelector:@selector(loginSucceeded:) withObject:self.accessToken];
}

- (void)loginFailed:(ASIHTTPRequest *)request
{
	self.accessToken = nil;
	if([self.delegate respondsToSelector:@selector(loginFailedWithError:)])
		[self.delegate performSelector:@selector(loginFailedWithError:) withObject:[request error]];
}

-(RESTRequest*) fetchMenuItems
{
  RESTRequest *request = [self prepareRequestForURLString:MENU_ITEMS_URL];
    
    [request setDelegate:self];
	[request setDidFinishSelector:@selector(menuFetchDone:)];
	[request setDidFailSelector:@selector(menuFetchFailed:)];	
	
	[self.networkQueue addOperation:request];
    
  return request;
}

-(NSMutableArray*) localMenuItems
{
  NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"menuitem.json"];
  NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
  
  NSDictionary *mockResponseDictionary = [jsonString mutableObjectFromJSONString];
  NSArray *menuItemsDictionaries = [mockResponseDictionary objectForKey:@"menuitems"];
  NSMutableArray *menuItems = [NSMutableArray array];
  
  for(NSMutableDictionary *menuItemDict in menuItemsDictionaries)
    [menuItems addObject:[[MenuItem alloc] initWithDictionary:menuItemDict]];

  return menuItems;
}

- (void)menuFetchDone:(RESTRequest *)request
{
	NSMutableArray *responseArray = [[request responseString] mutableObjectFromJSONString];	
  NSMutableArray *menuItems = [NSMutableArray array];
  
  for(NSMutableDictionary *menuItemDict in responseArray)
    [menuItems addObject:[[MenuItem alloc] initWithDictionary:menuItemDict]];
  
	if([self.delegate respondsToSelector:@selector(menuFetchSucceeded:)])
		[self.delegate performSelector:@selector(menuFetchSucceeded:) withObject:menuItems];
}

-(void) fetchWrongMenu
{
    NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"error.json"];
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSASCIIStringEncoding error:nil];
    
    NSMutableDictionary *mockResponseDictionary = [jsonString mutableObjectFromJSONString];
    NSMutableDictionary *errorDictionary = [mockResponseDictionary objectForKey:@"error"];
    RESTError *mockError = [[RESTError alloc] initWithDictionary:errorDictionary];

	if([self.delegate respondsToSelector:@selector(menuFetchFailed:)])
		[self.delegate performSelector:@selector(menuFetchFailed:) withObject:mockError];
    
}
- (void) menuFetchFailed:(RESTRequest *)request
{
	if([self.delegate respondsToSelector:@selector(menuFetchFailed:)])
		[self.delegate performSelector:@selector(menuFetchFailed:) withObject:[request error]];
}
@end
