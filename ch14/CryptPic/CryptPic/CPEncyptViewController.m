//
//  CPFirstViewController.m
//  CryptPic
//


#import "CPEncyptViewController.h"
#import "CPCryptController.h"


@implementation CPEncyptViewController
@synthesize imageView=imageView_;
@synthesize password=password_;
@synthesize modeSegmentedControl=modeSegmentedControl_;
@synthesize encryptButton=encryptButton_;

- (void)refreshEnabled {
  self.encryptButton.enabled = (self.imageView.image != nil && [self.password length] > 0);
}

- (void)viewDidLoad {
  [self.modeSegmentedControl setSelectedSegmentIndex:[[CPCryptController sharedController] encryptionMode]];
  [self refreshEnabled];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"showPassword"]) {
    [[segue destinationViewController] setPassword:self.password];
    [[segue destinationViewController] setDelegate:self];
  }
}

- (IBAction)selectPicture:(id)sender {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  picker.delegate = self;
  [self presentModalViewController:picker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  self.imageView.image = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self dismissModalViewControllerAnimated:YES];
  [self refreshEnabled];
}

- (void)passwordViewController:(CPPasswordViewController *)vc didFinishWithPassword:(NSString *)password {
  self.password = password;
  [self refreshEnabled];
}

- (IBAction)encrypt:(id)sender {
  NSError *error;
  if (! [[CPCryptController sharedController] encryptData:UIImageJPEGRepresentation(self.imageView.image, 0.9) password:self.password error:&error] ) {
    NSLog(@"Could not encrypt data: %@", error);
  };
}

- (IBAction)changeMode:(id)sender {
  [[CPCryptController sharedController] setEncryptionMode:[sender selectedSegmentIndex]];
}

- (void)viewDidUnload {
  [self setModeSegmentedControl:nil];
  [self setEncryptButton:nil];
  [super viewDidUnload];
}
@end
