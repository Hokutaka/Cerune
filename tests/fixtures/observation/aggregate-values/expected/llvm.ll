target triple = "x86_64-unknown-linux-gnu"

@cerune.failure.52.70.84.11 = private unnamed_addr constant [71 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\72\72\61\79\2D\69\6E\64\65\78\2D\6F\75\74\2D\6F\66\2D\62\6F\75\6E\64\73\20\6E\6F\64\65\3D\35\32\20\62\79\74\65\73\3D\37\30\2E\2E\38\34\0A"
@cerune.failure.52.70.84 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.52.70.84.11, i64 71 }]
@cerune.failure.55.70.84.11 = private unnamed_addr constant [71 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\72\72\61\79\2D\69\6E\64\65\78\2D\6F\75\74\2D\6F\66\2D\62\6F\75\6E\64\73\20\6E\6F\64\65\3D\35\35\20\62\79\74\65\73\3D\37\30\2E\2E\38\34\0A"
@cerune.failure.55.70.84 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.55.70.84.11, i64 71 }]
@cerune.failure.63.70.84.0 = private unnamed_addr constant [62 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\69\6E\74\65\67\65\72\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\36\33\20\62\79\74\65\73\3D\37\30\2E\2E\38\34\0A"
@cerune.failure.63.70.84 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } { ptr @cerune.failure.63.70.84.0, i64 62 }, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer]
@cerune.failure.41.254.256.0 = private unnamed_addr constant [64 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\69\6E\74\65\67\65\72\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\34\31\20\62\79\74\65\73\3D\32\35\34\2E\2E\32\35\36\0A"
@cerune.failure.41.254.256 = private constant [12 x { ptr, i64 }] [{ ptr, i64 } { ptr @cerune.failure.41.254.256.0, i64 64 }, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer]
%cerune.string = type { ptr, i64 }
@cerune.string.0 = private unnamed_addr constant [5 x i8] c"\56\61\6C\75\65"
@cerune.string.1 = private unnamed_addr constant [1 x i8] c"\7B"
@cerune.string.2 = private unnamed_addr constant [3 x i8] c"\6E\3A\20"
@cerune.string.3 = private unnamed_addr constant [1 x i8] c"\7D"
@cerune.string.4 = private unnamed_addr constant [5 x i8] c"\45\6D\70\74\79"
@cerune.string.5 = private unnamed_addr constant [1 x i8] c"\7B"
@cerune.string.6 = private unnamed_addr constant [1 x i8] c"\7D"
@cerune.string.7 = private unnamed_addr constant [0 x i8] c""

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"
%cerune.type.Item.0 = type { i64, i64 }
@.bool_true = private unnamed_addr constant [5 x i8] c"true\00"
@.bool_false = private unnamed_addr constant [6 x i8] c"false\00"

declare i32 @printf(ptr, ...)
declare i32 @puts(ptr)
declare void @llvm.trap()
declare { i64, i1 } @llvm.sadd.with.overflow.i64(i64, i64)
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

declare i32 @putchar(i32)

define internal i1 @cerune.string.equal(%cerune.string %left, %cerune.string %right) {
entry:
  %left.data = extractvalue %cerune.string %left, 0
  %left.length = extractvalue %cerune.string %left, 1
  %right.data = extractvalue %cerune.string %right, 0
  %right.length = extractvalue %cerune.string %right, 1
  %same.length = icmp eq i64 %left.length, %right.length
  br i1 %same.length, label %condition, label %different
condition:
  %index = phi i64 [ 0, %entry ], [ %next, %advance ]
  %done = icmp eq i64 %index, %left.length
  br i1 %done, label %equal, label %compare
compare:
  %left.ptr = getelementptr inbounds i8, ptr %left.data, i64 %index
  %right.ptr = getelementptr inbounds i8, ptr %right.data, i64 %index
  %left.byte = load i8, ptr %left.ptr
  %right.byte = load i8, ptr %right.ptr
  %same.byte = icmp eq i8 %left.byte, %right.byte
  br i1 %same.byte, label %advance, label %different
advance:
  %next = add i64 %index, 1
  br label %condition
equal:
  ret i1 true
different:
  ret i1 false
}

define internal void @cerune.print.string(%cerune.string %value) {
entry:
  %data = extractvalue %cerune.string %value, 0
  %length = extractvalue %cerune.string %value, 1
  br label %condition
condition:
  %index = phi i64 [ 0, %entry ], [ %next, %write ]
  %done = icmp eq i64 %index, %length
  br i1 %done, label %newline, label %write
write:
  %ptr = getelementptr inbounds i8, ptr %data, i64 %index
  %byte = load i8, ptr %ptr
  %character = zext i8 %byte to i32
  call i32 @putchar(i32 %character)
  %next = add i64 %index, 1
  br label %condition
newline:
  call i32 @putchar(i32 10)
  ret void
}

@.write_i64 = private unnamed_addr constant [5 x i8] c"%lld\00"
@.write_u64 = private unnamed_addr constant [5 x i8] c"%llu\00"
@.write_f32 = private unnamed_addr constant [5 x i8] c"%.9g\00"
@.write_f64 = private unnamed_addr constant [6 x i8] c"%.17g\00"
@.write_true = private unnamed_addr constant [5 x i8] c"true\00"
@.write_false = private unnamed_addr constant [6 x i8] c"false\00"
@.write_bool = private unnamed_addr constant [3 x i8] c"%s\00"
define internal void @cerune.write.i64(i64 %value) {
entry:
  call i32 (ptr, ...) @printf(ptr @.write_i64, i64 %value)
  ret void
}
define internal void @cerune.write.u64(i64 %value) {
entry:
  call i32 (ptr, ...) @printf(ptr @.write_u64, i64 %value)
  ret void
}
define internal void @cerune.write.f32(float %value) {
entry:
  %wide = fpext float %value to double
  call i32 (ptr, ...) @printf(ptr @.write_f32, double %wide)
  ret void
}
define internal void @cerune.write.f64(double %value) {
entry:
  call i32 (ptr, ...) @printf(ptr @.write_f64, double %value)
  ret void
}
define internal void @cerune.write.bool(i1 %value) {
entry:
  %text = select i1 %value, ptr @.write_true, ptr @.write_false
  call i32 (ptr, ...) @printf(ptr @.write_bool, ptr %text)
  ret void
}
define internal void @cerune.write.escaped.byte(i32 %value) {
entry:
  switch i32 %value, label %plain [
    i32 0, label %escape0
    i32 1, label %escape1
    i32 2, label %escape2
    i32 3, label %escape3
    i32 4, label %escape4
    i32 5, label %escape5
    i32 6, label %escape6
    i32 7, label %escape7
    i32 8, label %escape8
    i32 9, label %escape9
    i32 10, label %escape10
    i32 11, label %escape11
    i32 12, label %escape12
    i32 13, label %escape13
    i32 14, label %escape14
    i32 15, label %escape15
    i32 16, label %escape16
    i32 17, label %escape17
    i32 18, label %escape18
    i32 19, label %escape19
    i32 20, label %escape20
    i32 21, label %escape21
    i32 22, label %escape22
    i32 23, label %escape23
    i32 24, label %escape24
    i32 25, label %escape25
    i32 26, label %escape26
    i32 27, label %escape27
    i32 28, label %escape28
    i32 29, label %escape29
    i32 30, label %escape30
    i32 31, label %escape31
    i32 34, label %escape34
    i32 92, label %escape92
    i32 127, label %escape127
  ]
plain:
  call i32 @putchar(i32 %value)
  ret void
escape0:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 48)
  ret void
escape1:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 125)
  ret void
