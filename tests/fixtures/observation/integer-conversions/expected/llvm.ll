target triple = "x86_64-unknown-linux-gnu"

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"

declare i32 @printf(ptr, ...)

define i64 @cerune.fn.value.0() {
entry:
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 7)
  ret i64 42
}

define i32 @main() {
entry:
  %cerune_compact = alloca i64
  %cerune_explicit = alloca i64
  %tmp0 = call i64 @cerune.fn.value.0()
  store i64 %tmp0, ptr %cerune_compact
  %tmp1 = load i64, ptr %cerune_compact
  store i64 %tmp1, ptr %cerune_explicit
  %tmp2 = load i64, ptr %cerune_explicit
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 %tmp2)
  ret i32 0
}
