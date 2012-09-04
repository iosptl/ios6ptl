//
//  RNErrorManager.h
//
//  Singleton factory for error-handling UIActionSheets
//

#import <Foundation/Foundation.h>

@interface RNErrorManager : NSObject <UIActionSheetDelegate>
+ (RNErrorManager *)sharedManager;
- (UIActionSheet *)actionSheetForError:(NSError *)error;

@end
