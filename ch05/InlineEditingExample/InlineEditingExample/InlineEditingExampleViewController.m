//
//  InlineEditingExampleViewController.m
//  InlineEditingExample
//
//  Created by Mugunth Kumar M on 30/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "InlineEditingExampleViewController.h"
#import "LabelTextFieldCell.h"

@implementation InlineEditingExampleViewController
@synthesize data = _data;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.data = [NSMutableArray arrayWithCapacity:10];
    for(int i = 0 ; i < 10; i ++)
        [self.data insertObject:@"" atIndex:i];
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


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 10;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"LabelTextFieldCell";
	
	LabelTextFieldCell *cell = (LabelTextFieldCell*)[tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (cell == nil) {
		
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LabelTextFieldCell" owner:self options:nil];
		cell = (LabelTextFieldCell*)[nib objectAtIndex:0];
	}
	
	// other initialization goes here
    cell.inputText.text = [self.data objectAtIndex:indexPath.row];
    cell.onTextEntered = ^(NSString* enteredString) {
        
        [self.data insertObject:enteredString atIndex:indexPath.row];
    };

	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

/*
 
 - (void)_keyboardWillShow:(NSNotification*)notification {
 
 NSDictionary* userInfo = [notification userInfo];
 
 // we don't use SDK constants here to be universally compatible with all SDKs ≥ 3.0
 NSValue* keyboardFrameValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];
 if (!keyboardFrameValue) {
 keyboardFrameValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
 }
 
 // Reduce the tableView height by the part of the keyboard that actually covers the tableView
 CGRect windowRect = [[UIApplication sharedApplication] keyWindow].bounds;
 if (UIInterfaceOrientationLandscapeLeft == self.interfaceOrientation ||UIInterfaceOrientationLandscapeRight == self.interfaceOrientation ) {
 windowRect = IASKCGRectSwap(windowRect);
 }
 CGRect viewRectAbsolute = [_tableView convertRect:_tableView.bounds toView:[[UIApplication sharedApplication] keyWindow]];
 if (UIInterfaceOrientationLandscapeLeft == self.interfaceOrientation ||UIInterfaceOrientationLandscapeRight == self.interfaceOrientation ) {
 viewRectAbsolute = IASKCGRectSwap(viewRectAbsolute);
 }
 CGRect frame = _tableView.frame;
 frame.size.height -= [keyboardFrameValue CGRectValue].size.height - CGRectGetMaxY(windowRect) + CGRectGetMaxY(viewRectAbsolute);
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
 [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
 _tableView.frame = frame;
 [UIView commitAnimations];
 
 
 [_tableView scrollToRowAtIndexPath:textFieldIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
 
 }
 
 - (void) scrollToOldPosition {
 [_tableView scrollToRowAtIndexPath:_topmostRowBeforeKeyboardWasShown atScrollPosition:UITableViewScrollPositionTop animated:YES];
 }
 
 - (void)_keyboardWillHide:(NSNotification*)notification {
 if (self.navigationController.topViewController == self) {
 NSDictionary* userInfo = [notification userInfo];
 
 [UIView beginAnimations:nil context:NULL];
 [UIView setAnimationDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
 [UIView setAnimationCurve:[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue]];
 _tableView.frame = self.view.bounds;
 [UIView commitAnimations];
 
 [self performSelector:@selector(scrollToOldPosition) withObject:nil afterDelay:0.1];
 }
 }  
 */
@end
