// VMと各生成経路で照合する、理由が既知の失敗例です。
pub const FAILURES: &[(&str, &str)] = &[
    (
        "enum E { Value { n: i64 }, Empty } x: E = E::Value { n: 1 / 0 };",
        "division-by-zero",
    ),
    (
        "enum E { Value { n: i64 }, Empty } fn make() -> E { return E::Value { n: 1 / 0 }; } match make() { E::Value { n: n } => { print(n); }, E::Empty {} => {} }",
        "division-by-zero",
    ),
    (
        "enum E { Value { n: i64 }, Empty } x: E = E::Value { n: 0 }; match x { E::Value { n: n } => { print(1 / n); }, E::Empty {} => {} }",
        "division-by-zero",
    ),
    ("print(9223372036854775807 + 1);", "integer-overflow"),
    ("print(-(-9223372036854775808));", "integer-overflow"),
    ("print(127i8 + 1);", "integer-overflow"),
    ("print(0u8 - 1);", "integer-overflow"),
    ("print(18446744073709551615u64 + 1);", "integer-overflow"),
    ("print(0u64 - 1);", "integer-overflow"),
    ("print(18446744073709551615u64 * 2);", "integer-overflow"),
    ("print(1 / 0);", "division-by-zero"),
    ("print(1u64 / 0);", "division-by-zero"),
    ("print(-9223372036854775808 / -1);", "division-overflow"),
    ("print(-128i8 / -1);", "division-overflow"),
    ("print(1 % 0);", "remainder-by-zero"),
    ("print(1u64 % 0);", "remainder-by-zero"),
    ("print(1 << -1);", "invalid-shift-count"),
    ("print(0u8 >> 8);", "invalid-shift-count"),
    ("print(0u64 << 64);", "invalid-shift-count"),
    (
        "print(0u64 >> 18446744073709551615u64);",
        "invalid-shift-count",
    ),
    ("print(64i8 << 1);", "integer-overflow"),
    ("print(9223372036854775808u64 << 1);", "integer-overflow"),
    ("print(i8(128));", "integer-conversion-out-of-range"),
    ("print(u64(-1));", "integer-conversion-out-of-range"),
    (
        "print(i64(9223372036854775808u64));",
        "integer-conversion-out-of-range",
    ),
    ("print(f64(9223372036854775807));", "conversion-inexact"),
    ("print(f32(16777217));", "conversion-inexact"),
    ("print(f64(18446744073709551615u64));", "conversion-inexact"),
    ("print(f32(18446744073709551615u64));", "conversion-inexact"),
    ("print(i64(1.5));", "conversion-inexact"),
    ("print(u64(1.5));", "conversion-inexact"),
    ("print(i8(128.0));", "conversion-out-of-range"),
    ("print(u64(-1.0));", "conversion-out-of-range"),
    (
        "print(u64(18446744073709551616.0));",
        "conversion-out-of-range",
    ),
    ("print(i64(0.0 / 0.0));", "conversion-not-finite"),
    ("print(i64(1.0 / 0.0));", "conversion-not-finite"),
    ("print(i64(-1.0 / 0.0));", "conversion-not-finite"),
    ("print(u64(0.0 / 0.0));", "conversion-not-finite"),
    ("print(u64(1.0 / 0.0));", "conversion-not-finite"),
    ("print(u64(-1.0 / 0.0));", "conversion-not-finite"),
    ("print(i64(-0.0));", "conversion-negative-zero"),
    ("print(u64(-0.0));", "conversion-negative-zero"),
    ("print(f32(0.0 / 0.0));", "conversion-nan"),
    ("x: f32 = 0.0 / 0.0; print(f64(x));", "conversion-nan"),
    ("print(f32(0.1));", "conversion-inexact"),
    // f32へ丸めると最大有限値になる場合でも、元の値は範囲外です。
    (
        "print(f32(3.402823466385289e38));",
        "conversion-out-of-range",
    ),
    (
        "print(f32(-3.402823466385289e38));",
        "conversion-out-of-range",
    ),
    (
        "a: [i64; 1] = [1]; print(a[1]);",
        "array-index-out-of-bounds",
    ),
    (
        "a: [[i64; 1]; 1] = [[1]]; print(a[-1][0]);",
        "array-index-out-of-bounds",
    ),
    (
        "fn value() -> i64 { print(999); return 1; } mut a: [[i64; 1]; 1] = [[1]]; a[0][1] = value();",
        "array-index-out-of-bounds",
    ),
    (
        "fn fail() -> i64 { return 1 / 0; } fn outer() -> i64 { return fail(); } print(outer());",
        "division-by-zero",
    ),
    (
        "type P { marker: bool, value: i64 = 1 / 0, } p: P = P { marker: true, };",
        "division-by-zero",
    ),
    (
        "const ZERO: i64 = 0; value: i64 = 1 / ZERO;",
        "division-by-zero",
    ),
    (
        "const ZERO: f64 = -0.0; value: i64 = i64(ZERO);",
        "conversion-negative-zero",
    ),
    (
        "const DATA: [i64; 1] = [7]; value: i64 = DATA[1];",
        "array-index-out-of-bounds",
    ),
    (CONSTANT_LENGTH_FAILURES[0].0, CONSTANT_LENGTH_FAILURES[0].1),
    (ITERATION_FAILURES[0].0, ITERATION_FAILURES[0].1),
    (ITERATION_FAILURES[1].0, ITERATION_FAILURES[1].1),
    (ITERATION_FAILURES[2].0, ITERATION_FAILURES[2].1),
    (ARRAY_LENGTH_FAILURES[0].0, ARRAY_LENGTH_FAILURES[0].1),
    (ARRAY_LENGTH_FAILURES[1].0, ARRAY_LENGTH_FAILURES[1].1),
    (ARRAY_LENGTH_FAILURES[2].0, ARRAY_LENGTH_FAILURES[2].1),
    (UPDATE_FAILURES[0].0, UPDATE_FAILURES[0].1),
    (UPDATE_FAILURES[1].0, UPDATE_FAILURES[1].1),
    (UPDATE_FAILURES[2].0, UPDATE_FAILURES[2].1),
    (UPDATE_FAILURES[3].0, UPDATE_FAILURES[3].1),
];