escape2:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 50)
  call i32 @putchar(i32 125)
  ret void
escape3:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 51)
  call i32 @putchar(i32 125)
  ret void
escape4:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 52)
  call i32 @putchar(i32 125)
  ret void
escape5:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 53)
  call i32 @putchar(i32 125)
  ret void
escape6:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 54)
  call i32 @putchar(i32 125)
  ret void
escape7:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 55)
  call i32 @putchar(i32 125)
  ret void
escape8:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 56)
  call i32 @putchar(i32 125)
  ret void
escape9:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 116)
  ret void
escape10:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 110)
  ret void
escape11:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 98)
  call i32 @putchar(i32 125)
  ret void
escape12:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 99)
  call i32 @putchar(i32 125)
  ret void
escape13:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 114)
  ret void
escape14:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 101)
  call i32 @putchar(i32 125)
  ret void
escape15:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 102)
  call i32 @putchar(i32 125)
  ret void
escape16:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 48)
  call i32 @putchar(i32 125)
  ret void
escape17:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 125)
  ret void
escape18:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 50)
  call i32 @putchar(i32 125)
  ret void
escape19:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 51)
  call i32 @putchar(i32 125)
  ret void
escape20:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 52)
  call i32 @putchar(i32 125)
  ret void
escape21:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 53)
  call i32 @putchar(i32 125)
  ret void
