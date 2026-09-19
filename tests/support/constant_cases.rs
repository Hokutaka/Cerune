// 定数は既知の答えと実行時の同じ演算の両方へ照合します。
pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/constants.ceru"),
        "128\n18446744073709551615\n9\nfalse\n15\n1.5\n2\n10\n10\n99\n定数\0\r\n\n",
    ),
    (
        r#"
        const INF: f64 = 1.0 / 0.0;
        const NEG: f32 = -1.0 / 0.0;
        const NAN: f64 = 0.0 / 0.0;
        const ZERO: f64 = -0.0;
        const ROUNDED: f32 = 0.1 + 0.2;
        const DATA: [[u64; 2]; 1] = [[0, 18446744073709551615]];
        const LETTER: bool = "\u{e9}" == "e\u{301}";
        fn identity(v: f32) -> f32 { return v; }
        print(INF > 0.0); print(NEG < 0.0); print(NAN != NAN);
        print(1.0 / ZERO < 0.0);
        print(identity(ROUNDED) == 0.1f32 + 0.2f32);
        print(DATA[0][1]); print(LETTER);
    "#,
        "true\ntrue\ntrue\ntrue\ntrue\n18446744073709551615\nfalse\n",
    ),
];
