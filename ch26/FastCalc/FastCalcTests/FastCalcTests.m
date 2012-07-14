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

@interface FastCalcTests ()
@property CFTimeInterval startTime;
@property CFTimeInterval stopTime;
@end

@interface RNTestPerformanceObserver : SenTestObserver
@property NSMutableDictionary *timeResults;
@end

@implementation RNTestPerformanceObserver

- (id)init
{
  self = [super init];
  if (self) {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(testSuiteDidStart:) name:SenTestSuiteDidStartNotification object:nil];
    [nc addObserver:self selector:@selector(testSuiteDidStop:) name:SenTestSuiteDidStopNotification object:nil];
    [nc addObserver:self selector:@selector(testDidStart:) name:SenTestCaseDidStartNotification object:nil];
    [nc addObserver:self selector:@selector(testDidStop:) name:SenTestCaseDidStopNotification object:nil];
  }
  return self;
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testSuiteDidStart:(NSNotification *)notification {
  if ([[[notification test] name] isEqual:[[SenTestSuite defaultTestSuite] name]]) {
    self.timeResults = [NSMutableDictionary new];
  }
}

- (void)testSuiteDidStop:(NSNotification *)notification {
  if ([[[notification test] name] isEqual:[[SenTestSuite defaultTestSuite] name]]) {
    [SenTestLog testLogWithFormat:@"Results: %@", self.timeResults];
    self.timeResults = nil;
  }
}

- (void)testDidStart:(NSNotification *)notification {
}

- (void)testDidStop:(NSNotification *)notification {
  FastCalcTests *test = (FastCalcTests *)notification.run.test;
  CFTimeInterval runTime = [test stopTime] - [test startTime];
  [self.timeResults setObject:[NSNumber numberWithDouble:runTime] forKey:NSStringFromSelector([(SenTestCase *)notification.run.test selector])];
}

@end


#define kDivisor 1000

static CGPoint P0 = {50, 500};
static CGPoint P1 = {300, 300};
static CGPoint P2 = {400, 700};
static CGPoint P3 = {650, 500};

static CGPoint *results;
static CGPoint *testResults;

static RNTestPerformanceObserver *observer;

@implementation FastCalcTests

- (NSUInteger)numberOfTestIterationsForTestWithSelector:(SEL)testMethod {
  return 1000;
}

+ (void)initialize {
  if (self == [FastCalcTests class]) {
    results = calloc(kDivisor + 1, sizeof(struct CGPoint));
    testResults = calloc(kDivisor + 1,
                         sizeof(struct CGPoint));
    observer = [RNTestPerformanceObserver new];
  }
}

- (void)setUp {
  _startTime = CACurrentMediaTime();
}

- (void)tearDown {
  _stopTime = CACurrentMediaTime();
  
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    memcpy(testResults, results,
           (kDivisor + 1) * sizeof(struct CGPoint));
  });
  
  for (unsigned i = 0; i <= kDivisor; ++i) {
    STAssertEqualsWithAccuracy(results[i].x, testResults[i].x, 0.001, @"Mismatch");
    STAssertEqualsWithAccuracy(results[i].y, testResults[i].y, 0.001, @"Mismatch");
  }
}

static inline CGFloat Bezier(CGFloat t, CGFloat P0,
                             CGFloat P1, CGFloat P2,
                             CGFloat P3) {
  return
  powf(1-t, 3) * P0
  + 3 * powf(1-t, 2) * t * P1
  + 3 * (1-t) * powf(t, 2) * P2
  + powf(t, 3) * P3;
}

- (void)testSimple
{
//  printf("testSimple\n");
  for (unsigned step = 0; step <= kDivisor; ++step) {
    CGFloat x = Bezier((CGFloat)step/(CGFloat)kDivisor,
                       P0.x, P1.x, P2.x, P3.x);
    CGFloat y = Bezier((CGFloat)step/(CGFloat)kDivisor,
                       P0.y, P1.y, P2.y, P3.y);
    results[step] = CGPointMake(x, y);
  }
}

static inline CGFloat BezierNoPow(CGFloat t, CGFloat P0,
                                  CGFloat P1, CGFloat P2,
                                  CGFloat P3) {
  return
  (1-t)*(1-t)*(1-t) * P0
  + 3 * (1-t)*(1-t) * t * P1
  + 3 * (1-t) * t*t * P2
  + t*t*t * P3;
}

- (void)testSimpleNoPow
{
  for (unsigned step = 0; step <= kDivisor; ++step) {
    CGFloat x = BezierNoPow((CGFloat)step/(CGFloat)kDivisor,
                            P0.x, P1.x, P2.x, P3.x);
    CGFloat y = BezierNoPow((CGFloat)step/(CGFloat)kDivisor,
                            P0.y, P1.y, P2.y, P3.y);
    results[step] = CGPointMake(x, y);
  }
}

@end
