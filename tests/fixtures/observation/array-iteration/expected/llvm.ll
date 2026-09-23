target triple = "x86_64-unknown-linux-gnu"

@cerune.failure.20.69.85.11 = private unnamed_addr constant [71 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\72\72\61\79\2D\69\6E\64\65\78\2D\6F\75\74\2D\6F\66\2D\62\6F\75\6E\64\73\20\6E\6F\64\65\3D\32\30\20\62\79\74\65\73\3D\36\39\2E\2E\38\35\0A"
@cerune.failure.20.69.85 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.20.69.85.11, i64 71 }]
@cerune.failure.29.141.151.0 = private unnamed_addr constant [64 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\69\6E\74\65\67\65\72\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\32\39\20\62\79\74\65\73\3D\31\34\31\2E\2E\31\35\31\0A"
@cerune.failure.29.141.151 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } { ptr @cerune.failure.29.141.151.0, i64 64 }, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer]
@cerune.failure.35.54.98.0 = private unnamed_addr constant [62 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\69\6E\74\65\67\65\72\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\33\35\20\62\79\74\65\73\3D\35\34\2E\2E\39\38\0A"
@cerune.failure.35.54.98 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } { ptr @cerune.failure.35.54.98.0, i64 62 }, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer]
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"

declare i32 @printf(ptr, ...)
declare void @llvm.trap()
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)

declare i32 @fflush(ptr)
declare i64 @write(i32, ptr, i64)

define internal void @cerune.runtime.fail(ptr %failure, i64 %code) {
entry:
  call i32 @fflush(ptr null)
  %slot = getelementptr inbounds { ptr, i64 }, ptr %failure, i64 %code
  %record = load { ptr, i64 }, ptr %slot
  %data = extractvalue { ptr, i64 } %record, 0
  %length = extractvalue { ptr, i64 } %record, 1
  call i64 @write(i32 2, ptr %data, i64 %length)
  call void @llvm.trap()
  unreachable
}

define internal i64 @cerune_i64_add(i64 %left, i64 %right, ptr %failure) {
entry:
  %checked = call { i64, i1 } @llvm.sadd.with.overflow.i64(i64 %left, i64 %right)
  %result = extractvalue { i64, i1 } %checked, 0
  %overflow = extractvalue { i64, i1 } %checked, 1
  br i1 %overflow, label %trap, label %ok

trap:
  call void @cerune.runtime.fail(ptr %failure, i64 0)
  unreachable
ok:
  ret i64 %result
}

define internal i64 @cerune.array.get.i64.2([2 x i64] %value, i64 %index, ptr %failure) {
entry:
  %index.low = icmp slt i64 %index, 0
  %index.high = icmp sge i64 %index, 2
  %index.outside = or i1 %index.low, %index.high
  br i1 %index.outside, label %out_of_bounds, label %in_bounds
out_of_bounds:
  call void @cerune.runtime.fail(ptr %failure, i64 11)
  unreachable
in_bounds:
  %array = alloca [2 x i64]
  store [2 x i64] %value, ptr %array
  %element = getelementptr inbounds [2 x i64], ptr %array, i64 0, i64 %index
  %result = load i64, ptr %element
  ret i64 %result
}

define [2 x i64] @cerune.fn.values.0() {
entry:
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 42)
  %tmp0 = insertvalue [2 x i64] poison, i64 1, 0
  %tmp1 = insertvalue [2 x i64] %tmp0, i64 2, 1
  ret [2 x i64] %tmp1
}

define i32 @main() {
entry:
  %cerune_$for_in_snapshot_0_54 = alloca [2 x i64]
  %cerune_$for_in_length_0_54 = alloca i64
  %cerune_$for_in_cursor_0_54 = alloca i64
  %cerune_i = alloca i64
  %cerune_value = alloca i64
  %tmp0 = call [2 x i64] @cerune.fn.values.0()
  store [2 x i64] %tmp0, ptr %cerune_$for_in_snapshot_0_54
  %tmp1 = load [2 x i64], ptr %cerune_$for_in_snapshot_0_54
  store i64 2, ptr %cerune_$for_in_length_0_54
  store i64 0, ptr %cerune_$for_in_cursor_0_54
  br label %block0
block0: ; for_condition
  %tmp2 = load i64, ptr %cerune_$for_in_cursor_0_54
  %tmp3 = load i64, ptr %cerune_$for_in_length_0_54
  %tmp4 = icmp slt i64 %tmp2, %tmp3
  br i1 %tmp4, label %block1, label %block3
block1: ; for_body
  %tmp5 = load i64, ptr %cerune_$for_in_cursor_0_54
  store i64 %tmp5, ptr %cerune_i
  %tmp6 = load [2 x i64], ptr %cerune_$for_in_snapshot_0_54
  %tmp7 = load i64, ptr %cerune_$for_in_cursor_0_54
  %tmp8 = call i64 @cerune.array.get.i64.2([2 x i64] %tmp6, i64 %tmp7, ptr @cerune.failure.20.69.85)
  store i64 %tmp8, ptr %cerune_value
  %tmp9 = load i64, ptr %cerune_i
  %tmp10 = icmp eq i64 %tmp9, 0
  br i1 %tmp10, label %block4, label %block6
block4: ; if_then
  br label %block2
block6: ; if_end
  %tmp11 = load i64, ptr %cerune_value
  %tmp12 = call i64 @cerune_i64_add(i64 %tmp11, i64 10, ptr @cerune.failure.29.141.151)
  store i64 %tmp12, ptr %cerune_value
  %tmp13 = load i64, ptr %cerune_value
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 %tmp13)
  br label %block2
block2: ; for_update
  %tmp14 = load i64, ptr %cerune_$for_in_cursor_0_54
  %tmp15 = call i64 @cerune_i64_add(i64 %tmp14, i64 1, ptr @cerune.failure.35.54.98)
  store i64 %tmp15, ptr %cerune_$for_in_cursor_0_54
  br label %block0
block3: ; for_end
  ret i32 0
}
