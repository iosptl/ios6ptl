//
//  Review.h
//  

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface Review : JSONModel <NSCoding>

@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *reviewDate;
@property (nonatomic, strong) NSString *reviewerName;
@property (nonatomic, strong) NSString *reviewId;
@property (nonatomic, strong) NSString *reviewText;

@end
