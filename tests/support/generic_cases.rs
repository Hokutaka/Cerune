pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/generic_functions.ceru"),
        "型と長さ\n6\n9223372036854775809\n4\n日本語\n変更\n\0\r\n\n保存\ntrue\n8\n選択\n",
    ),
    (
        include_str!("../../examples/generic_evaluation_order.ceru"),
        "評価順\n配列\n添字\n2\n末尾\nfalse\ntrue\n",
    ),
    (
        r#"
        fn echo<T>(value: T) -> T { return value; }
        fn cast<T>(value: i64) -> T { return convert<T>(value); }
        print("types");
        print(echo::<i8>(-128)); print(echo::<u8>(255));
        print(echo::<i16>(-32768)); print(echo::<u16>(65535));
        print(echo::<i32>(-2147483648)); print(echo::<u32>(4294967295));
        print(echo::<i64>(-9223372036854775808)); print(echo::<u64>(18446744073709551615));
        print(echo::<f32>(1.5)); print(echo::<f64>(2.5)); print(echo::<bool>(true));
        print(cast::<u8>(42));
    "#,
        "types\n-128\n255\n-32768\n65535\n-2147483648\n4294967295\n-9223372036854775808\n18446744073709551615\n1.5\n2.5\ntrue\n42\n",
    ),
];
