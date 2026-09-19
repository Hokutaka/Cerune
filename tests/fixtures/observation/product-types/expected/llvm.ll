target triple = "x86_64-unknown-linux-gnu"

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"
%cerune.type.Point.0 = type { double, double }
%cerune.type.Segment.1 = type { %cerune.type.Point.0, %cerune.type.Point.0 }

declare i32 @printf(ptr, ...)

define i32 @main() {
entry:
  %cerune_current = alloca %cerune.type.Point.0
  %cerune_saved = alloca %cerune.type.Point.0
  %cerune_segment = alloca %cerune.type.Segment.1
  %tmp0 = insertvalue %cerune.type.Point.0 poison, double 0x4000000000000000, 1
  %tmp1 = insertvalue %cerune.type.Point.0 %tmp0, double 0x0000000000000000, 0
  store %cerune.type.Point.0 %tmp1, ptr %cerune_current
  %tmp2 = load %cerune.type.Point.0, ptr %cerune_current
  store %cerune.type.Point.0 %tmp2, ptr %cerune_saved
  %tmp3 = insertvalue %cerune.type.Point.0 poison, double 0x4010000000000000, 0
  %tmp4 = insertvalue %cerune.type.Point.0 %tmp3, double 0x4014000000000000, 1
  store %cerune.type.Point.0 %tmp4, ptr %cerune_current
  %tmp5 = load %cerune.type.Point.0, ptr %cerune_saved
  %tmp6 = insertvalue %cerune.type.Segment.1 poison, %cerune.type.Point.0 %tmp5, 0
  %tmp7 = load %cerune.type.Point.0, ptr %cerune_current
  %tmp8 = insertvalue %cerune.type.Segment.1 %tmp6, %cerune.type.Point.0 %tmp7, 1
  store %cerune.type.Segment.1 %tmp8, ptr %cerune_segment
  %tmp9 = load %cerune.type.Point.0, ptr %cerune_saved
  %tmp10 = extractvalue %cerune.type.Point.0 %tmp9, 0
  call i32 (ptr, ...) @printf(ptr @.fmt_f64, double %tmp10)
  %tmp11 = load %cerune.type.Point.0, ptr %cerune_saved
  %tmp12 = extractvalue %cerune.type.Point.0 %tmp11, 1
  call i32 (ptr, ...) @printf(ptr @.fmt_f64, double %tmp12)
  %tmp13 = load %cerune.type.Segment.1, ptr %cerune_segment
  %tmp14 = extractvalue %cerune.type.Segment.1 %tmp13, 0
  %tmp15 = extractvalue %cerune.type.Point.0 %tmp14, 1
  call i32 (ptr, ...) @printf(ptr @.fmt_f64, double %tmp15)
  %tmp16 = load %cerune.type.Segment.1, ptr %cerune_segment
  %tmp17 = extractvalue %cerune.type.Segment.1 %tmp16, 1
  %tmp18 = extractvalue %cerune.type.Point.0 %tmp17, 0
  call i32 (ptr, ...) @printf(ptr @.fmt_f64, double %tmp18)
  ret i32 0
}
