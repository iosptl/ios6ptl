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


//=========================================================== 
//  Keyed Archiving
//
//=========================================================== 
- (void)encodeWithCoder:(NSCoder *)encoder 
{
  [encoder encodeObject:self.itemId forKey:@"ItemId"];
  [encoder encodeObject:self.image forKey:@"Image"];
  [encoder encodeObject:self.name forKey:@"Name"];
  [encoder encodeObject:self.spicyLevel forKey:@"SpicyLevel"];
  [encoder encodeObject:self.rating forKey:@"Rating"];
  [encoder encodeObject:self.itemDescription forKey:@"ItemDescription"];
  [encoder encodeObject:self.waitingTime forKey:@"WaitingTime"];
  [encoder encodeObject:self.reviewCount forKey:@"ReviewCount"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
  if ((self = [super init])) {
    self.itemId = [decoder decodeObjectForKey:@"ItemId"];
    self.image = [decoder decodeObjectForKey:@"Image"];
    self.name = [decoder decodeObjectForKey:@"Name"];
    self.spicyLevel = [decoder decodeObjectForKey:@"SpicyLevel"];
    self.rating = [decoder decodeObjectForKey:@"Rating"];
    self.itemDescription = [decoder decodeObjectForKey:@"ItemDescription"];
    self.waitingTime = [decoder decodeObjectForKey:@"WaitingTime"];
    self.reviewCount = [decoder decodeObjectForKey:@"ReviewCount"];
  }
  return self;
}

- (id)copyWithZone:(NSZone *)zone
{
  id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
  
  [theCopy setItemId:[self.itemId copy]];
  [theCopy setImage:[self.image copy]];
  [theCopy setName:[self.name copy]];
  [theCopy setSpicyLevel:[self.spicyLevel copy]];
  [theCopy setRating:[self.rating copy]];
  [theCopy setItemDescription:[self.itemDescription copy]];
  [theCopy setWaitingTime:[self.waitingTime copy]];
  [theCopy setReviewCount:[self.reviewCount copy]];
  
  return theCopy;
}
@end
