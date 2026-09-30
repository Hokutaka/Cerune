(module
  (import "cerune" "write_error_byte" (func $write_error_byte (param i32)))
  (import "cerune" "write_byte" (func $write_byte (param i32)))
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $cerune_string_concat_n1_b19_39 (param $left i32) (param $right i32) (result i32)
    (local $length i64) (local $value i32) (local $error i32)
    local.get $left
    i64.load
    local.get $right
    i64.load
    i64.add
    local.tee $length
    call $cerune_string_allocate
    local.set $error
    local.set $value
    local.get $error
    i32.const 1
    i32.eq
    if
      ;; cerune: runtime-v1 code=allocation-size-overflow node=1 bytes=19..39
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
      i32.const 108
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 122
      call $write_error_byte
      i32.const 101
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
      i32.const 49
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
      i32.const 57
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 57
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $error
    i32.const 2
    i32.eq
    if
      ;; cerune: runtime-v1 code=allocation-limit-exceeded node=1 bytes=19..39
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
      i32.const 108
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 109
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 120
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 100
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 100
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
      i32.const 49
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
      i32.const 57
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 57
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $error
    i32.const 3
    i32.eq
    if
      ;; cerune: runtime-v1 code=allocation-failed node=1 bytes=19..39
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
      i32.const 108
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 100
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
      i32.const 49
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
      i32.const 57
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 57
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $value
    i32.const 8
    i32.add
    local.get $left
    i32.const 8
    i32.add
    local.get $left
    i64.load
    i32.wrap_i64
    memory.copy
    local.get $value
    i32.const 8
    i32.add
    local.get $left
    i64.load
    i32.wrap_i64
    i32.add
    local.get $right
    i32.const 8
    i32.add
    local.get $right
    i64.load
    i32.wrap_i64
    memory.copy
    local.get $value
  )
  (func $cerune_string_concat_n7_b70_87 (param $left i32) (param $right i32) (result i32)
    (local $length i64) (local $value i32) (local $error i32)
    local.get $left
    i64.load
    local.get $right
    i64.load
    i64.add
    local.tee $length
    call $cerune_string_allocate
    local.set $error
    local.set $value
    local.get $error
    i32.const 1
    i32.eq
    if
      ;; cerune: runtime-v1 code=allocation-size-overflow node=7 bytes=70..87
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
      i32.const 108
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 122
      call $write_error_byte
      i32.const 101
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
      i32.const 55
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
      i32.const 55
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 56
      call $write_error_byte
      i32.const 55
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $error
    i32.const 2
    i32.eq
    if
      ;; cerune: runtime-v1 code=allocation-limit-exceeded node=7 bytes=70..87
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
      i32.const 108
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 109
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 120
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 100
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 100
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
      i32.const 55
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
      i32.const 55
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 56
      call $write_error_byte
      i32.const 55
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $error
    i32.const 3
    i32.eq
    if
      ;; cerune: runtime-v1 code=allocation-failed node=7 bytes=70..87
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
      i32.const 108
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 99
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 108
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 100
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
      i32.const 55
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
      i32.const 55
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 56
      call $write_error_byte
      i32.const 55
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $value
    i32.const 8
    i32.add
    local.get $left
    i32.const 8
    i32.add
    local.get $left
    i64.load
    i32.wrap_i64
    memory.copy
    local.get $value
    i32.const 8
    i32.add
    local.get $left
    i64.load
    i32.wrap_i64
    i32.add
    local.get $right
    i32.const 8
    i32.add
    local.get $right
    i64.load
    i32.wrap_i64
    memory.copy
    local.get $value
  )
  (memory 1)

  (data (i32.const 0) "\03\00\00\00\00\00\00\00\e6\97\a5")
  (data (i32.const 11) "\03\00\00\00\00\00\00\00\e6\9c\ac")
  (data (i32.const 22) "\01\00\00\00\00\00\00\00\21")

  (func $cerune_string_equal (param $left i32) (param $right i32) (result i32)
    (local $length i32) (local $index i32)
    local.get $left
    i32.load
    local.tee $length
    local.get $right
    i32.load
    i32.ne
    if
      i32.const 0
      return
    end
    block $equal
      loop $compare
        local.get $index
        local.get $length
        i32.eq
        br_if $equal
        local.get $left
        local.get $index
        i32.add
        i32.load8_u offset=8
        local.get $right
        local.get $index
        i32.add
        i32.load8_u offset=8
        i32.ne
        if
          i32.const 0
          return
        end
        local.get $index
        i32.const 1
        i32.add
        local.set $index
        br $compare
      end
    end
    i32.const 1
  )

  (func $cerune_print_string (param $value i32)
    (local $length i32) (local $index i32)
    local.get $value
    i32.load
    local.set $length
    block $newline
      loop $write
        local.get $index
        local.get $length
        i32.eq
        br_if $newline
        local.get $value
        local.get $index
        i32.add
        i32.load8_u offset=8
        call $write_byte
        local.get $index
        i32.const 1
        i32.add
        local.set $index
        br $write
      end
    end
    i32.const 10
    call $write_byte
  )


  (global $cerune_heap_head (mut i32) (i32.const 0))
  (global $cerune_heap_end (mut i64) (i64.const 40))
  (global $cerune_heap_live (mut i64) (i64.const 0))
  (func $cerune_string_retain (param $value i32)
    (local $p i32)
    global.get $cerune_heap_head
    local.set $p
    block $done
      loop $search
        local.get $p
        i32.eqz
        br_if $done
        local.get $p
        i32.const 16
        i32.add
        local.get $value
        i32.eq
        if
          local.get $p
          local.get $p
          i32.load offset=4
          i32.const 1
          i32.add
          i32.store offset=4
          return
        end
        local.get $p
        i32.load
        local.set $p
        br $search
      end
    end
  )
  (func $cerune_string_release (param $value i32)
    (local $p i32) (local $count i32)
    global.get $cerune_heap_head
    local.set $p
    block $done
      loop $search
        local.get $p
        i32.eqz
        br_if $done
        local.get $p
        i32.const 16
        i32.add
        local.get $value
        i32.eq
        if
          local.get $p
          i32.load offset=4
          i32.const 1
          i32.sub
          local.set $count
          local.get $p
          local.get $count
          i32.store offset=4
          local.get $count
          i32.eqz
          if
            global.get $cerune_heap_live
            local.get $p
            i64.load offset=16
            i64.sub
            global.set $cerune_heap_live
          end
          return
        end
        local.get $p
        i32.load
        local.set $p
        br $search
      end
    end
  )
  ;; 戻り値: 長さヘッダーへのaddress、失敗番号（0=成功）。
  (func $cerune_string_allocate (param $length i64) (result i32 i32)
    (local $p i32) (local $size i64) (local $end i64) (local $pages i64)
    local.get $length
    i64.eqz
    if
      i32.const 32
      i32.const 0
      return
    end
    local.get $length
    i64.const 4294967271
    i64.gt_u
    if
      i32.const 0
      i32.const 1
      return
    end
    local.get $length
    i64.const 67108864
    global.get $cerune_heap_live
    i64.sub
    i64.gt_u
    if
      i32.const 0
      i32.const 2
      return
    end
    global.get $cerune_heap_head
    local.set $p
    block $found
      block $new
        loop $search
          local.get $p
          i32.eqz
          br_if $new
          local.get $p
          i32.load offset=4
          i32.eqz
          local.get $p
          i64.load offset=8
          local.get $length
          i64.ge_u
          i32.and
          br_if $found
          local.get $p
          i32.load
          local.set $p
          br $search
        end
      end
      local.get $length
      i64.const 31
      i64.add
      i64.const -8
      i64.and
      local.set $size
      global.get $cerune_heap_end
      local.get $size
      i64.add
      local.tee $end
      i64.const 4294967296
      i64.gt_u
      if
        i32.const 0
        i32.const 3
        return
      end
      local.get $end
      i64.const 65535
      i64.add
      i64.const 65536
      i64.div_u
      local.set $pages
      local.get $pages
      memory.size
      i64.extend_i32_u
      i64.gt_u
      if
        local.get $pages
        memory.size
        i64.extend_i32_u
        i64.sub
        i32.wrap_i64
        memory.grow
        i32.const -1
        i32.eq
        if
          i32.const 0
          i32.const 3
          return
        end
      end
      global.get $cerune_heap_end
      i32.wrap_i64
      local.set $p
      local.get $end
      global.set $cerune_heap_end
      local.get $p
      global.get $cerune_heap_head
      i32.store
      local.get $p
      global.set $cerune_heap_head
      local.get $p
      local.get $size
      i64.const 24
      i64.sub
      i64.store offset=8
    end
    local.get $p
    i32.const 1
    i32.store offset=4
    local.get $p
    local.get $length
    i64.store offset=16
    global.get $cerune_heap_live
    local.get $length
    i64.add
    global.set $cerune_heap_live
    local.get $p
    i32.const 16
    i32.add
    i32.const 0
  )
  (func $cerune_fn__ownership0_0 (result i32)
    (local $cerune_$read2 i32)
    (local $cerune_$read3 i32)
    (local $cerune_$owned4 i32)

    i32.const 0
    local.set $cerune_$read2
    i32.const 11
    local.set $cerune_$read3
    local.get $cerune_$read2
    local.get $cerune_$read3
    call $cerune_string_concat_n1_b19_39
    local.set $cerune_$owned4
    local.get $cerune_$owned4
    return
  )
  (func $cerune_fn__ownership1_1 (param $cerune_$owned5 i32) (result i32)
    (local $cerune_$read6 i32)
    (local $cerune_$owned7 i32)

    local.get $cerune_$owned5
    local.set $cerune_$read6
    local.get $cerune_$read6
    local.set $cerune_$owned7
    local.get $cerune_$owned7
    call $cerune_string_retain
    local.get $cerune_$owned7
    return
  )
  (func $cerune_fn__ownership2_2 (param $cerune_$owned8 i32) (result i32)
    (local $cerune_$read9 i32)
    (local $cerune_$read10 i32)
    (local $cerune_$owned11 i32)

    local.get $cerune_$owned8
    local.set $cerune_$read9
    i32.const 22
    local.set $cerune_$read10
    local.get $cerune_$read9
    local.get $cerune_$read10
    call $cerune_string_concat_n7_b70_87
    local.set $cerune_$owned11
    local.get $cerune_$owned11
    return
  )
  (func $cerune_fn__ownership3_3 (param $cerune_$owned12 i32) (param $cerune_$owned13 i32) (result i32)
    local.get $cerune_$owned12
    call $cerune_string_release
    local.get $cerune_$owned13
    return
  )
  (func $main
    (local $cerune_text i32)
    (local $cerune_saved i32)
    (local $cerune_$read14 i32)
    (local $cerune_$read15 i32)

    call $cerune_fn__ownership0_0
    local.set $cerune_text
    local.get $cerune_text
    call $cerune_fn__ownership1_1
    local.set $cerune_saved
    local.get $cerune_text
    local.get $cerune_text
    call $cerune_fn__ownership2_2
    call $cerune_fn__ownership3_3
    local.set $cerune_text
    local.get $cerune_saved
    local.set $cerune_$read14
    local.get $cerune_$read14
    call $cerune_print_string
    local.get $cerune_text
    local.set $cerune_$read15
    local.get $cerune_$read15
    call $cerune_print_string
    local.get $cerune_saved
    call $cerune_string_release
    local.get $cerune_text
    call $cerune_string_release
  )
  (export "main" (func $main))
)