// source、停止理由、停止前の出力、失敗する式を固定します。
pub const UPDATE_FAILURES: &[(&str, &str, &str, &str)] = &[
    (
        r#"type P { x: i64, }
        fn base() -> P { print("base"); return P { x: 1 / 0 }; }
        fn later() -> i64 { print("later"); return 2; }
        p: P = P { ..base(), x: later() };"#,
        "division-by-zero",
        "base\n",
        "1 / 0",
    ),
    (
        r#"type P { x: i64, y: i64, }
        fn base() -> P { print("base"); return P { x: 0, y: 0 }; }
        fn field() -> i64 { print("field"); return 1 / 0; }
        fn later() -> i64 { print("later"); return 2; }
        p: P = P { ..base(), y: field(), x: later() };"#,
        "division-by-zero",
        "base\nfield\n",
        "1 / 0",
    ),
    (
        r#"type P { x: i64, }
        fn base() -> P { print("base"); return P { x: 0 }; }
        mut a: [P; 1] = [P { x: 0 }];
        a[1] = P { ..base(), x: 1 / 0 };"#,
        "array-index-out-of-bounds",
        "",
        "[1]",
    ),
    (
        r#"type P { x: i64, }
        fn later() -> i64 { print("later"); return 2; }
        p: P = P { ..[P { x: 0 }][1], x: later() };"#,
        "array-index-out-of-bounds",
        "",
        "[P { x: 0 }][1]",
    ),
];

// 停止理由だけでなく、先行出力と元の失敗式も固定します。
pub const ARRAY_LENGTH_FAILURES: &[(&str, &str, &str, &str)] = &[
    (
        r#"print("before"); print(array_len([1 / 0])); print("after");"#,
        "division-by-zero",
        "before\n",
        "1 / 0",
    ),
    (
        r#"fn make() -> [[i64; 1]; 1] { print("make"); return [[7]]; }
        print(array_len(make()[1]));"#,
        "array-index-out-of-bounds",
        "make\n",
        "make()[1]",
    ),
    (
        r#"type Row { marker: bool, data: [i64; 1] = [1 / 0], }
        print("default"); print(array_len((Row { marker: true }).data));"#,
        "division-by-zero",
        "default\n",
        "1 / 0",
    ),
];

// 反復開始前の評価と、本体内の失敗を区別します。
pub const ITERATION_FAILURES: &[(&str, &str, &str, &str)] = &[
    (
        r#"fn mark(n: i64) -> i64 { print(n); return n; }
        for (v: infer in [mark(1), 1 / 0, mark(3)]) { print(v); break; }"#,
        "division-by-zero",
        "1\n",
        "1 / 0",
    ),
    (
        r#"fn make() -> [[i64; 1]; 1] { print("make"); return [[7]]; }
        for (v: infer in make()[1]) { print(v); }"#,
        "array-index-out-of-bounds",
        "make\n",
        "make()[1]",
    ),
    (
        r#"for (v: infer in [2, 0, 4]) { print(v); print(10 / v); }"#,
        "division-by-zero",
        "2\n5\n0\n",
        "10 / v",
    ),
];

pub const CONSTANT_LENGTH_FAILURES: &[(&str, &str, &str, &str)] = &[(
    r#"const COUNT: u8 = 2; mut values: [i64; COUNT] = [1, 2]; print("before"); values[2] = 3;"#,
    "array-index-out-of-bounds",
    "before\n",
    "[2]",
)];