escape22:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 54)
  call i32 @putchar(i32 125)
  ret void
escape23:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 55)
  call i32 @putchar(i32 125)
  ret void
escape24:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 56)
  call i32 @putchar(i32 125)
  ret void
escape25:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 57)
  call i32 @putchar(i32 125)
  ret void
escape26:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 97)
  call i32 @putchar(i32 125)
  ret void
escape27:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 98)
  call i32 @putchar(i32 125)
  ret void
escape28:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 99)
  call i32 @putchar(i32 125)
  ret void
escape29:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 100)
  call i32 @putchar(i32 125)
  ret void
escape30:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 101)
  call i32 @putchar(i32 125)
  ret void
escape31:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 49)
  call i32 @putchar(i32 102)
  call i32 @putchar(i32 125)
  ret void
escape34:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 34)
  ret void
escape92:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 92)
  ret void
escape127:
  call i32 @putchar(i32 92)
  call i32 @putchar(i32 117)
  call i32 @putchar(i32 123)
  call i32 @putchar(i32 55)
  call i32 @putchar(i32 102)
  call i32 @putchar(i32 125)
  ret void
}
define internal void @cerune.write.string(%cerune.string %value) {
entry:
  %data = extractvalue %cerune.string %value, 0
  %length = extractvalue %cerune.string %value, 1
  br label %condition
condition:
  %index = phi i64 [ 0, %entry ], [ %next, %write ]
  %done = icmp eq i64 %index, %length
  br i1 %done, label %end, label %write
write:
  %ptr = getelementptr inbounds i8, ptr %data, i64 %index
  %byte = load i8, ptr %ptr
  %character = zext i8 %byte to i32
  call i32 @putchar(i32 %character)
  %next = add i64 %index, 1
  br label %condition
end:
  ret void
}
define internal void @cerune.write.quoted(%cerune.string %value) {
entry:
  %data = extractvalue %cerune.string %value, 0
  %length = extractvalue %cerune.string %value, 1
  call i32 @putchar(i32 34)
  br label %condition
condition:
  %index = phi i64 [ 0, %entry ], [ %next, %write ]
  %done = icmp eq i64 %index, %length
  br i1 %done, label %end, label %write
write:
  %ptr = getelementptr inbounds i8, ptr %data, i64 %index
  %byte = load i8, ptr %ptr
  %character = zext i8 %byte to i32
  call void @cerune.write.escaped.byte(i32 %character)
  %next = add i64 %index, 1
  br label %condition
end:
  call i32 @putchar(i32 34)
  ret void
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

define i1 @cerune.fn._equal0.0([2 x i64] %arg0, [2 x i64] %arg1) {
entry:
  %cerune_$left = alloca [2 x i64]
  %cerune_$right = alloca [2 x i64]
  %cerune_$index = alloca i64
  store [2 x i64] %arg0, ptr %cerune_$left
  store [2 x i64] %arg1, ptr %cerune_$right
  store i64 0, ptr %cerune_$index
  br label %block0
block0: ; for_condition
  %tmp0 = load i64, ptr %cerune_$index
  %tmp1 = icmp slt i64 %tmp0, 2
  br i1 %tmp1, label %block1, label %block3
block1: ; for_body
  %tmp2 = load [2 x i64], ptr %cerune_$left
  %tmp3 = load i64, ptr %cerune_$index
  %tmp4 = call i64 @cerune.array.get.i64.2([2 x i64] %tmp2, i64 %tmp3, ptr @cerune.failure.52.70.84)
  %tmp5 = load [2 x i64], ptr %cerune_$right
  %tmp6 = load i64, ptr %cerune_$index
  %tmp7 = call i64 @cerune.array.get.i64.2([2 x i64] %tmp5, i64 %tmp6, ptr @cerune.failure.55.70.84)
  %tmp8 = icmp eq i64 %tmp4, %tmp7
  %tmp9 = xor i1 %tmp8, 1
  br i1 %tmp9, label %block4, label %block6
block4: ; if_then
  ret i1 0
block6: ; if_end
  br label %block2
block2: ; for_update
  %tmp10 = load i64, ptr %cerune_$index
  %tmp11 = call i64 @cerune_i64_add(i64 %tmp10, i64 1, ptr @cerune.failure.63.70.84)
  store i64 %tmp11, ptr %cerune_$index
  br label %block0
block3: ; for_end
  ret i1 1
}

define i1 @cerune.fn._match_bind1.1(%cerune.type.Item.0 %arg0) {
entry:
  %cerune_$capture1 = alloca %cerune.type.Item.0
  %cerune_n = alloca i64
  store %cerune.type.Item.0 %arg0, ptr %cerune_$capture1
  %tmp0 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp1 = extractvalue %cerune.type.Item.0 %tmp0, 1
  store i64 %tmp1, ptr %cerune_n
  %tmp2 = load i64, ptr %cerune_n
  %tmp3 = icmp sgt i64 %tmp2, 0
  ret i1 %tmp3
}

define i64 @cerune.fn._match_bind2.2(%cerune.type.Item.0 %arg0) {
entry:
  %cerune_$capture1 = alloca %cerune.type.Item.0
  %cerune_n = alloca i64
  store %cerune.type.Item.0 %arg0, ptr %cerune_$capture1
  %tmp0 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp1 = extractvalue %cerune.type.Item.0 %tmp0, 1
  store i64 %tmp1, ptr %cerune_n
  %tmp2 = load i64, ptr %cerune_n
  ret i64 %tmp2
}

define i64 @cerune.fn._match_select3.3(%cerune.type.Item.0 %arg0) {
entry:
  %cerune_$capture1 = alloca %cerune.type.Item.0
  store %cerune.type.Item.0 %arg0, ptr %cerune_$capture1
  %tmp0 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp1 = extractvalue %cerune.type.Item.0 %tmp0, 0
  %tmp2 = icmp eq i64 %tmp1, 0
  br i1 %tmp2, label %block0, label %block1
block0: ; if_then
  ret i64 0
block1: ; if_else
  %tmp3 = call i64 @cerune_i64_sub(i64 0, i64 1, ptr @cerune.failure.41.254.256)
  ret i64 %tmp3
}

define i64 @cerune.fn._match_select4.4(%cerune.type.Item.0 %arg0) {
entry:
  %cerune_$capture1 = alloca %cerune.type.Item.0
  %cerune_logical_result1 = alloca i1
  store %cerune.type.Item.0 %arg0, ptr %cerune_$capture1
  %tmp0 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp1 = extractvalue %cerune.type.Item.0 %tmp0, 0
  %tmp2 = icmp eq i64 %tmp1, 0
  store i1 %tmp2, ptr %cerune_logical_result1
  br i1 %tmp2, label %block0, label %block1
block0: ; logical_rhs
  %tmp3 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp4 = call i1 @cerune.fn._match_bind1.1(%cerune.type.Item.0 %tmp3)
  store i1 %tmp4, ptr %cerune_logical_result1
  br label %block1
block1: ; logical_end
  %tmp5 = load i1, ptr %cerune_logical_result1
  br i1 %tmp5, label %block2, label %block3
block2: ; if_then
  %tmp6 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp7 = call i64 @cerune.fn._match_bind2.2(%cerune.type.Item.0 %tmp6)
  ret i64 %tmp7
block3: ; if_else
  %tmp8 = load %cerune.type.Item.0, ptr %cerune_$capture1
  %tmp9 = call i64 @cerune.fn._match_select3.3(%cerune.type.Item.0 %tmp8)
  ret i64 %tmp9
}

define i64 @cerune.fn._match_bind5.5() {
entry:
  %cerune_$match0 = alloca %cerune.type.Item.0
  %tmp0 = insertvalue %cerune.type.Item.0 poison, i64 0, 0
  %tmp1 = insertvalue %cerune.type.Item.0 %tmp0, i64 7, 1
  store %cerune.type.Item.0 %tmp1, ptr %cerune_$match0
  %tmp2 = load %cerune.type.Item.0, ptr %cerune_$match0
  %tmp3 = call i64 @cerune.fn._match_select4.4(%cerune.type.Item.0 %tmp2)
  ret i64 %tmp3
}

define void @cerune.fn._display6.6(%cerune.type.Item.0 %arg0) {
entry:
  %cerune_$value = alloca %cerune.type.Item.0
  store %cerune.type.Item.0 %arg0, ptr %cerune_$value
  %tmp0 = load %cerune.type.Item.0, ptr %cerune_$value
  %tmp1 = extractvalue %cerune.type.Item.0 %tmp0, 0
  %tmp2 = icmp eq i64 %tmp1, 0
  br i1 %tmp2, label %block0, label %block2
block0: ; if_then
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.0, i64 5 })
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.1, i64 1 })
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.2, i64 3 })
  %tmp3 = load %cerune.type.Item.0, ptr %cerune_$value
  %tmp4 = extractvalue %cerune.type.Item.0 %tmp3, 1
  call void @cerune.write.i64(i64 %tmp4)
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.3, i64 1 })
  br label %block2
