target triple = "x86_64-unknown-linux-gnu"

@.fmt_u64 = private unnamed_addr constant [6 x i8] c"%llu\0A\00"
@cerune.failure.19.172.174.0 = private unnamed_addr constant [64 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\69\6E\74\65\67\65\72\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\31\39\20\62\79\74\65\73\3D\31\37\32\2E\2E\31\37\34\0A"
@cerune.failure.19.172.174 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } { ptr @cerune.failure.19.172.174.0, i64 64 }, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer]
@cerune.failure.4.60.69.11 = private unnamed_addr constant [70 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\72\72\61\79\2D\69\6E\64\65\78\2D\6F\75\74\2D\6F\66\2D\62\6F\75\6E\64\73\20\6E\6F\64\65\3D\34\20\62\79\74\65\73\3D\36\30\2E\2E\36\39\0A"
@cerune.failure.4.60.69 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.4.60.69.11, i64 70 }]
@cerune.failure.8.60.69.11 = private unnamed_addr constant [70 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\72\72\61\79\2D\69\6E\64\65\78\2D\6F\75\74\2D\6F\66\2D\62\6F\75\6E\64\73\20\6E\6F\64\65\3D\38\20\62\79\74\65\73\3D\36\30\2E\2E\36\39\0A"
@cerune.failure.8.60.69 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.8.60.69.11, i64 70 }]
@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"

declare i32 @printf(ptr, ...)
declare void @llvm.trap()
declare { i64, i1 } @llvm.ssub.with.overflow.i64(i64, i64)

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

define internal i64 @cerune_i64_sub(i64 %left, i64 %right, ptr %failure) {
entry:
  %checked = call { i64, i1 } @llvm.ssub.with.overflow.i64(i64 %left, i64 %right)
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

define internal i64 @cerune.array.get.i64.1([1 x i64] %value, i64 %index, ptr %failure) {
entry:
  %index.low = icmp slt i64 %index, 0
  %index.high = icmp sge i64 %index, 1
  %index.outside = or i1 %index.low, %index.high
  br i1 %index.outside, label %out_of_bounds, label %in_bounds
out_of_bounds:
  call void @cerune.runtime.fail(ptr %failure, i64 11)
  unreachable
in_bounds:
  %array = alloca [1 x i64]
  store [1 x i64] %value, ptr %array
  %element = getelementptr inbounds [1 x i64], ptr %array, i64 0, i64 %index
  %result = load i64, ptr %element
  ret i64 %result
}

define i64 @cerune.fn._generic_0_first.0([2 x i64] %arg0) {
entry:
  %cerune_values = alloca [2 x i64]
  store [2 x i64] %arg0, ptr %cerune_values
  %tmp0 = load [2 x i64], ptr %cerune_values
  %tmp1 = call i64 @cerune.array.get.i64.2([2 x i64] %tmp0, i64 0, ptr @cerune.failure.4.60.69)
  ret i64 %tmp1
}

define i64 @cerune.fn._generic_1_first.1([1 x i64] %arg0) {
entry:
  %cerune_values = alloca [1 x i64]
  store [1 x i64] %arg0, ptr %cerune_values
  %tmp0 = load [1 x i64], ptr %cerune_values
  %tmp1 = call i64 @cerune.array.get.i64.1([1 x i64] %tmp0, i64 0, ptr @cerune.failure.8.60.69)
  ret i64 %tmp1
}

define i32 @main() {
entry:
  %tmp0 = insertvalue [2 x i64] poison, i64 -1, 0
  %tmp1 = insertvalue [2 x i64] %tmp0, i64 1, 1
  %tmp2 = call i64 @cerune.fn._generic_0_first.0([2 x i64] %tmp1)
  call i32 (ptr, ...) @printf(ptr @.fmt_u64, i64 %tmp2)
  %tmp3 = call i64 @cerune_i64_sub(i64 0, i64 7, ptr @cerune.failure.19.172.174)
  %tmp4 = insertvalue [1 x i64] poison, i64 %tmp3, 0
  %tmp5 = call i64 @cerune.fn._generic_1_first.1([1 x i64] %tmp4)
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 %tmp5)
  %tmp6 = insertvalue [2 x i64] poison, i64 42, 0
  %tmp7 = insertvalue [2 x i64] %tmp6, i64 0, 1
  %tmp8 = call i64 @cerune.fn._generic_0_first.0([2 x i64] %tmp7)
  call i32 (ptr, ...) @printf(ptr @.fmt_u64, i64 %tmp8)
  ret i32 0
}
