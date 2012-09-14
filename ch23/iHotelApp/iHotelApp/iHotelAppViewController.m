//
//  iHotelAppViewController.m
//  iHotelApp
//

#import "iHotelAppViewController.h"
#import "RESTEngine.h"
#import "iHotelAppAppDelegate.h"

@implementation iHotelAppViewController
@synthesize menuRequest = menuRequest_;


- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}


-(void) viewDidDisappear:(BOOL)animated
{
  if(self.menuRequest)
    [self.menuRequest cancel];
  
	[super viewDidDisappear:animated];
}
#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
}

-(IBAction) loginButtonTapped:(id) sender
{
  AppDelegate.engine = 
  [[RESTEngine alloc] initWithLoginName:@"mugunth" 
                                password:@"abracadabra"
                        onLoginSucceeded:^(NSString* accessToken)  {
                          NSLog(@"Login is successful and this is the access token %@", accessToken); 
                        }
    
                                 onError:^(NSError* error)  {
                                   
                                   NSLog(@"Login failed. Check your password. Error is :%@", [error localizedDescription]);   
                                   
                                 }];
  AppDelegate.engine.delegate = self;
}

-(IBAction) fetchMenuItems:(id) sender
{
  // localMenuItems is a stub code that fetches menu items from a json file in resource bundle
  NSMutableArray *menuItems = [AppDelegate.engine localMenuItems];
  NSLog(@"%@", menuItems);
}

-(IBAction) simulateServerError:(id) sender
{    
  // we mock the method to return a error json from the error.json file
  [AppDelegate.engine fetchWrongMenu];
}

-(IBAction) simulateRequestError:(id) sender
{    
  // this request fails because example.com doesn't exist
  [AppDelegate.engine fetchMenuItems];
}

-(void) menuFetchSucceeded:(NSMutableArray*) menuItems
{
  NSLog(@"%@", menuItems);
}

-(void) menuFetchFailed:(NSError*) error
{
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                  message:[error localizedRecoverySuggestion]
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                                        otherButtonTitles: nil];
  [alert show];
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
