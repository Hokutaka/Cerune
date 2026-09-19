target triple = "x86_64-unknown-linux-gnu"

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"

declare i32 @printf(ptr, ...)

define i32 @main() {
entry:
  %cerune_single = alloca float
  %cerune_double = alloca double
  %cerune_inferred = alloca double
  %cerune_suffixed = alloca float
  %tmp0 = fadd float 0x3FB99999A0000000, 0x3FC99999A0000000
  store float %tmp0, ptr %cerune_single
  %tmp1 = fadd double 0x3FB999999999999A, 0x3FC999999999999A
  store double %tmp1, ptr %cerune_double
  %tmp2 = fadd double 0x3FB999999999999A, 0x3FC999999999999A
  store double %tmp2, ptr %cerune_inferred
  %tmp3 = fadd float 0x3FB99999A0000000, 0x3FC99999A0000000
  store float %tmp3, ptr %cerune_suffixed
  %tmp4 = load float, ptr %cerune_single
  %tmp5 = fpext float %tmp4 to double
  call i32 (ptr, ...) @printf(ptr @.fmt_f32, double %tmp5)
  %tmp6 = load double, ptr %cerune_double
  call i32 (ptr, ...) @printf(ptr @.fmt_f64, double %tmp6)
  %tmp7 = load double, ptr %cerune_inferred
  call i32 (ptr, ...) @printf(ptr @.fmt_f64, double %tmp7)
  %tmp8 = load float, ptr %cerune_suffixed
  %tmp9 = fpext float %tmp8 to double
  call i32 (ptr, ...) @printf(ptr @.fmt_f32, double %tmp9)
  ret i32 0
}
