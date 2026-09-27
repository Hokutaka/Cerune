//! 長さ付き文字列のうち動的領域だけを共有・解放します。
pub(super) fn support(limit: u64) -> String {
    SOURCE.replace("@LIMIT@", &limit.to_string())
}
const SOURCE: &str = r#"
data $cerune_string_owners = align 8 { l 0 }
data $cerune_string_live = align 8 { l 0 }
section ".rodata" data $cerune_string_empty = align 8 { l 0 }
function $cerune_string_retain(l %value) {
@start
  %head =l loadl $cerune_string_owners
  jmp @search
@search
  %p =l phi @start %head, @advance %next
  %end =w ceql %p, 0
  jnz %end, @done, @compare
@compare
  %string =l add %p, 16
  %match =w ceql %string, %value
  jnz %match, @retain, @advance
@advance
  %next =l loadl %p
  jmp @search
@retain
  %ref =l add %p, 8
  %count =l loadl %ref
  %more =l add %count, 1
  storel %more, %ref
@done
  ret
}
function $cerune_string_release(l %value) {
@start
  jmp @search
@search
  %link =l phi @start $cerune_string_owners, @advance %p
  %p =l loadl %link
  %end =w ceql %p, 0
  jnz %end, @done, @compare
@compare
  %string =l add %p, 16
  %match =w ceql %string, %value
  jnz %match, @release, @advance
@advance
  jmp @search
@release
  %ref =l add %p, 8
  %count =l loadl %ref
  %less =l sub %count, 1
  storel %less, %ref
  %last =w ceql %less, 0
  jnz %last, @destroy, @done
@destroy
  %next =l loadl %p
  storel %next, %link
  %length =l loadl %string
  %live =l loadl $cerune_string_live
  %remaining =l sub %live, %length
  storel %remaining, $cerune_string_live
  call $free(l %p)
@done
  ret
}
function l $cerune_string_concat(l %left, l %right, l %origin, l %origin_len) {
@start
  %left_len =l loadl %left
  %right_len =l loadl %right
  %space =l sub 9223372036854775783, %left_len
  %overflow =w cugtl %right_len, %space
  jnz %overflow, @size_fail, @sum
@sum
  %length =l add %left_len, %right_len
  %empty =w ceql %length, 0
  jnz %empty, @zero, @budget
@zero
  ret $cerune_string_empty
@budget
  %live =l loadl $cerune_string_live
  %available =l sub @LIMIT@, %live
  %over =w cugtl %length, %available
  jnz %over, @limit_fail, @allocate
@allocate
  %size =l add %length, 24
  %p =l call $malloc(l %size)
  %failed =w ceql %p, 0
  jnz %failed, @allocation_fail, @copy
@copy
  %head =l loadl $cerune_string_owners
  storel %head, %p
  %ref =l add %p, 8
  storel 1, %ref
  %string =l add %p, 16
  storel %length, %string
  %data =l add %p, 24
  %left_data =l add %left, 8
  %right_data =l add %right, 8
  call $memcpy(l %data, l %left_data, l %left_len)
  %suffix =l add %data, %left_len
  call $memcpy(l %suffix, l %right_data, l %right_len)
  storel %p, $cerune_string_owners
  %total =l add %live, %length
  storel %total, $cerune_string_live
  ret %string
@size_fail
  call $cerune_fail_allocation_size_overflow(l %origin, l %origin_len)
  hlt
@limit_fail
  call $cerune_fail_allocation_limit_exceeded(l %origin, l %origin_len)
  hlt
@allocation_fail
  call $cerune_fail_allocation_failed(l %origin, l %origin_len)
  hlt
}
"#;
