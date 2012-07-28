//
//  BezierAsm.s
//  BezierPerf
//
//  Created by Robert Napier on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//bezier_asm(
//        unsigned kSteps, // r0
//        CGPoint *results, // r1
//        float32x4_t *C, // r2
//        CGPoint* points //r3
//  );


  .private_extern _bezier_asm
  .globl _bezier_asm
  .align 2
  .code 16
  .thumb_func _bezier_asm
_bezier_asm:
  vld2.32 {q0,q1}, [r3] // x->q0, y->q1
  add r0, #1  // One extra to simplify the loop

Loop:
  vld1.f32 {q3}, [r2]!      // c->q3 (Obvious place to put it, but wrong)
  vmul.f32 q8, q3, q0       // c*x->q8
  vmul.f32 q9, q3, q1       // c*y->q9

  vpadd.f32 d16, d16, d17     // Half-add X -> d16
  vpadd.f32 d18, d18, d19     // Half-add Y -> d18

  vpadd.f32 d16, d16, d18     // Full add X and Y -> d16


  vst1.f32 {d16}, [r1]!  // Store to results and increment pointer

  subs r0, #1              // (May want to move this sooner while we're stalled)
  bne Loop

  bx lr

#######################

// FIXME: Audit register usage for saves
// FIXME: Handle even kSteps?
.private_extern _bezier_asm2
.globl _bezier_asm2
.align 2
.code 16
.thumb_func _bezier_asm2
_bezier_asm2:
  vld2.32 {q0,q1}, [r3] // x->q0, y->q1
  add r0, #1  // One extra to simplify the loop

  .align 4
  vld1.32 {q3-q4}, [r2]!      // c[current]->q3, c[next]->q4
Loop2:
  vmul.f32 q8, q3, q0       // c[current]*x->q8
  vmul.f32 q9, q3, q1       //2 c[current]*y->q9
  vmul.f32 q10, q4, q0      // c[next]*x->q10
  vmul.f32 q11, q4, q1      // c[next]*y->q11

  vld1.32 {q3-q4}, [r2]!      // c[current]->q3, c[next]->q4

  vpadd.f32 d16, d16, d17     // Half-add X -> d16
  vpadd.f32 d18, d18, d19     // Half-add Y -> d18
  vpadd.f32 d20, d20, d21
  vpadd.f32 d22, d22, d23

  vpadd.f32 d16, d16, d18     // Full add X and Y -> d16
  vpadd.f32 d17, d20, d22     // Full add X and Y [next] -> d17

  vst1.f32 {d16-d17}, [r1]!  // Store to results and increment pointer

  subs r0, #2
  bne Loop2

  bx lr

// FIXME: Handle non-divisible kSteps?
.private_extern _bezier_asm4
.globl _bezier_asm4
.align 4
.code 16
.thumb_func _bezier_asm4
_bezier_asm4:
  vpush {q4, q5, q6, q7}
  vld2.32 {q0,q1}, [r3,:128] // x->q0, y->q1
  add r0, #1  // One extra to simplify the loop

  vld1.32 {q3-q4}, [r2,:128]!      // c[current]->q3, c[next]->q4
  vld1.32 {q5-q6}, [r2,:128]!

  .align 4
Loop4:
  vmul.f32 q8, q3, q0       // c[current]*x->q8
  vmul.f32 q9, q3, q1       // c[current]*y->q9
  vmul.f32 q10, q4, q0      // c[next]*x->q10
  vmul.f32 q11, q4, q1      // c[next]*y->q11
  vmul.f32 q12, q5, q0      // c[next]*x->q10
  vmul.f32 q13, q5, q1      // c[next]*y->q11
  vmul.f32 q14, q6, q0      // c[next]*x->q10
  vmul.f32 q15, q6, q1      // c[next]*y->q11

  vld1.32 {q3-q4}, [r2,:128]!      // c[current]->q3, c[next]->q4


  // TODO: Split q3 and q4 load

  vpadd.f32 d16, d16, d17     // Half-add X -> d16
  vpadd.f32 d18, d18, d19     // Half-add Y -> d18
  vpadd.f32 d20, d20, d21
  vpadd.f32 d22, d22, d23
  vpadd.f32 d24, d24, d25
  vpadd.f32 d26, d26, d27
  vpadd.f32 d28, d28, d29
  vpadd.f32 d30, d30, d31

  vld1.32 {q5-q6}, [r2,:128]!

  // TODO: Split q3 and q4 load

  vpadd.f32 d16, d16, d18     // Full add X and Y -> d16
  vpadd.f32 d17, d20, d22     // Full add X and Y [next] -> d17
  vpadd.f32 d18, d24, d26     // Full add X and Y -> d16
  vpadd.f32 d19, d28, d30     // Full add X and Y [next] -> d17

  subs r0, #4
  vst1.f32 {d16-d19}, [r1,:128]!  // Store to results and increment pointer

  // TODO: Store q8 and q9 separately (see if we can store q8 sooner)

  bne Loop4

  vpop {q4, q5, q6, q7}
  bx lr


// FIXME: Handle non-divisible kSteps?
.private_extern _bezier_asm4p
.globl _bezier_asm4p
.align 4
.code 16
.thumb_func _bezier_asm4p
_bezier_asm4p:
  vpush {q4, q5, q6, q7}
  vld2.32 {q0,q1}, [r3,:128] // x->q0, y->q1
  add r0, #1  // One extra to simplify the loop

  vld1.32 {q3-q4}, [r2,:128]!      // c[current]->q3, c[next]->q4
  vld1.32 {q5-q6}, [r2,:128]!

.align 4
Loop5:
  vmul.f32 q8, q3, q0       // c[current]*x->q8
  vmul.f32 q9, q3, q1       // c[current]*y->q9
  vmul.f32 q10, q4, q0      // c[next]*x->q10
  vmul.f32 q11, q4, q1      // c[next]*y->q11
  vmul.f32 q12, q5, q0      // c[next]*x->q10
  vmul.f32 q13, q5, q1      // c[next]*y->q11
  vmul.f32 q14, q6, q0      // c[next]*x->q10
  vmul.f32 q15, q6, q1      // c[next]*y->q11

  vld1.32 {q3}, [r2,:128]!      // c[current]->q3, c[next]->q4

  vpadd.f32 d16, d16, d17     // Half-add X -> d16
  vpadd.f32 d18, d18, d19     // Half-add Y -> d18
  vpadd.f32 d20, d20, d21
  vpadd.f32 d22, d22, d23

  vld1.32 {q4}, [r2,:128]!      // c[next]->q4

  vpadd.f32 d24, d24, d25
  vpadd.f32 d26, d26, d27
  vpadd.f32 d28, d28, d29
  vpadd.f32 d30, d30, d31

  vld1.32 {q5-q6}, [r2,:128]!

  // TODO: Split q5 and q6 load

  vpadd.f32 d16, d16, d18     // Full add X and Y -> d16
  vpadd.f32 d17, d20, d22     // Full add X and Y [next] -> d17
  vpadd.f32 d18, d24, d26     // Full add X and Y -> d16
  vpadd.f32 d19, d28, d30     // Full add X and Y [next] -> d17

  subs r0, #4
  vst1.f32 {d16-d19}, [r1,:128]!  // Store to results and increment pointer

  // TODO: Store q8 and q9 separately (see if we can store q8 sooner)

  bne Loop5

  vpop {q4, q5, q6, q7}
  bx lr
