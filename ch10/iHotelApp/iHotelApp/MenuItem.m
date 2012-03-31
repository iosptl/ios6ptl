//
//  MenuItem.m
//  iHotelApp
//

#import "MenuItem.h"
#import "Review.h"

@implementation MenuItem

@synthesize itemId = itemId_;
@synthesize image = image_;
@synthesize name = name_;
@synthesize spicyLevel = spicyLevel_;
@synthesize rating = rating_;
@synthesize itemDescription = itemDescription_;
@synthesize waitingTime = waitingTime_;
@synthesize reviewCount = reviewCount_;
@synthesize reviews = reviews_;


- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
    reviews_ = [[NSMutableArray alloc] init];
  }
  
  return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if([key isEqualToString:@"id"])
        self.itemId = value;
    else if([key isEqualToString:@"description"])
        self.itemDescription = value;
    else [super setValue:value forUndefinedKey:key];
}


-(void) setValue:(id)value forKey:(NSString *)key
{
  if([key isEqualToString:@"reviews"])
  {
    for(NSMutableDictionary *reviewArrayDict in value)
    {
      Review *thisReview = [[Review alloc] initWithDictionary:reviewArrayDict];
      [self.reviews addObject:thisReview];
    }
  }  
  else
    [super setValue:value forKey:key];
}

@end
