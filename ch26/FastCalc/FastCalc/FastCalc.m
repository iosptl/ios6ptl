//
//  FastCalc.c
//  FastCalc
//
//  Created by Rob Napier on 7/21/12.
//  Copyright (c) 2012 Rob Napier. All rights reserved.
//

#include <stdio.h>
#include <math.h>
#include <CoreGraphics/CoreGraphics.h>
#include <stdlib.h>
#include <strings.h>
#include <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import <GLKit/GLKit.h>

static const unsigned kIterations = 10000;

static const unsigned kSteps = 999;
static const CGFloat kStepSize = 1/((CGFloat)kSteps-1);

static CGPoint P0 = {50, 500};
static CGPoint P1 = {300, 300};
static CGPoint P2 = {400, 700};
static CGPoint P3 = {650, 500};

CGPoint *sResults;

static CGPoint *sExpectedResults;
static const size_t kResultsSize = kSteps * sizeof(struct CGPoint);
static const CGFloat kTolerance = 0.001;

static void SuiteSetup() {
  sResults = malloc(kResultsSize);
  sExpectedResults = malloc(kResultsSize);
}

static void TestSetup() {
  bzero(sResults, kResultsSize);
}

static void SaveResults() {
  memcpy(sExpectedResults, sResults, kResultsSize);
}

static bool VerifyResults() {
  for (unsigned i = 0; i < kSteps; ++i) {
    CGFloat diffX = fabsf(sExpectedResults[i].x - sResults[i].x);
    CGFloat diffY = fabsf(sExpectedResults[i].y - sResults[i].y);
    if (diffX > kTolerance || diffY > kTolerance) {
      printf("Failed at %d: %s != %s\n", i,
             [NSStringFromCGPoint(sResults[i])
              cStringUsingEncoding:NSUTF8StringEncoding],
             [NSStringFromCGPoint(sExpectedResults[i])
              cStringUsingEncoding:NSUTF8StringEncoding]);
      
      return false;
    }
    else {
      printf("%s\n", [NSStringFromCGPoint(sResults[i])
                      cStringUsingEncoding:NSUTF8StringEncoding]);
    }
  }
  return true;
}

static CGFloat Bezier(CGFloat t, CGFloat P0, CGFloat P1,
                      CGFloat P2, CGFloat P3) {
  return
  powf(1-t, 3) * P0
  + 3 * powf(1-t, 2) * t * P1
  + 3 * (1-t) * powf(t, 2) * P2
  + powf(t, 3) * P3;
}

static inline CGFloat BezierNoPow(CGFloat t, CGFloat P0, CGFloat P1,
                                  CGFloat P2, CGFloat P3) {
  return
  (1-t)*(1-t)*(1-t) * P0
  + 3 * (1-t)*(1-t) * t * P1
  + 3 * (1-t) * t*t * P2
  + t*t*t * P3;
}

static CGFloat BezierAccelerate(CGFloat t, CGFloat P0, CGFloat P1, CGFloat P2,
                                CGFloat P3) {
  
  const CGFloat P[1][4] = {P0, P1, P2, P3};
  
  static const CGFloat B[4][4] =
  { {-1,  3, -3, 1},
    { 3, -6,  3, 0},
    {-3,  3,  0, 0},
    { 1,  0,  0, 0}};
  
  const CGFloat T[4][1] = { t*t*t, t*t, t, 1 };
  
  CGFloat PB[1][4]; // Result of P*B (1 row, 4 columns)
  vDSP_mmul((CGFloat*)P, 1, (CGFloat*)B, 1, (CGFloat*)PB, 1, 1, 4, 4);
  
  CGFloat result[1][1]; // Result of PB*T (1 row, 1 column; a scalar)
  vDSP_mmul((CGFloat*)PB, 1, (CGFloat *)T, 1, (CGFloat*)result, 1, 1, 1, 4);
  
  return result[0][0];
}

static void RunTest(const char *name, dispatch_block_t block) {
  TestSetup();
  CFAbsoluteTime start = CACurrentMediaTime();
  for (unsigned iteration = 0; iteration < kIterations; ++iteration) {
    block();
  }
  CFAbsoluteTime end = CACurrentMediaTime();
  printf("%s: %f\n", name, end - start);
}

