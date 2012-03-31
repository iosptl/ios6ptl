//
//  ImageCache.h
//  ImageCache
//
//	File created using Singleton XCode Template by Mugunth Kumar (http://mugunthkumar.com
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above

#import <Foundation/Foundation.h>
#import "ImageFetchOperation.h"

#define MEMORY_CACHE_SIZE 100
#define CACHE_FOLDER_NAME @"ImageCache"

// 1 day in seconds
#define IMAGE_FILE_LIFETIME 86400.0

@interface ImageCache : NSObject {
  
}

+ (ImageCache*) sharedImageCache;

-(void) imageAtURL:(NSURL*) url onCompletion:(void(^)(UIImage* image, NSURL* url)) imageFetchedBlock;

@property (nonatomic, strong) NSOperationQueue *imageFetchQueue;
@property (nonatomic, strong) NSMutableDictionary *runningOperations;

@property (nonatomic, strong) NSMutableDictionary *memoryCache;
@property (nonatomic, strong) NSMutableArray *memoryCacheKeys;

@end
