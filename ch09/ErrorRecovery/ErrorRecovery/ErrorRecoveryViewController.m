//
//  ErrorRecoveryViewController.m
//  ErrorRecovery
//
//  Created by Rob Napier on 7/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ErrorRecoveryViewController.h"
#import "RNErrorManager.h"

NSString * const RNAppErrorDomain = @"net.robnapier.ErrorRecovery.ErrorDomain";

typedef enum {
  kRNAppBadThingError = -1
} RNAppError;

typedef enum {
  kRecoveryOptionRunAway,
  kRecoveryOptionHide,
  kRecoveryOptionFix
} RNRecoveryOption;

@implementation ErrorRecoveryViewController

- (void)attemptRecoveryFromError:(NSError *)error
                     optionIndex:(NSUInteger)recoveryOptionIndex {

  switch (recoveryOptionIndex) {
    case kRecoveryOptionRunAway:
      NSLog(@"Run Away!");
      break;
    case kRecoveryOptionHide:
      NSLog(@"Hide!");
      break;
    case kRecoveryOptionFix:
      NSLog(@"OK, fix it....");
      break;
    default:
      NSAssert(NO, @"Unknown recovery option: %d", 
               recoveryOptionIndex);
      break;
  }   
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSArray *options = [NSArray arrayWithObjects:
                      NSLocalizedString(@"Run away", 
                                        @"OPTION: Avoid error by leaving."),
                      NSLocalizedString(@"Hide",
                                        @"OPTION: Avoid error by hiding."),
                      NSLocalizedString(@"Fix",
                                        @"OPTION: Fix error"),
                      nil];

  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

  [userInfo setObject:self forKey:NSRecoveryAttempterErrorKey];

  [userInfo setObject:options
               forKey:NSLocalizedRecoveryOptionsErrorKey];
  
  [userInfo setObject:NSLocalizedString(@"What do you want to do?", 
                                        @"Request decision.")
               forKey:NSLocalizedRecoverySuggestionErrorKey];

  NSError *error = [NSError errorWithDomain:RNAppErrorDomain 
                                       code:kRNAppBadThingError
                                   userInfo:userInfo];

  UIActionSheet *sheet = [[RNErrorManager sharedManager]
                          actionSheetForError:error];
  [sheet showInView:self.view];
}

@end
