pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/array_length.ceru"),
        "集計\n4\n20\n4\n118\n20\n型と長さ\n2\n3\n2\n9\n2\n2\n2\n",
    ),
    (
        include_str!("../../examples/array_length_order.ceru"),
        "make\n10\n20\n2\nmake\n10\n20\nlater\n5\nfalse\ntrue\n2\n0\n2\n1\n2\n",
    ),
    (
        r#"
        const DATA: [[bool; 2]; 1] = [[false, true]];
        const COUNT: i64 = array_len(DATA[0]);
        type Box { values: [i64; 2], count: i64 = array_len([1, 2]), }
        fn make() -> Box { print("box"); return Box { values: [3, 4] }; }
        fn flag() -> bool { print("flag"); return true; }
        fn index() -> i64 { print("index"); return 0; }
        print(COUNT); print(array_len(make().values));
        print(array_len([[flag()]][index()]));
        print(array_len([1i8])); print(array_len([1i16])); print(array_len([1i32]));
        print(array_len([1u8])); print(array_len([1u16])); print(array_len([1u32]));
        print(array_len([1.5f32])); print(array_len([1.5f64]));
        "#,
        "2\nbox\n2\nflag\nindex\n1\n1\n1\n1\n1\n1\n1\n1\n1\n",
    ),
];