block2: ; if_end
  %tmp5 = load %cerune.type.Item.0, ptr %cerune_$value
  %tmp6 = extractvalue %cerune.type.Item.0 %tmp5, 0
  %tmp7 = icmp eq i64 %tmp6, 1
  br i1 %tmp7, label %block3, label %block5
block3: ; if_then
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.4, i64 5 })
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.5, i64 1 })
  call void @cerune.write.string(%cerune.string { ptr @cerune.string.6, i64 1 })
  br label %block5
block5: ; if_end
  call void @cerune.print.string(%cerune.string { ptr @cerune.string.7, i64 0 })
  ret void
}

define i32 @main() {
entry:
  %cerune_left = alloca [2 x i64]
  %cerune_result = alloca i64
  %tmp0 = insertvalue [2 x i64] poison, i64 1, 0
  %tmp1 = insertvalue [2 x i64] %tmp0, i64 2, 1
  store [2 x i64] %tmp1, ptr %cerune_left
  %tmp2 = load [2 x i64], ptr %cerune_left
  %tmp3 = insertvalue [2 x i64] poison, i64 1, 0
  %tmp4 = insertvalue [2 x i64] %tmp3, i64 3, 1
  %tmp5 = call i1 @cerune.fn._equal0.0([2 x i64] %tmp2, [2 x i64] %tmp4)
  %tmp6 = select i1 %tmp5, ptr @.bool_true, ptr @.bool_false
  call i32 @puts(ptr %tmp6)
  %tmp7 = insertvalue %cerune.type.Item.0 poison, i64 0, 0
  %tmp8 = insertvalue %cerune.type.Item.0 %tmp7, i64 7, 1
  call void @cerune.fn._display6.6(%cerune.type.Item.0 %tmp8)
  %tmp9 = call i64 @cerune.fn._match_bind5.5()
  store i64 %tmp9, ptr %cerune_result
  %tmp10 = load i64, ptr %cerune_result
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 %tmp10)
  ret i32 0
}
