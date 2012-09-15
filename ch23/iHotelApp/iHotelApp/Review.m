//
//  Review.m
//  

#import "Review.h"


@implementation Review

@synthesize rating = rating_;
@synthesize reviewDate = reviewDate_;
@synthesize reviewerName = reviewerName_;
@synthesize reviewId = reviewId_;
@synthesize reviewText = reviewText_;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

//=========================================================== 
//  Keyed Archiving
//
//=========================================================== 
- (void)encodeWithCoder:(NSCoder *)encoder 
{
    [encoder encodeObject:self.rating forKey:@"Rating"];
    [encoder encodeObject:self.reviewDate forKey:@"ReviewedDate"];
    [encoder encodeObject:self.reviewerName forKey:@"ReviewerName"];
    [encoder encodeObject:self.reviewId forKey:@"ReviewId"];
    [encoder encodeObject:self.reviewText forKey:@"ReviewText"];
}

- (id)initWithCoder:(NSCoder *)decoder 
{
    if ((self = [super init])) {
        if ([decoder containsValueForKey:@"Rating"])
            self.rating = [decoder decodeObjectForKey:@"Rating"];
        if ([decoder containsValueForKey:@"ReviewedDate"])
            self.reviewDate = [decoder decodeObjectForKey:@"ReviewedDate"];
        if ([decoder containsValueForKey:@"ReviewerName"])
            self.reviewerName = [decoder decodeObjectForKey:@"ReviewerName"];
        if ([decoder containsValueForKey:@"ReviewId"])
            self.reviewId = [decoder decodeObjectForKey:@"ReviewId"];
        if ([decoder containsValueForKey:@"ReviewText"])
            self.reviewText = [decoder decodeObjectForKey:@"ReviewText"];
    }
    return self;
}


- (id)copyWithZone:(NSZone *)zone
{
  id theCopy = [[[self class] allocWithZone:zone] init];  // use designated initializer
  
  [theCopy setRating:[self.rating copy]];
  [theCopy setReviewDate:[self.reviewDate copy]];
  [theCopy setReviewerName:[self.reviewerName copy]];
  [theCopy setReviewId:[self.reviewId copy]];
  [theCopy setReviewText:[self.reviewText copy]];
  
  return theCopy;
}

@end
