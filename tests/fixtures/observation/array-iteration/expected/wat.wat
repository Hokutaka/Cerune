(module
  (import "cerune" "write_error_byte" (func $write_error_byte (param i32)))
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $cerune_i64_add_n29_b141_151 (param $left i64) (param $right i64) (result i64)
    (local $result i64)
    local.get $left
    local.get $right
    i64.add
    local.set $result
    local.get $result
    local.get $left
    i64.xor
    local.get $result
    local.get $right
    i64.xor
    i64.and
    i64.const 0
    i64.lt_s
    if
      ;; cerune: runtime-v1 code=integer-overflow node=29 bytes=141..151
      i32.const 99
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 117
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 58
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 117
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 109
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 100
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 61
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 103
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 119
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 100
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 61
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 57
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 98
      call $write_error_byte
      i32.const 121
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 61
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $result
  )

  (func $cerune_i64_add_n35_b54_98 (param $left i64) (param $right i64) (result i64)
    (local $result i64)
    local.get $left
    local.get $right
    i64.add
    local.set $result
    local.get $result
    local.get $left
    i64.xor
    local.get $result
    local.get $right
    i64.xor
    i64.and
    i64.const 0
    i64.lt_s
    if
      ;; cerune: runtime-v1 code=integer-overflow node=35 bytes=54..98
      i32.const 99
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 117
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 58
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 117
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 109
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 100
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 61
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 103
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 119
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 100
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 61
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 32
      call $write_error_byte
      i32.const 98
      call $write_error_byte
      i32.const 121
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 61
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 57
      call $write_error_byte
      i32.const 56
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $result
  )

  (memory 1)

  (func $cerune_fn_values_0 (param $cerune_abi.result i32)
    i32.const 0
    local.get $cerune_abi.result
    i32.store
    i64.const 42
    call $print_i64
    i32.const 4
    i64.const 1
    i64.store
    i32.const 12
    i64.const 2
    i64.store
    i32.const 0
    i32.load
    i32.const 4
    i64.load
    i64.store
    i32.const 20
    i32.const 0
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 20
    i32.load
    i32.const 12
    i64.load
    i64.store
    return
  )
  (func $main
    (local $cerune_$for_in_length_0_54 i64)
    (local $cerune_$for_in_cursor_0_54 i64)
    (local $cerune_i i64)
    (local $cerune_value i64)

    i32.const 40
    call $cerune_fn_values_0
    i32.const 24
    i32.const 40
    i64.load
    i64.store
    i32.const 32
    i32.const 48
    i64.load
    i64.store
    i64.const 2
    local.set $cerune_$for_in_length_0_54
    i64.const 0
    local.set $cerune_$for_in_cursor_0_54
    block $for_end_0
      loop $for_condition_0
        local.get $cerune_$for_in_cursor_0_54
        local.get $cerune_$for_in_length_0_54
        i64.lt_s
        i32.eqz
        br_if $for_end_0
        block $for_continue_0
          local.get $cerune_$for_in_cursor_0_54
          local.set $cerune_i
          i32.const 56
          local.get $cerune_$for_in_cursor_0_54
          i64.store
          i32.const 56
          i64.load
          i64.const 0
          i64.lt_s
          if
            ;; cerune: runtime-v1 code=array-index-out-of-bounds node=20 bytes=69..85
            i32.const 99
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 58
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 116
            call $write_error_byte
            i32.const 105
            call $write_error_byte
            i32.const 109
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 118
            call $write_error_byte
            i32.const 49
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 99
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 61
            call $write_error_byte
            i32.const 97
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 97
            call $write_error_byte
            i32.const 121
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 105
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 120
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 116
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 102
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 98
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 115
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 61
            call $write_error_byte
            i32.const 50
            call $write_error_byte
            i32.const 48
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 98
            call $write_error_byte
            i32.const 121
            call $write_error_byte
            i32.const 116
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 115
            call $write_error_byte
            i32.const 61
            call $write_error_byte
            i32.const 54
            call $write_error_byte
            i32.const 57
            call $write_error_byte
            i32.const 46
            call $write_error_byte
            i32.const 46
            call $write_error_byte
            i32.const 56
            call $write_error_byte
            i32.const 53
            call $write_error_byte
            i32.const 10
            call $write_error_byte
            unreachable
          end
          i32.const 56
          i64.load
          i64.const 2
          i64.ge_s
          if
            ;; cerune: runtime-v1 code=array-index-out-of-bounds node=20 bytes=69..85
            i32.const 99
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 58
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 116
            call $write_error_byte
            i32.const 105
            call $write_error_byte
            i32.const 109
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 118
            call $write_error_byte
            i32.const 49
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 99
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 61
            call $write_error_byte
            i32.const 97
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 114
            call $write_error_byte
            i32.const 97
            call $write_error_byte
            i32.const 121
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 105
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 120
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 116
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 102
            call $write_error_byte
            i32.const 45
            call $write_error_byte
            i32.const 98
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 117
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 115
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 110
            call $write_error_byte
            i32.const 111
            call $write_error_byte
            i32.const 100
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 61
            call $write_error_byte
            i32.const 50
            call $write_error_byte
            i32.const 48
            call $write_error_byte
            i32.const 32
            call $write_error_byte
            i32.const 98
            call $write_error_byte
            i32.const 121
            call $write_error_byte
            i32.const 116
            call $write_error_byte
            i32.const 101
            call $write_error_byte
            i32.const 115
            call $write_error_byte
            i32.const 61
            call $write_error_byte
            i32.const 54
            call $write_error_byte
            i32.const 57
            call $write_error_byte
            i32.const 46
            call $write_error_byte
            i32.const 46
            call $write_error_byte
            i32.const 56
            call $write_error_byte
            i32.const 53
            call $write_error_byte
            i32.const 10
            call $write_error_byte
            unreachable
          end
          i32.const 24
          i32.const 56
          i64.load
          i32.wrap_i64
          i32.const 8
          i32.mul
          i32.add
          i64.load
          local.set $cerune_value
          local.get $cerune_i
          i64.const 0
          i64.eq
          if
            br $for_continue_0
          end
          local.get $cerune_value
          i64.const 10
          call $cerune_i64_add_n29_b141_151
          local.set $cerune_value
          local.get $cerune_value
          call $print_i64
        end
        local.get $cerune_$for_in_cursor_0_54
        i64.const 1
        call $cerune_i64_add_n35_b54_98
        local.set $cerune_$for_in_cursor_0_54
        br $for_condition_0
      end
    end
  )
  (export "main" (func $main))
)
