; cerune-origins v1: UTF-8 byte ranges, end exclusive
; cerune-origin: synthetic
target triple = "x86_64-unknown-linux-gnu"

@cerune.failure.1.19.39.12 = private unnamed_addr constant [69 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\6C\6C\6F\63\61\74\69\6F\6E\2D\73\69\7A\65\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\31\20\62\79\74\65\73\3D\31\39\2E\2E\33\39\0A"
@cerune.failure.1.19.39.13 = private unnamed_addr constant [70 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\6C\6C\6F\63\61\74\69\6F\6E\2D\6C\69\6D\69\74\2D\65\78\63\65\65\64\65\64\20\6E\6F\64\65\3D\31\20\62\79\74\65\73\3D\31\39\2E\2E\33\39\0A"
@cerune.failure.1.19.39.14 = private unnamed_addr constant [62 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\6C\6C\6F\63\61\74\69\6F\6E\2D\66\61\69\6C\65\64\20\6E\6F\64\65\3D\31\20\62\79\74\65\73\3D\31\39\2E\2E\33\39\0A"
@cerune.failure.1.19.39 = private constant [15 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.1.19.39.12, i64 69 }, { ptr, i64 } { ptr @cerune.failure.1.19.39.13, i64 70 }, { ptr, i64 } { ptr @cerune.failure.1.19.39.14, i64 62 }]
@cerune.failure.7.70.87.12 = private unnamed_addr constant [69 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\6C\6C\6F\63\61\74\69\6F\6E\2D\73\69\7A\65\2D\6F\76\65\72\66\6C\6F\77\20\6E\6F\64\65\3D\37\20\62\79\74\65\73\3D\37\30\2E\2E\38\37\0A"
@cerune.failure.7.70.87.13 = private unnamed_addr constant [70 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\6C\6C\6F\63\61\74\69\6F\6E\2D\6C\69\6D\69\74\2D\65\78\63\65\65\64\65\64\20\6E\6F\64\65\3D\37\20\62\79\74\65\73\3D\37\30\2E\2E\38\37\0A"
@cerune.failure.7.70.87.14 = private unnamed_addr constant [62 x i8] c"\63\65\72\75\6E\65\3A\20\72\75\6E\74\69\6D\65\2D\76\31\20\63\6F\64\65\3D\61\6C\6C\6F\63\61\74\69\6F\6E\2D\66\61\69\6C\65\64\20\6E\6F\64\65\3D\37\20\62\79\74\65\73\3D\37\30\2E\2E\38\37\0A"
@cerune.failure.7.70.87 = private constant [15 x { ptr, i64 }] [{ ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } zeroinitializer, { ptr, i64 } { ptr @cerune.failure.7.70.87.12, i64 69 }, { ptr, i64 } { ptr @cerune.failure.7.70.87.13, i64 70 }, { ptr, i64 } { ptr @cerune.failure.7.70.87.14, i64 62 }]
%cerune.string = type { ptr, i64 }
@cerune.string.0 = private unnamed_addr constant [3 x i8] c"\E6\97\A5"
@cerune.string.1 = private unnamed_addr constant [3 x i8] c"\E6\9C\AC"
@cerune.string.2 = private unnamed_addr constant [1 x i8] c"\21"

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"

declare i32 @printf(ptr, ...)
declare void @llvm.trap()

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


@cerune.string.empty = private constant i8 0
@cerune.string.owners = internal global ptr null
@cerune.string.live = internal global i64 0
declare ptr @malloc(i64)
declare void @free(ptr)
declare ptr @memcpy(ptr, ptr, i64)
define internal void @cerune.string.retain(%cerune.string %value) {
entry:
  %data = extractvalue %cerune.string %value, 0
  %head = load ptr, ptr @cerune.string.owners
  br label %search
search:
  %p = phi ptr [ %head, %entry ], [ %next, %advance ]
  %end = icmp eq ptr %p, null
  br i1 %end, label %done, label %compare
compare:
  %bytes = getelementptr i8, ptr %p, i64 24
  %match = icmp eq ptr %bytes, %data
  br i1 %match, label %retain, label %advance
advance:
  %next = load ptr, ptr %p
  br label %search
retain:
  %ref = getelementptr i8, ptr %p, i64 8
  %count = load i64, ptr %ref
  %more = add i64 %count, 1
  store i64 %more, ptr %ref
  br label %done
done:
  ret void
}
define internal void @cerune.string.release(%cerune.string %value) {
entry:
  %data = extractvalue %cerune.string %value, 0
  br label %search
search:
  %link = phi ptr [ @cerune.string.owners, %entry ], [ %p, %advance ]
  %p = load ptr, ptr %link
  %end = icmp eq ptr %p, null
  br i1 %end, label %done, label %compare
compare:
  %bytes = getelementptr i8, ptr %p, i64 24
  %match = icmp eq ptr %bytes, %data
  br i1 %match, label %release, label %advance
advance:
  br label %search
release:
  %ref = getelementptr i8, ptr %p, i64 8
  %count = load i64, ptr %ref
  %less = sub i64 %count, 1
  store i64 %less, ptr %ref
  %last = icmp eq i64 %less, 0
  br i1 %last, label %destroy, label %done
destroy:
  %next = load ptr, ptr %p
  store ptr %next, ptr %link
  %lenptr = getelementptr i8, ptr %p, i64 16
  %len = load i64, ptr %lenptr
  %live = load i64, ptr @cerune.string.live
  %remaining = sub i64 %live, %len
  store i64 %remaining, ptr @cerune.string.live
  call void @free(ptr %p)
  br label %done
done:
  ret void
}
define internal %cerune.string @cerune.string.concat(%cerune.string %left, %cerune.string %right, ptr %failure) {
entry:
  %left.len = extractvalue %cerune.string %left, 1
  %right.len = extractvalue %cerune.string %right, 1
  %space = sub i64 9223372036854775783, %left.len
  %overflow = icmp ugt i64 %right.len, %space
  br i1 %overflow, label %size.fail, label %sum
sum:
  %length = add i64 %left.len, %right.len
  %empty = icmp eq i64 %length, 0
  br i1 %empty, label %zero, label %budget
zero:
  ret %cerune.string { ptr @cerune.string.empty, i64 0 }
budget:
  %live = load i64, ptr @cerune.string.live
  %available = sub i64 67108864, %live
  %over = icmp ugt i64 %length, %available
  br i1 %over, label %limit.fail, label %allocate
allocate:
  %size = add i64 %length, 24
  %p = call ptr @malloc(i64 %size)
  %failed = icmp eq ptr %p, null
  br i1 %failed, label %allocation.fail, label %copy
copy:
  %head = load ptr, ptr @cerune.string.owners
  store ptr %head, ptr %p
  %ref = getelementptr i8, ptr %p, i64 8
  store i64 1, ptr %ref
  %lenptr = getelementptr i8, ptr %p, i64 16
  store i64 %length, ptr %lenptr
  %data = getelementptr i8, ptr %p, i64 24
  %left.data = extractvalue %cerune.string %left, 0
  %right.data = extractvalue %cerune.string %right, 0
  call ptr @memcpy(ptr %data, ptr %left.data, i64 %left.len)
  %suffix = getelementptr i8, ptr %data, i64 %left.len
  call ptr @memcpy(ptr %suffix, ptr %right.data, i64 %right.len)
  store ptr %p, ptr @cerune.string.owners
  %total = add i64 %live, %length
  store i64 %total, ptr @cerune.string.live
  %result.data = insertvalue %cerune.string poison, ptr %data, 0
  %result = insertvalue %cerune.string %result.data, i64 %length, 1
  ret %cerune.string %result
size.fail:
  call void @cerune.runtime.fail(ptr %failure, i64 12)
  unreachable
limit.fail:
  call void @cerune.runtime.fail(ptr %failure, i64 13)
  unreachable
allocation.fail:
  call void @cerune.runtime.fail(ptr %failure, i64 14)
  unreachable
}
; cerune-origin: synthetic
define %cerune.string @cerune.fn._ownership0.0() {
entry:
  %cerune_$read2 = alloca %cerune.string
  %cerune_$read3 = alloca %cerune.string
  %cerune_$owned4 = alloca %cerune.string
; cerune-origin: #14 bytes 26..31
  store %cerune.string { ptr @cerune.string.0, i64 3 }, ptr %cerune_$read2
; cerune-origin: #16 bytes 33..38
  store %cerune.string { ptr @cerune.string.1, i64 3 }, ptr %cerune_$read3
; cerune-origin: #15 bytes 26..31
  %tmp0 = load %cerune.string, ptr %cerune_$read2
; cerune-origin: #17 bytes 33..38
  %tmp1 = load %cerune.string, ptr %cerune_$read3
; cerune-origin: #1 bytes 19..39
  %tmp2 = call %cerune.string @cerune.string.concat(%cerune.string %tmp0, %cerune.string %tmp1, ptr @cerune.failure.1.19.39)
; cerune-origin: #18 bytes 19..39
  store %cerune.string %tmp2, ptr %cerune_$owned4
; cerune-origin: #19 bytes 19..39
  %tmp3 = load %cerune.string, ptr %cerune_$owned4
; cerune-origin: #20 bytes 19..39
  ret %cerune.string %tmp3
}

; cerune-origin: synthetic
define %cerune.string @cerune.fn._ownership1.1(%cerune.string %arg0) {
entry:
  %cerune_$owned5 = alloca %cerune.string
  %cerune_$read6 = alloca %cerune.string
  %cerune_$owned7 = alloca %cerune.string
  store %cerune.string %arg0, ptr %cerune_$owned5
; cerune-origin: #5 bytes 57..61
  %tmp0 = load %cerune.string, ptr %cerune_$owned5
; cerune-origin: #22 bytes 57..61
  store %cerune.string %tmp0, ptr %cerune_$read6
; cerune-origin: #23 bytes 57..61
  %tmp1 = load %cerune.string, ptr %cerune_$read6
; cerune-origin: #24 bytes 57..61
  store %cerune.string %tmp1, ptr %cerune_$owned7
; cerune-origin: #25 bytes 57..61
  %tmp2 = load %cerune.string, ptr %cerune_$owned7
; cerune-origin: #26 bytes 57..61
  call void @cerune.string.retain(%cerune.string %tmp2)
; cerune-origin: #27 bytes 57..61
  %tmp3 = load %cerune.string, ptr %cerune_$owned7
; cerune-origin: #28 bytes 57..61
  ret %cerune.string %tmp3
}

; cerune-origin: synthetic
define %cerune.string @cerune.fn._ownership2.2(%cerune.string %arg0) {
entry:
  %cerune_$owned8 = alloca %cerune.string
  %cerune_$read9 = alloca %cerune.string
  %cerune_$read10 = alloca %cerune.string
  %cerune_$owned11 = alloca %cerune.string
  store %cerune.string %arg0, ptr %cerune_$owned8
; cerune-origin: #8 bytes 77..81
  %tmp0 = load %cerune.string, ptr %cerune_$owned8
; cerune-origin: #32 bytes 77..81
  store %cerune.string %tmp0, ptr %cerune_$read9
; cerune-origin: #34 bytes 83..86
  store %cerune.string { ptr @cerune.string.2, i64 1 }, ptr %cerune_$read10
; cerune-origin: #33 bytes 77..81
  %tmp1 = load %cerune.string, ptr %cerune_$read9
; cerune-origin: #35 bytes 83..86
  %tmp2 = load %cerune.string, ptr %cerune_$read10
; cerune-origin: #7 bytes 70..87
  %tmp3 = call %cerune.string @cerune.string.concat(%cerune.string %tmp1, %cerune.string %tmp2, ptr @cerune.failure.7.70.87)
; cerune-origin: #36 bytes 70..87
  store %cerune.string %tmp3, ptr %cerune_$owned11
; cerune-origin: #37 bytes 70..87
  %tmp4 = load %cerune.string, ptr %cerune_$owned11
; cerune-origin: #38 bytes 70..87
  ret %cerune.string %tmp4
}

; cerune-origin: synthetic
define %cerune.string @cerune.fn._ownership3.3(%cerune.string %arg0, %cerune.string %arg1) {
entry:
  %cerune_$owned12 = alloca %cerune.string
  %cerune_$owned13 = alloca %cerune.string
  store %cerune.string %arg0, ptr %cerune_$owned12
  store %cerune.string %arg1, ptr %cerune_$owned13
; cerune-origin: #41 bytes 70..87
  %tmp0 = load %cerune.string, ptr %cerune_$owned12
; cerune-origin: #42 bytes 70..87
  call void @cerune.string.release(%cerune.string %tmp0)
; cerune-origin: #43 bytes 70..87
  %tmp1 = load %cerune.string, ptr %cerune_$owned13
; cerune-origin: #44 bytes 70..87
  ret %cerune.string %tmp1
}

; cerune-origin: synthetic
define i32 @main() {
entry:
  %cerune_text = alloca %cerune.string
  %cerune_saved = alloca %cerune.string
  %cerune_$read14 = alloca %cerune.string
  %cerune_$read15 = alloca %cerune.string
; cerune-origin: #21 bytes 19..39
  %tmp0 = call %cerune.string @cerune.fn._ownership0.0()
; cerune-origin: #0 bytes 0..40
  store %cerune.string %tmp0, ptr %cerune_text
; cerune-origin: #29 bytes 57..61
  %tmp1 = load %cerune.string, ptr %cerune_text
; cerune-origin: #30 bytes 57..61
  %tmp2 = call %cerune.string @cerune.fn._ownership1.1(%cerune.string %tmp1)
; cerune-origin: #4 bytes 41..62
  store %cerune.string %tmp2, ptr %cerune_saved
; cerune-origin: #31 bytes 63..88
  %tmp3 = load %cerune.string, ptr %cerune_text
; cerune-origin: #39 bytes 77..81
  %tmp4 = load %cerune.string, ptr %cerune_text
; cerune-origin: #40 bytes 70..87
  %tmp5 = call %cerune.string @cerune.fn._ownership2.2(%cerune.string %tmp4)
; cerune-origin: #45 bytes 70..87
  %tmp6 = call %cerune.string @cerune.fn._ownership3.3(%cerune.string %tmp3, %cerune.string %tmp5)
; cerune-origin: #6 bytes 63..88
  store %cerune.string %tmp6, ptr %cerune_text
; cerune-origin: #11 bytes 95..100
  %tmp7 = load %cerune.string, ptr %cerune_saved
; cerune-origin: #46 bytes 95..100
  store %cerune.string %tmp7, ptr %cerune_$read14
; cerune-origin: #48 bytes 95..100
  %tmp8 = load %cerune.string, ptr %cerune_$read14
; cerune-origin: #10 bytes 89..102
  call void @cerune.print.string(%cerune.string %tmp8)
; cerune-origin: #13 bytes 109..113
  %tmp9 = load %cerune.string, ptr %cerune_text
; cerune-origin: #49 bytes 109..113
  store %cerune.string %tmp9, ptr %cerune_$read15
; cerune-origin: #51 bytes 109..113
  %tmp10 = load %cerune.string, ptr %cerune_$read15
; cerune-origin: #12 bytes 103..115
  call void @cerune.print.string(%cerune.string %tmp10)
; cerune-origin: #52 bytes 41..62
  %tmp11 = load %cerune.string, ptr %cerune_saved
; cerune-origin: #53 bytes 41..62
  call void @cerune.string.release(%cerune.string %tmp11)
; cerune-origin: #54 bytes 0..40
  %tmp12 = load %cerune.string, ptr %cerune_text
; cerune-origin: #55 bytes 0..40
  call void @cerune.string.release(%cerune.string %tmp12)
; cerune-origin: synthetic
  ret i32 0
}
