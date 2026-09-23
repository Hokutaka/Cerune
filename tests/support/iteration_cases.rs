pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/array_iteration.ceru"),
        "集計\n15\n2\n未登録\nコピー\n1\n2\n3\n99\n",
    ),
    (
        include_str!("../../examples/array_iteration_values.ceru"),
        "0\n9\n日本語\n1\n3\n\0\r\n\n18446744073709551615\n9223372036854775808\n99\n2\n99\n4\n1\n3\n11\n北\n21\n南\n10\n空\n海\n",
    ),
    (
        r#"
        fn mark(value: i64) -> i64 { print(value); return value; }
        fn make() -> [i64; 3] { print("make"); return [mark(10), mark(20), mark(30)]; }
        for (index: infer, mut value: infer in make()) {
            if index == 1 { continue; }
            value = value + 1;
            print(index); print(value);
        }
        for (value: infer in make()) { break; }
        for (outer: infer in [1, 2]) {
            for (inner: infer in [3, 4]) { print(outer * 10 + inner); break; }
        }
        values: [i64; 2] = [7, 8];
        for (values: infer in values) { print(values); }
        print(values[0]);
        mut step: i64 = 0;
        while step < 2 {
            for (value: infer in [step]) { print(value); }
            step = step + 1;
        }
        "#,
        "make\n10\n20\n30\n0\n11\n2\n31\nmake\n10\n20\n30\n13\n23\n7\n8\n7\n0\n1\n",
    ),
    (
        r#"
        print("scalar");
        for (v: i8 in [-1i8]) { print(v); }
        for (v: i16 in [-2i16]) { print(v); }
        for (v: i32 in [-3i32]) { print(v); }
        for (v: i64 in [-4]) { print(v); }
        for (v: u8 in [1u8]) { print(v); }
        for (v: u16 in [2u16]) { print(v); }
        for (v: u32 in [3u32]) { print(v); }
        for (v: u64 in [4u64]) { print(v); }
        for (v: f32 in [1.5f32]) { print(v); }
        for (v: f64 in [2.5f64]) { print(v); }
        for (v: bool in [false, true]) { print(v); }
        const DATA: [[i64; 2]; 1] = [[5, 6]];
        type Box { data: [[i64; 2]; 1] = DATA, marker: bool, }
        for (row: infer in (Box { marker: true }).data) {
            for (v: infer in row) { print(v); }
        }
        "#,
        "scalar\n-1\n-2\n-3\n-4\n1\n2\n3\n4\n1.5\n2.5\nfalse\ntrue\n5\n6\n",
    ),
];
