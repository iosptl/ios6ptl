//
// RNAssert.h
// Defines assertion macros that log as well as crash, even when
// in Release mode
//

#import <Foundation/Foundation.h>

#define RNLogBug NSLog // Use DDLogError if you’re using Lumberjack

// RNAssert and RNCAssert work exactly like NSAssert and NSCAssert
// except they log, even in release mode

#define RNAssert(condition, desc, ...) \
  if (!(condition)) { \
    RNLogBug((desc), ## __VA_ARGS__); \
    NSAssert((condition), (desc), ## __VA_ARGS__); \
  }

#define RNCAssert(condition, desc) \
  if (!(condition)) { \
    RNLogBug((desc), ## __VA_ARGS__); \
    NSCAssert((condition), (desc), ## __VA_ARGS__); \
  }