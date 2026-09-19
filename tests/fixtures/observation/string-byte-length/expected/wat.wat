(module
  (import "cerune" "write_byte" (func $write_byte (param i32)))
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (memory 1)

  (data (i32.const 0) "\04\00\00\00\00\00\00\00\e6\97\a5\00")
  (data (i32.const 12) "\00\00\00\00\00\00\00\00")

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

  (func $main
    (local $cerune_text i32)

    i32.const 0
    local.set $cerune_text
    local.get $cerune_text
    i64.load
    call $print_i64
    i32.const 12
    i64.load
    call $print_i64
  )
  (export "main" (func $main))
)
