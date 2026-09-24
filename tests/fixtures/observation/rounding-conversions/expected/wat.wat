(module
  (import "cerune" "write_error_byte" (func $write_error_byte (param i32)))
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $cerune_ceil_f64_i64_n12_b111_133 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: ceil
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-not-finite node=12 bytes=111..133
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
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
      i32.const 50
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
      i32.const 49
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    ;; round finite input
    local.get $number
    f64.ceil
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const -9223372036854775808
    f64.lt
    local.get $number
    f64.const 9223372036854775808
    f64.ge
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-out-of-range node=12 bytes=111..133
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
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
      i32.const 114
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 103
      call $write_error_byte
      i32.const 101
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
      i32.const 50
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
      i32.const 49
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_floor_f64_i64_n7_b79_102 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: floor
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-not-finite node=7 bytes=79..102
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
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
      i32.const 57
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    ;; round finite input
    local.get $number
    f64.floor
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const -9223372036854775808
    f64.lt
    local.get $number
    f64.const 9223372036854775808
    f64.ge
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-out-of-range node=7 bytes=79..102
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
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
      i32.const 114
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 103
      call $write_error_byte
      i32.const 101
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
      i32.const 57
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_round_f64_i64_n17_b142_164 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: round
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-not-finite node=17 bytes=142..164
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
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
      i32.const 49
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 54
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    ;; round finite input
    local.get $number
    f64.abs
    f64.const 4503599627370496
    f64.lt
    if
      local.get $number
      f64.trunc
      local.set $base
      local.get $number
      local.get $base
      f64.sub
      local.set $fraction
      local.get $fraction
      f64.const 0.5
      f64.ge
      if
        local.get $base
        f64.const 1
        f64.add
        local.set $base
      else
        local.get $fraction
        f64.const -0.5
        f64.le
        if
          local.get $base
          f64.const 1
          f64.sub
          local.set $base
        end
      end
      local.get $base
      local.set $number
    end
    ;; range policy after rounding, then convert
    local.get $number
    f64.const -9223372036854775808
    f64.lt
    local.get $number
    f64.const 9223372036854775808
    f64.ge
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-out-of-range node=17 bytes=142..164
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
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
      i32.const 114
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 103
      call $write_error_byte
      i32.const 101
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
      i32.const 49
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 49
      call $write_error_byte
      i32.const 54
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_round_ties_even_f64_i64_n21_b173_205 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: round_ties_even
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-not-finite node=21 bytes=173..205
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 45
      call $write_error_byte
      i32.const 102
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 116
      call $write_error_byte
      i32.const 101
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
      i32.const 55
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    ;; round finite input
    local.get $number
    f64.nearest
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const -9223372036854775808
    f64.lt
    local.get $number
    f64.const 9223372036854775808
    f64.ge
    i32.or
    if
      ;; cerune: runtime-v1 code=conversion-out-of-range node=21 bytes=173..205
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
      i32.const 99
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 118
      call $write_error_byte
      i32.const 101
      call $write_error_byte
      i32.const 114
      call $write_error_byte
      i32.const 115
      call $write_error_byte
      i32.const 105
      call $write_error_byte
      i32.const 111
      call $write_error_byte
      i32.const 110
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
      i32.const 114
      call $write_error_byte
      i32.const 97
      call $write_error_byte
      i32.const 110
      call $write_error_byte
      i32.const 103
      call $write_error_byte
      i32.const 101
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
      i32.const 55
      call $write_error_byte
      i32.const 51
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 48
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_saturating_ceil_f64_u8_n34_b299_332 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: saturating_ceil
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    if
      i64.const 0
      return
    end
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    if
      local.get $number
      f64.const 0
      f64.gt
      if (result i64)
        i64.const 255
      else
        i64.const 0
      end
      return
    end
    ;; round finite input
    local.get $number
    f64.ceil
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const 0
    f64.lt
    if
      i64.const 0
      return
    end
    local.get $number
    f64.const 256
    f64.ge
    if
      i64.const 255
      return
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_saturating_floor_f64_u8_n29_b257_290 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: saturating_floor
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    if
      i64.const 0
      return
    end
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    if
      local.get $number
      f64.const 0
      f64.gt
      if (result i64)
        i64.const 255
      else
        i64.const 0
      end
      return
    end
    ;; round finite input
    local.get $number
    f64.floor
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const 0
    f64.lt
    if
      i64.const 0
      return
    end
    local.get $number
    f64.const 256
    f64.ge
    if
      i64.const 255
      return
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_saturating_round_f64_u8_n38_b341_375 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: saturating_round
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    if
      i64.const 0
      return
    end
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    if
      local.get $number
      f64.const 0
      f64.gt
      if (result i64)
        i64.const 255
      else
        i64.const 0
      end
      return
    end
    ;; round finite input
    local.get $number
    f64.abs
    f64.const 4503599627370496
    f64.lt
    if
      local.get $number
      f64.trunc
      local.set $base
      local.get $number
      local.get $base
      f64.sub
      local.set $fraction
      local.get $fraction
      f64.const 0.5
      f64.ge
      if
        local.get $base
        f64.const 1
        f64.add
        local.set $base
      else
        local.get $fraction
        f64.const -0.5
        f64.le
        if
          local.get $base
          f64.const 1
          f64.sub
          local.set $base
        end
      end
      local.get $base
      local.set $number
    end
    ;; range policy after rounding, then convert
    local.get $number
    f64.const 0
    f64.lt
    if
      i64.const 0
      return
    end
    local.get $number
    f64.const 256
    f64.ge
    if
      i64.const 255
      return
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_saturating_round_ties_even_f64_u8_n42_b384_428 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: saturating_round_ties_even
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    if
      i64.const 0
      return
    end
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    if
      local.get $number
      f64.const 0
      f64.gt
      if (result i64)
        i64.const 255
      else
        i64.const 0
      end
      return
    end
    ;; round finite input
    local.get $number
    f64.nearest
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const 0
    f64.lt
    if
      i64.const 0
      return
    end
    local.get $number
    f64.const 256
    f64.ge
    if
      i64.const 255
      return
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_saturating_trunc_f64_u8_n25_b214_248 (param $value f64) (result i64)
    (local $number f64)
    (local $base f64)
    (local $fraction f64)
    ;; policy: saturating_trunc
    local.get $value
    local.set $number
    local.get $number
    local.get $number
    f64.ne
    if
      i64.const 0
      return
    end
    local.get $number
    f64.abs
    f64.const inf
    f64.eq
    if
      local.get $number
      f64.const 0
      f64.gt
      if (result i64)
        i64.const 255
      else
        i64.const 0
      end
      return
    end
    ;; round finite input
    local.get $number
    f64.trunc
    local.set $number
    ;; range policy after rounding, then convert
    local.get $number
    f64.const 0
    f64.lt
    if
      i64.const 0
      return
    end
    local.get $number
    f64.const 256
    f64.ge
    if
      i64.const 255
      return
    end
    local.get $number
    i64.trunc_f64_s
  )
  (func $cerune_fn_value_0 (param $cerune_x f64) (result f64)
    local.get $cerune_x
    return
  )
  (func $main
    f64.const 2.5
    f64.neg
    call $cerune_fn_value_0
    call $cerune_floor_f64_i64_n7_b79_102
    call $print_i64
    f64.const 2.5
    f64.neg
    call $cerune_fn_value_0
    call $cerune_ceil_f64_i64_n12_b111_133
    call $print_i64
    f64.const 2.5
    call $cerune_fn_value_0
    call $cerune_round_f64_i64_n17_b142_164
    call $print_i64
    f64.const 2.5
    call $cerune_fn_value_0
    call $cerune_round_ties_even_f64_i64_n21_b173_205
    call $print_i64
    f64.const 300.0
    call $cerune_fn_value_0
    call $cerune_saturating_trunc_f64_u8_n25_b214_248
    call $print_i64
    f64.const 0.1
    f64.neg
    call $cerune_fn_value_0
    call $cerune_saturating_floor_f64_u8_n29_b257_290
    call $print_i64
    f64.const 255.1
    call $cerune_fn_value_0
    call $cerune_saturating_ceil_f64_u8_n34_b299_332
    call $print_i64
    f64.const 255.5
    call $cerune_fn_value_0
    call $cerune_saturating_round_f64_u8_n38_b341_375
    call $print_i64
    f64.const 254.5
    call $cerune_fn_value_0
    call $cerune_saturating_round_ties_even_f64_u8_n42_b384_428
    call $print_i64
    i64.const 3
    call $print_i64
  )
  (export "main" (func $main))
)
