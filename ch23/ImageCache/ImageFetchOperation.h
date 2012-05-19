//
//  ImageFetchOperation.h
//  ImageCache
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

typedef void (^ImageBlock)(UIImage* image, NSURL* url);
@interface ImageFetchOperation : NSOperation

@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) NSMutableArray *observerBlocks;

-(id) initWithURL:(NSURL*) url onCompletion:(void(^)()) block;
-(void) addImageFetchObserverBlock:(void(^)(UIImage* image, NSURL* url)) newBlock;

@end
