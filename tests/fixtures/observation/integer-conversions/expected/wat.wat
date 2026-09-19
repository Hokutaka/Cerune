(module
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $cerune_fn_value_0 (result i64)
    i64.const 7
    call $print_i64
    i64.const 42
    return
  )
  (func $main
    (local $cerune_compact i64)
    (local $cerune_explicit i64)

    call $cerune_fn_value_0
    local.set $cerune_compact
    local.get $cerune_compact
    local.set $cerune_explicit
    local.get $cerune_explicit
    call $print_i64
  )
  (export "main" (func $main))
)
