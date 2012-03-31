//
//  AppCache.h
//  iHotelApp
//

#import <Foundation/Foundation.h>

@interface AppCache : NSObject {

}

+(NSString*) cacheDirectory;
+(void) clearCache;
+(NSString*) appVersion;

+(void) cacheMenuItems:(NSMutableArray*) menuItems;
+(NSMutableArray*) getCachedMenuItems;
+(BOOL) isMenuItemsStale;

@end
