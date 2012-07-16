//
//  RNPerformanceTestObserver.m
//  FastCalc
//
//  Created by Rob Napier on 7/14/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#import "RNPerformanceTestObserver.h"
#import "RNPerformanceTestCase.h"

@interface RNPerformanceTestObserver ()
@property NSMutableDictionary *timeResults;
@end


@implementation RNPerformanceTestObserver

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
  RNPerformanceTestCase *test = (RNPerformanceTestCase *)notification.run.test;
  CFTimeInterval runTime = [test stopTime] - [test startTime];
  [self.timeResults setObject:[NSNumber numberWithDouble:runTime] forKey:NSStringFromSelector([(SenTestCase *)notification.run.test selector])];
}

@end
