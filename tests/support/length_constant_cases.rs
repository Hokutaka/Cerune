pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/constant_array_lengths.ceru"),
        "固定サイズ\n2\n3\n6\n15\n6\n99\n3\n18446744073709551615\n9223372036854775808\n未登録\n9\n日本語\n3\n\0\r\n\n",
    ),
    (
        r#"
        type Settings { count: i64 = 2, flag: bool }
        const CONFIG: Settings = Settings { flag: false && 1 / 0 == 0 };
        const COUNT: u16 = u16(CONFIG.count);
        const DATA: [f32; COUNT] = [1.5, 2.5];
        const LENGTH: i64 = array_len(DATA);
        fn identity(values: [f32; LENGTH]) -> [f32; COUNT] { return values; }
        print("values");
        print(CONFIG.flag);
        for (v: infer in identity(DATA)) { print(v); }
        const SIZES: [i64; 1] = [2];
        const N: i64 = SIZES[0];
        mut flags: [bool; N] = [true, false];
        flags[0] = false;
        for (v: infer in flags) { print(v); }
    "#,
        "values\nfalse\n1.5\n2.5\nfalse\nfalse\n",
    ),
];
