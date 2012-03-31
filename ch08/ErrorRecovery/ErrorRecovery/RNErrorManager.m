//
//  RNErrorManager.m
//  ErrorRecovery
//

#import "RNErrorManager.h"

static const char kRNErrorKey;

static RNErrorManager *sSharedManager;

@implementation RNErrorManager

+ (void)initialize {
  sSharedManager = [[RNErrorManager alloc] init];
}

+ (RNErrorManager *)sharedManager {
  return sSharedManager;
}

- (UIActionSheet *)actionSheetForError:(NSError *)error {
  UIActionSheet *sheet = [[UIActionSheet alloc] init];
  
  sheet.title = [error localizedRecoverySuggestion];
  sheet.delegate = self;
  for (NSString *option in [error localizedRecoveryOptions]) {
    [sheet addButtonWithTitle:option];
  }
  
  objc_setAssociatedObject(sheet, &kRNErrorKey, error, 
                           OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  return sheet;
}

- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex {

  NSError *error = objc_getAssociatedObject(actionSheet, 
                                            &kRNErrorKey);

  id attempter = [error recoveryAttempter];
  
  if ([attempter respondsToSelector:
       @selector(attemptRecoveryFromError:optionIndex:)]) {
    [[error recoveryAttempter] attemptRecoveryFromError:error
                                         optionIndex:buttonIndex];
  }
  else {
    NSAssert(NO,
             @"Recovery attempter does not implement protocol.");
  }
}

@end
