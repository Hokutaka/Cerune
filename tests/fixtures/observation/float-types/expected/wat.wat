(module
  (import "cerune" "print_i64" (func $print_i64 (param i64)))
  (import "cerune" "print_f32" (func $print_f32 (param f32)))
  (import "cerune" "print_f64" (func $print_f64 (param f64)))

  (func $main
    (local $cerune_single f32)
    (local $cerune_double f64)
    (local $cerune_inferred f64)
    (local $cerune_suffixed f32)

    f32.const 0.1
    f32.const 0.2
    f32.add
    local.set $cerune_single
    f64.const 0.1
    f64.const 0.2
    f64.add
    local.set $cerune_double
    f64.const 0.1
    f64.const 0.2
    f64.add
    local.set $cerune_inferred
    f32.const 0.1
    f32.const 0.2
    f32.add
    local.set $cerune_suffixed
    local.get $cerune_single
    call $print_f32
    local.get $cerune_double
    call $print_f64
    local.get $cerune_inferred
    call $print_f64
    local.get $cerune_suffixed
    call $print_f32
  )
  (export "main" (func $main))
)
