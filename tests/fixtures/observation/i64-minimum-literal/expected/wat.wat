(module
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $main
    (local $cerune_value i64)

    i64.const -9223372036854775808
    local.set $cerune_value
    local.get $cerune_value
    call $print_i64
  )
  (export "main" (func $main))
)