static void TestSimple() {
  RunTest(__func__, ^{
    for (unsigned step = 0; step <= kSteps; ++step) {
      sResults[step].x = Bezier(step * kStepSize,
                                P0.x, P1.x, P2.x, P3.x);
      sResults[step].y = Bezier(step * kStepSize,
                                P0.y, P1.y, P2.y, P3.y);
    }
  });
}

static void TestNoPow() {
  RunTest(__func__, ^{
    for (unsigned step = 0; step <= kSteps; ++step) {
      sResults[step].x = BezierNoPow(step * kStepSize,
                                     P0.x, P1.x, P2.x, P3.x);
      sResults[step].y = BezierNoPow(step * kStepSize,
                                     P0.y, P1.y, P2.y, P3.y);
    }
  });
}

static void TestRefactor() {
  RunTest(__func__, ^{
    for (unsigned step = 0; step <= kSteps; ++step)
    {
      CGFloat t = step * kStepSize;
      
      CGFloat C0 = (1-t)*(1-t)*(1-t); // * P0
      CGFloat C1 = 3 * (1-t)*(1-t) * t; // * P1
      CGFloat C2 = 3 * (1-t) * t*t; // * P2
      CGFloat C3 = t*t*t; // * P3;
      
      sResults[step].x = C0*P0.x + C1*P1.x + C2*P2.x + C3*P3.x;
      sResults[step].y = C0*P0.y + C1*P1.y + C2*P2.y + C3*P3.y;
    }
  });
}

static void TestAccelerate() {
  RunTest(__func__, ^{
    for (unsigned step = 0; step <= kSteps; ++step)
    {
      CGFloat x = BezierAccelerate(step * kStepSize, P0.x, P1.x, P2.x, P3.x);
      CGFloat y = BezierAccelerate(step * kStepSize, P0.y, P1.y, P2.y, P3.y);
      sResults[step] = CGPointMake(x, y);
    }
  });
}

static void TestGLKit() {
  RunTest(__func__, ^{
    
    static GLKMatrix4 B =
    { -1,  3, -3, 1,
      3, -6,  3, 0,
      -3,  3,  0, 0,
      1,  0,  0, 0};
    
    GLKMatrix4 Bt = GLKMatrix4Transpose(B); // Not really necessary, but not expensive
    
    GLKVector4 Px = {P0.x, P1.x, P2.x, P3.x};
    GLKVector4 Py = {P0.y, P1.y, P2.y, P3.y};
    
    GLKVector4 PxB = GLKMatrix4MultiplyVector4(Bt, Px);
    GLKVector4 PyB = GLKMatrix4MultiplyVector4(Bt, Py);
    
    for (unsigned step = 0; step <= kSteps; ++step) {
      CGFloat t = step * kStepSize;
      GLKVector4 tv = { t*t*t, t*t, t, 1 };
      sResults[step].x = GLKVector4DotProduct(PxB, tv);
      sResults[step].y = GLKVector4DotProduct(PyB, tv);
    }
  });
}

//static void TestGLKitPrecompute() {
//  GLKVector4 *tv = malloc(kSteps * sizeof(GLKVector4));
//  for (unsigned step = 0; step <= kSteps; ++step) {
//    CGFloat t = step * kStepSize;
//    tv[step].x = t*t*t;
//    tv[step].y = t*t;
//    tv[step].z = t;
//    tv[step].w = 1;
//  }
//
//  static GLKMatrix4 B =
//  { -1,  3, -3, 1,
//    3, -6,  3, 0,
//    -3,  3,  0, 0,
//    1,  0,  0, 0};
//
//  GLKMatrix4 Bt = GLKMatrix4Transpose(B); // Not really necessary, but not expensive
//
//  RunTest(__func__, ^{
//    GLKVector4 Px = {P0.x, P1.x, P2.x, P3.x};
//    GLKVector4 Py = {P0.y, P1.y, P2.y, P3.y};
//
//    GLKVector4 PxB = GLKMatrix4MultiplyVector4(Bt, Px);
//    GLKVector4 PyB = GLKMatrix4MultiplyVector4(Bt, Py);
//
//    vSndot
//    for (unsigned step = 0; step <= kSteps; ++step) {
//      vDSP_dotpr2(PxB.v, 1, PyB.v, 1, tv[step].v, 1, &sResults[step].x, &sResults[step].y, 4);
//    }
//  });
//}

