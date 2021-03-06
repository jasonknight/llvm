; RUN: llc -verify-machineinstrs -O0 < %s -mtriple=aarch64-none-linux-gnu | FileCheck %s

define i64 @test0() {
; CHECK: test0:
; Not produced by move wide instructions, but good to make sure we can return 0 anyway:
; CHECK: mov x0, xzr
  ret i64 0
}

define i64 @test1() {
; CHECK: test1:
; CHECK: movz x0, #1
  ret i64 1
}

define i64 @test2() {
; CHECK: test2:
; CHECK: movz x0, #65535
  ret i64 65535
}

define i64 @test3() {
; CHECK: test3:
; CHECK: movz x0, #1, lsl #16
  ret i64 65536
}

define i64 @test4() {
; CHECK: test4:
; CHECK: movz x0, #65535, lsl #16
  ret i64 4294901760
}

define i64 @test5() {
; CHECK: test5:
; CHECK: movz x0, #1, lsl #32
  ret i64 4294967296
}

define i64 @test6() {
; CHECK: test6:
; CHECK: movz x0, #65535, lsl #32
  ret i64 281470681743360
}

define i64 @test7() {
; CHECK: test7:
; CHECK: movz x0, #1, lsl #48
  ret i64 281474976710656
}

; A 32-bit MOVN can generate some 64-bit patterns that a 64-bit one
; couldn't. Useful even for i64
define i64 @test8() {
; CHECK: test8:
; CHECK: movn w0, #60875
  ret i64 4294906420
}

define i64 @test9() {
; CHECK: test9:
; CHECK: movn x0, #0
  ret i64 -1
}

define i64 @test10() {
; CHECK: test10:
; CHECK: movn x0, #60875, lsl #16
  ret i64 18446744069720047615
}

; For reasonably legitimate reasons returning an i32 results in the
; selection of an i64 constant, so we need a different idiom to test that selection
@var32 = global i32 0

define void @test11() {
; CHECK: test11:
; CHECK movz {{w[0-9]+}}, #0
  store i32 0, i32* @var32
  ret void
}

define void @test12() {
; CHECK: test12:
; CHECK: movz {{w[0-9]+}}, #1
  store i32 1, i32* @var32
  ret void
}

define void @test13() {
; CHECK: test13:
; CHECK: movz {{w[0-9]+}}, #65535
  store i32 65535, i32* @var32
  ret void
}

define void @test14() {
; CHECK: test14:
; CHECK: movz {{w[0-9]+}}, #1, lsl #16
  store i32 65536, i32* @var32
  ret void
}

define void @test15() {
; CHECK: test15:
; CHECK: movz {{w[0-9]+}}, #65535, lsl #16
  store i32 4294901760, i32* @var32
  ret void
}

define void @test16() {
; CHECK: test16:
; CHECK: movn {{w[0-9]+}}, #0
  store i32 -1, i32* @var32
  ret void
}

define i64 @test17() {
; CHECK: test17:

  ; Mustn't MOVN w0 here.
; CHECK: movn x0, #2
  ret i64 -3
}
