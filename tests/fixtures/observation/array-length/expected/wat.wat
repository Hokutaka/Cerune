(module
  (import "cerune" "print_bool" (func $print_bool (param i32)))
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (memory 1)

  (func $cerune_fn_values_0 (param $cerune_abi.result i32)
    i32.const 0
    local.get $cerune_abi.result
    i32.store
    i64.const 42
    call $print_i64
    i32.const 4
    i64.const 10
    i64.store
    i32.const 12
    i64.const 20
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
    i32.const 24
    call $cerune_fn_values_0
    i64.const 2
    call $print_i64
    i32.const 0
    if (result i32)
      i32.const 40
      call $cerune_fn_values_0
      i64.const 2
      i64.const 2
      i64.eq
    else
      i32.const 0
    end
    call $print_bool
  )
  (export "main" (func $main))
)
