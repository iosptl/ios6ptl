//
//  MenuItem.m
//  iHotelApp
//
//  Created by Mugunth on 25/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "MenuItem.h"
#import "Review.h"

@implementation MenuItem

@synthesize itemId;
@synthesize image;
@synthesize name;
@synthesize spicyLevel;
@synthesize rating;
@synthesize itemDescription;
@synthesize waitingTime;
@synthesize reviewCount;
@synthesize reviews;

- (id)init
{
  self = [super init];
  if (self) {
    // Initialization code here.
    reviews = [[NSMutableArray alloc] init];
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

-(NSString*) description {
  
  return [NSString stringWithFormat:@"%@ - %@", self.name, self.itemDescription];
}
@end
