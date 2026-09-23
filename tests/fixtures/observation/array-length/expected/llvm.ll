target triple = "x86_64-unknown-linux-gnu"

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"
@.bool_true = private unnamed_addr constant [5 x i8] c"true\00"
@.bool_false = private unnamed_addr constant [6 x i8] c"false\00"

declare i32 @printf(ptr, ...)
declare i32 @puts(ptr)

define [2 x i64] @cerune.fn.values.0() {
entry:
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 42)
  %tmp0 = insertvalue [2 x i64] poison, i64 10, 0
  %tmp1 = insertvalue [2 x i64] %tmp0, i64 20, 1
  ret [2 x i64] %tmp1
}

define i32 @main() {
entry:
  %cerune_logical_result0 = alloca i1
  %tmp0 = call [2 x i64] @cerune.fn.values.0()
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 2)
  store i1 0, ptr %cerune_logical_result0
  br i1 0, label %block0, label %block1
block0: ; logical_rhs
  %tmp1 = call [2 x i64] @cerune.fn.values.0()
  %tmp2 = icmp eq i64 2, 2
  store i1 %tmp2, ptr %cerune_logical_result0
  br label %block1
block1: ; logical_end
  %tmp3 = load i1, ptr %cerune_logical_result0
  %tmp4 = select i1 %tmp3, ptr @.bool_true, ptr @.bool_false
  call i32 @puts(ptr %tmp4)
  ret i32 0
}
