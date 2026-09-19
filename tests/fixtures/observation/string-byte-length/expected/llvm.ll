target triple = "x86_64-unknown-linux-gnu"

%cerune.string = type { ptr, i64 }
@cerune.string.0 = private unnamed_addr constant [4 x i8] c"\E6\97\A5\00"
@cerune.string.1 = private unnamed_addr constant [0 x i8] c""

@.fmt_i64 = private unnamed_addr constant [6 x i8] c"%lld\0A\00"
@.fmt_f32 = private unnamed_addr constant [6 x i8] c"%.9g\0A\00"
@.fmt_f64 = private unnamed_addr constant [7 x i8] c"%.17g\0A\00"

declare i32 @printf(ptr, ...)

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

define i32 @main() {
entry:
  %cerune_text = alloca %cerune.string
  store %cerune.string { ptr @cerune.string.0, i64 4 }, ptr %cerune_text
  %tmp0 = load %cerune.string, ptr %cerune_text
  %tmp1 = extractvalue %cerune.string %tmp0, 1
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 %tmp1)
  %tmp2 = extractvalue %cerune.string { ptr @cerune.string.1, i64 0 }, 1
  call i32 (ptr, ...) @printf(ptr @.fmt_i64, i64 %tmp2)
  ret i32 0
}