//static void TestDSP() {
//  RunTest(__func__, ^{
//    GLKMatrix4 B =
//    { -1,  3, -3, 1,
//      3, -6,  3, 0,
//      -3,  3,  0, 0,
//      1,  0,  0, 0};
//    GLKMatrix4 Bt = GLKMatrix4Transpose(B); // Not really necessary, but not expensive
//
//    GLKVector4 Px = {P0.x, P1.x, P2.x, P3.x};
//    GLKVector4 Py = {P0.y, P1.y, P2.y, P3.y};
//
//    GLKVector4 PxB = GLKMatrix4MultiplyVector4(Bt, Px);
//    GLKVector4 PyB = GLKMatrix4MultiplyVector4(Bt, Py);
//
//    CGFloat **ts = malloc(kSteps * sizeof(CGFloat) * 4);
//    CGFloat *Cs = malloc(kSteps * sizeof(CGFloat) * 2);
//    for (unsigned step = 0; step <= kSteps; ++step) {
//      CGFloat t = step * kStepSize;
//      ts[step][0] = 1;
//      ts[step][1] = t;
//      ts[step][2] = t * t;
//      ts[step][3] = t * t * t;
//    }
//
//    vDSP_dotpr(, <#vDSP_Stride __vDSP_stride1#>, <#const float *__vDSP_input2#>, <#vDSP_Stride __vDSP_stride2#>, <#float *__vDSP_result#>, <#vDSP_Length __vDSP_size#>)
//
//
//    free(ts);
//  });
//}
//

void bezier_asm4(unsigned kSteps, CGPoint *results, float32x4_t *C, CGPoint* points);
void bezier_asm4p(unsigned kSteps, CGPoint *results, float32x4_t *C, CGPoint* points);

void TestAsm() {
  static float32x4_t C[kSteps] = {0};
  for (unsigned step = 0; step < kSteps; ++step)
  {
    CGFloat t = step * kStepSize;
    C[step][0] = (1-t)*(1-t)*(1-t); // * P0
    C[step][1] = 3 * (1-t)*(1-t) * t; // * P1
    C[step][2] = 3 * (1-t) * t*t; // * P2
    C[step][3] = t*t*t; // * P3;
  }
  
  RunTest(__func__, ^{
    CGPoint points[4] __attribute__ ((align (16))) = {P0, P1, P2, P3};
    bezier_asm4(kSteps, sResults, C, points);
  });
}

void TestAsmP() {
  static float32x4_t C[kSteps] = {0};
  for (unsigned step = 0; step < kSteps; ++step)
  {
    CGFloat t = step * kStepSize;
    C[step][0] = (1-t)*(1-t)*(1-t); // * P0
    C[step][1] = 3 * (1-t)*(1-t) * t; // * P1
    C[step][2] = 3 * (1-t) * t*t; // * P2
    C[step][3] = t*t*t; // * P3;
  }
  
  RunTest(__func__, ^{
    CGPoint points[4] __attribute__ ((align (16))) = {P0, P1, P2, P3};
    bezier_asm4p(kSteps, sResults, C, points);
  });
}

void TestFactoredNoPow() {
  static CGFloat C[kSteps][4] = {0};
  for (unsigned step = 0; step < kSteps; ++step)
  {
    CGFloat t = step * kStepSize;
    C[step][0] = (1-t)*(1-t)*(1-t); // * P0
    C[step][1] = 3 * (1-t)*(1-t) * t; // * P1
    C[step][2] = 3 * (1-t) * t*t; // * P2
    C[step][3] = t*t*t; // * P3;
  }

  RunTest(__func__, ^{
    for (unsigned step = 0; step <= kSteps; ++step) {
      sResults[step].x = C[step][0] * P0.x
      + C[step][1] * P1.x
      + C[step][2] * P2.x
      + C[step][3] * P3.x;
      
      sResults[step].y = C[step][0] * P0.y
      + C[step][1] * P1.y
      + C[step][2] * P2.y
      + C[step][3] * P3.y;
    }
  });
}

void RunTests() {
  SuiteSetup();
  TestSimple();
  SaveResults();
  TestNoPow();
  TestRefactor();
  //  TestAccelerate();
  TestGLKit();
  //  TestDGESV();
  //  TestGLKitPrecompute();
  TestAsm();
    TestAsmP();
//  assert(VerifyResults());
  TestFactoredNoPow();
}