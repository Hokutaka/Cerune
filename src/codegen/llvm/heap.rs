//! 不変文字列のruntime。動的領域をリストで識別し、静的データへヘッダーアクセスしません。
pub(super) fn support(limit: u64) -> String {
    SOURCE.replace("@LIMIT@", &limit.to_string())
}
const SOURCE: &str = r#"
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
  %available = sub i64 @LIMIT@, %live
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
"#;
