//
//  ModelBase.h
//  Steinlogic
//

#import <Foundation/Foundation.h>

@interface JSONModel : NSObject <NSCoding, NSCopying, NSMutableCopying>

-(id) initWithDictionary:(NSMutableDictionary*) jsonObject;

@end
