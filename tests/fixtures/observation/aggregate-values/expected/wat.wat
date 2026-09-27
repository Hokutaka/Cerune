(module
  (import "cerune" "write_i64" (func $cerune_write_i64 (param i64)))
  (import "cerune" "write_u64" (func $cerune_write_u64 (param i64)))
  (import "cerune" "write_f32" (func $cerune_write_f32 (param f32)))
  (import "cerune" "write_f64" (func $cerune_write_f64 (param f64)))
  (import "cerune" "write_error_byte" (func $write_error_byte (param i32)))
  (import "cerune" "write_byte" (func $write_byte (param i32)))
  (import "cerune" "print_bool" (func $print_bool (param i32)))
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $cerune_i64_add_n63_b70_84 (param $left i64) (param $right i64) (result i64)
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
      ;; cerune: runtime-v1 code=integer-overflow node=63 bytes=70..84
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
      i32.const 54
      call $write_error_byte
      i32.const 51
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
      i32.const 52
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $result
  )

  (func $cerune_i64_sub_n41_b254_256 (param $left i64) (param $right i64) (result i64)
    (local $result i64)
    local.get $left
    local.get $right
    i64.sub
    local.set $result
    local.get $left
    local.get $right
    i64.xor
    local.get $left
    local.get $result
    i64.xor
    i64.and
    i64.const 0
    i64.lt_s
    if
      ;; cerune: runtime-v1 code=integer-overflow node=41 bytes=254..256
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
      i32.const 52
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
      i32.const 50
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 52
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 46
      call $write_error_byte
      i32.const 50
      call $write_error_byte
      i32.const 53
      call $write_error_byte
      i32.const 54
      call $write_error_byte
      i32.const 10
      call $write_error_byte
      unreachable
    end
    local.get $result
  )

  (memory 1)

  (data (i32.const 216) "\05\00\00\00\00\00\00\00\56\61\6c\75\65")
  (data (i32.const 229) "\01\00\00\00\00\00\00\00\7b")
  (data (i32.const 238) "\03\00\00\00\00\00\00\00\6e\3a\20")
  (data (i32.const 249) "\01\00\00\00\00\00\00\00\7d")
  (data (i32.const 258) "\05\00\00\00\00\00\00\00\45\6d\70\74\79")
  (data (i32.const 271) "\01\00\00\00\00\00\00\00\7b")
  (data (i32.const 280) "\01\00\00\00\00\00\00\00\7d")
  (data (i32.const 289) "\00\00\00\00\00\00\00\00")

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

  (func $cerune_write_escaped_byte (param $value i32)
    local.get $value
    i32.const 0
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 48
      call $write_byte
      return
    end
    local.get $value
    i32.const 1
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 2
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 50
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 3
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 51
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 4
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 52
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 5
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 53
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 6
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 54
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 7
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 55
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 8
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 56
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 9
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 116
      call $write_byte
      return
    end
    local.get $value
    i32.const 10
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 110
      call $write_byte
      return
    end
    local.get $value
    i32.const 11
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 98
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 12
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 99
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 13
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 114
      call $write_byte
      return
    end
    local.get $value
    i32.const 14
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 101
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 15
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 102
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 16
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 48
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 17
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 18
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 50
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 19
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 51
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 20
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 52
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 21
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 53
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 22
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 54
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 23
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 55
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 24
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 56
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 25
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 57
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 26
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 97
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 27
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 98
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 28
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 99
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 29
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 100
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 30
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 101
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 31
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 49
      call $write_byte
      i32.const 102
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    i32.const 34
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 34
      call $write_byte
      return
    end
    local.get $value
    i32.const 92
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 92
      call $write_byte
      return
    end
    local.get $value
    i32.const 127
    i32.eq
    if
      i32.const 92
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 123
      call $write_byte
      i32.const 55
      call $write_byte
      i32.const 102
      call $write_byte
      i32.const 125
      call $write_byte
      return
    end
    local.get $value
    call $write_byte
  )
  (func $cerune_write_bool (param $value i32)
    local.get $value
    if
      i32.const 116
      call $write_byte
      i32.const 114
      call $write_byte
      i32.const 117
      call $write_byte
      i32.const 101
      call $write_byte
    else
      i32.const 102
      call $write_byte
      i32.const 97
      call $write_byte
      i32.const 108
      call $write_byte
      i32.const 115
      call $write_byte
      i32.const 101
      call $write_byte
    end
  )
  (func $cerune_write_string (param $value i32)
    (local $length i32) (local $index i32)
    local.get $value
    i32.load
    local.set $length
    block $end
      loop $loop
        local.get $index
        local.get $length
        i32.eq
        br_if $end
        local.get $value
        local.get $index
        i32.add
        i32.load8_u offset=8
        call $write_byte
        local.get $index
        i32.const 1
        i32.add
        local.set $index
        br $loop
      end
    end
  )
  (func $cerune_write_quoted (param $value i32)
    (local $length i32) (local $index i32)
    local.get $value
    i32.load
    local.set $length
    i32.const 34
    call $write_byte
    block $end
      loop $loop
        local.get $index
        local.get $length
        i32.eq
        br_if $end
        local.get $value
        local.get $index
        i32.add
        i32.load8_u offset=8
        call $cerune_write_escaped_byte
        local.get $index
        i32.const 1
        i32.add
        local.set $index
        br $loop
      end
    end
    i32.const 34
    call $write_byte
  )
  (func $cerune_fn__equal0_0 (param $cerune_$left i32) (param $cerune_$right i32) (result i32)
    (local $cerune_$index i64)

    i32.const 0
    local.get $cerune_$left
    i32.store
    i32.const 4
    i32.const 0
    i32.load
    i64.load
    i64.store
    i32.const 40
    i32.const 0
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 12
    i32.const 40
    i32.load
    i64.load
    i64.store
    i32.const 20
    local.get $cerune_$right
    i32.store
    i32.const 24
    i32.const 20
    i32.load
    i64.load
    i64.store
    i32.const 44
    i32.const 20
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 32
    i32.const 44
    i32.load
    i64.load
    i64.store
    i64.const 0
    local.set $cerune_$index
    block $for_end_0
      loop $for_condition_0
        local.get $cerune_$index
        i64.const 2
        i64.lt_s
        i32.eqz
        br_if $for_end_0
        block $for_continue_0
          i32.const 48
          local.get $cerune_$index
          i64.store
          i32.const 48
          i64.load
          i64.const 0
          i64.lt_s
          if
            ;; cerune: runtime-v1 code=array-index-out-of-bounds node=52 bytes=70..84
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
            i32.const 53
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
            i32.const 52
            call $write_error_byte
            i32.const 10
            call $write_error_byte
            unreachable
          end
          i32.const 48
          i64.load
          i64.const 2
          i64.ge_s
          if
            ;; cerune: runtime-v1 code=array-index-out-of-bounds node=52 bytes=70..84
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
            i32.const 53
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
            i32.const 52
            call $write_error_byte
            i32.const 10
            call $write_error_byte
            unreachable
          end
          i32.const 4
          i32.const 48
          i64.load
          i32.wrap_i64
          i32.const 8
          i32.mul
          i32.add
          i64.load
          i32.const 56
          local.get $cerune_$index
          i64.store
          i32.const 56
          i64.load
          i64.const 0
          i64.lt_s
          if
            ;; cerune: runtime-v1 code=array-index-out-of-bounds node=55 bytes=70..84
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
            i32.const 53
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
            i32.const 52
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
            ;; cerune: runtime-v1 code=array-index-out-of-bounds node=55 bytes=70..84
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
            i32.const 53
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
            i32.const 52
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
          i64.eq
          i32.eqz
          if
            i32.const 0
            return
          end
        end
        local.get $cerune_$index
        i64.const 1
        call $cerune_i64_add_n63_b70_84
        local.set $cerune_$index
        br $for_condition_0
      end
    end
    i32.const 1
    return
  )
  (func $cerune_fn__match_bind1_1 (param $cerune_$capture1 i32) (result i32)
    (local $cerune_n i64)

    i32.const 64
    local.get $cerune_$capture1
    i32.store
    i32.const 68
    i32.const 64
    i32.load
    i64.load
    i64.store
    i32.const 84
    i32.const 64
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 76
    i32.const 84
    i32.load
    i64.load
    i64.store
    i32.const 76
    i64.load
    local.set $cerune_n
    local.get $cerune_n
    i64.const 0
    i64.gt_s
    return
  )
  (func $cerune_fn__match_bind2_2 (param $cerune_$capture1 i32) (result i64)
    (local $cerune_n i64)

    i32.const 88
    local.get $cerune_$capture1
    i32.store
    i32.const 92
    i32.const 88
    i32.load
    i64.load
    i64.store
    i32.const 108
    i32.const 88
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 100
    i32.const 108
    i32.load
    i64.load
    i64.store
    i32.const 100
    i64.load
    local.set $cerune_n
    local.get $cerune_n
    return
  )
  (func $cerune_fn__match_select3_3 (param $cerune_$capture1 i32) (result i64)
    i32.const 112
    local.get $cerune_$capture1
    i32.store
    i32.const 116
    i32.const 112
    i32.load
    i64.load
    i64.store
    i32.const 132
    i32.const 112
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 124
    i32.const 132
    i32.load
    i64.load
    i64.store
    i32.const 116
    i64.load
    i64.const 0
    i64.eq
    if
      i64.const 0
      return
    else
      i64.const 0
      i64.const 1
      call $cerune_i64_sub_n41_b254_256
      return
    end
    unreachable
  )
  (func $cerune_fn__match_select4_4 (param $cerune_$capture1 i32) (result i64)
    i32.const 136
    local.get $cerune_$capture1
    i32.store
    i32.const 140
    i32.const 136
    i32.load
    i64.load
    i64.store
    i32.const 156
    i32.const 136
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 148
    i32.const 156
    i32.load
    i64.load
    i64.store
    i32.const 140
    i64.load
    i64.const 0
    i64.eq
    if (result i32)
      i32.const 140
      call $cerune_fn__match_bind1_1
    else
      i32.const 0
    end
    if
      i32.const 140
      call $cerune_fn__match_bind2_2
      return
    else
      i32.const 140
      call $cerune_fn__match_select3_3
      return
    end
    unreachable
  )
  (func $cerune_fn__match_bind5_5 (result i64)
    i32.const 176
    i64.const 0
    i64.store
    i32.const 184
    i64.const 7
    i64.store
    i32.const 160
    i32.const 176
    i64.load
    i64.store
    i32.const 168
    i32.const 184
    i64.load
    i64.store
    i32.const 160
    call $cerune_fn__match_select4_4
    return
  )
  (func $cerune_fn__display6_6 (param $cerune_$value i32)
    i32.const 192
    local.get $cerune_$value
    i32.store
    i32.const 196
    i32.const 192
    i32.load
    i64.load
    i64.store
    i32.const 212
    i32.const 192
    i32.load
    i32.const 8
    i32.add
    i32.store
    i32.const 204
    i32.const 212
    i32.load
    i64.load
    i64.store
    i32.const 196
    i64.load
    i64.const 0
    i64.eq
    if
      i32.const 216
      call $cerune_write_string
      i32.const 229
      call $cerune_write_string
      i32.const 238
      call $cerune_write_string
      i32.const 204
      i64.load
      call $cerune_write_i64
      i32.const 249
      call $cerune_write_string
    end
    i32.const 196
    i64.load
    i64.const 1
    i64.eq
    if
      i32.const 258
      call $cerune_write_string
      i32.const 271
      call $cerune_write_string
      i32.const 280
      call $cerune_write_string
    end
    i32.const 289
    call $cerune_print_string
    return
  )
  (func $main
    (local $cerune_result i64)

    i32.const 313
    i64.const 1
    i64.store
    i32.const 321
    i64.const 2
    i64.store
    i32.const 297
    i32.const 313
    i64.load
    i64.store
    i32.const 305
    i32.const 321
    i64.load
    i64.store
    i32.const 297
    i32.const 329
    i64.const 1
    i64.store
    i32.const 337
    i64.const 3
    i64.store
    i32.const 329
    call $cerune_fn__equal0_0
    call $print_bool
    i32.const 345
    i64.const 0
    i64.store
    i32.const 353
    i64.const 7
    i64.store
    i32.const 345
    call $cerune_fn__display6_6
    call $cerune_fn__match_bind5_5
    local.set $cerune_result
    local.get $cerune_result
    call $print_i64
  )
  (export "main" (func $main))
)
