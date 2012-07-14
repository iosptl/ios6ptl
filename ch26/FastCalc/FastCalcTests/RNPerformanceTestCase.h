//
//  RNPerformanceTestCase.h
//  
//
//  Created by Rob Napier on 7/14/12.
//
//

#import <SenTestingKit/SenTestCase.h>

@interface RNPerformanceTestCase : SenTestCase
@property CFTimeInterval startTime;
@property CFTimeInterval stopTime;
@end
