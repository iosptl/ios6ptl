//
//  FastCalcTests.m
//  FastCalcTests
//
//  Created by Rob Napier on 7/13/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "FastCalcTests.h"
#import <QuartzCore/QuartzCore.h>
#import <SenTestingKit/SenTestObserver.h>

#define kDivisor 1000

static CGPoint P0 = {50, 500};
static CGPoint P1 = {300, 300};
static CGPoint P2 = {400, 700};
static CGPoint P3 = {650, 500};

static CGPoint *results;
static CGPoint *testResults;

static const float kAccuracy = 0.001;
static const NSUInteger kNumberOfIterations = 1000;

@implementation FastCalcTests

+ (void)initialize {
  if (self == [FastCalcTests class]) {
    results = calloc(kDivisor + 1, sizeof(struct CGPoint));
    testResults = calloc(kDivisor + 1,
                         sizeof(struct CGPoint));
  }
}

- (NSUInteger)numberOfTestIterationsForTestWithSelector:(SEL)testMethod {
  return kNumberOfIterations;
}

- (void)tearDown {
  // Record that we're done as quickly as possible
  [super tearDown];
  
  // Use the first run to test all the other values
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    memcpy(testResults, results,
           (kDivisor + 1) * sizeof(struct CGPoint));
  });
  
  // Make sure we're accurate enough
  for (unsigned i = 0; i <= kDivisor; ++i) {
    STAssertEqualsWithAccuracy(results[i].x, testResults[i].x, kAccuracy, @"Mismatch");
    STAssertEqualsWithAccuracy(results[i].y, testResults[i].y, kAccuracy, @"Mismatch");
  }
}

static __attribute__((always_inline))
float Bezier(float t, float P0, float P1, float P2,
             float P3) {
  return
  powf(1-t, 3) * P0
  + 3 * powf(1-t, 2) * t * P1
  + 3 * (1-t) * powf(t, 2) * P2
  + powf(t, 3) * P3;
}

- (void)testSimple
{
  for (unsigned step = 0; step <= kDivisor; ++step) {
    float x = Bezier((float)step/(float)kDivisor,
                     P0.x, P1.x, P2.x, P3.x);
    float y = Bezier((float)step/(float)kDivisor,
                     P0.y, P1.y, P2.y, P3.y);
    results[step] = CGPointMake(x, y);
  }
}

static __attribute__((always_inline))
float BezierNoPow(float t, float P0,
                  float P1, float P2,
                  float P3) {
  return
  (1-t)*(1-t)*(1-t) * P0
  + 3 * (1-t)*(1-t) * t * P1
  + 3 * (1-t) * t*t * P2
  + t*t*t * P3;
}

- (void)testSimpleNoPow
{
  for (unsigned step = 0; step <= kDivisor; ++step) {
    float x = BezierNoPow((float)step/(float)kDivisor,
                          P0.x, P1.x, P2.x, P3.x);
    float y = BezierNoPow((float)step/(float)kDivisor,
                          P0.y, P1.y, P2.y, P3.y);
    results[step] = CGPointMake(x, y);
  }
}

@end
