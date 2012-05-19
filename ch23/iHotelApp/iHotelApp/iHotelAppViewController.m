//
//  iHotelAppViewController.m
//  iHotelApp
//

#import "iHotelAppViewController.h"
#import "RESTEngine.h"
#import "iHotelAppAppDelegate.h"
#import "MenuItemsViewController.h"

@implementation iHotelAppViewController
@synthesize menuRequest;


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
  AppDelegate.engine.delegate = self;
  AppDelegate.engine = [[RESTEngine alloc] initWithLoginName:@"mugunth" password:@"abracadabra"];
}

-(IBAction) fetchMenuItems:(id) sender
{
  if(AppDelegate.engine == nil)
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not logged in", @"") 
                                                    message:NSLocalizedString(@"Logging in initializes the engine required by this method. Try tapping the login button and tap here again.", @"")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles: nil];
    [alert show];
    return;
  }
  MenuItemsViewController *controller = [[MenuItemsViewController alloc] initWithNibName:@"MenuItemsViewController"
                                                                    bundle:nil];
	[self.navigationController pushViewController:controller animated:YES];

}

-(IBAction) simulateServerError:(id) sender
{    
  if(AppDelegate.engine == nil)
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not logged in", @"") 
                                                    message:NSLocalizedString(@"Logging in initializes the engine required by this method. Try tapping the login button and tap here again.", @"")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles: nil];
    [alert show];
    return;
  }
    // we mock the method to return a error json from the error.json file
    [AppDelegate.engine fetchWrongMenu];
}

-(IBAction) simulateRequestError:(id) sender
{    
  if(AppDelegate.engine == nil)
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Not logged in", @"") 
                                                    message:NSLocalizedString(@"Logging in initializes the engine required by this method. Try tapping the login button and tap here again.", @"")
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles: nil];
    [alert show];
    return;
  }
    // this request fails because example.com doesn't exist
    [AppDelegate.engine fetchMenuItems];
}

-(void) loginSucceeded:(NSString*) accessToken
{
    // note that the engine automatically remembers access tokens
    NSLog(@"Login is successful and this is the access token %@", accessToken);
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

-(void) loginFailedWithError:(NSError*) error
{
    NSLog(@"Login failed. Check your password. Error is :%@", [error localizedDescription]);   
    
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
