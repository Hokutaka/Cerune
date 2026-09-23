#[path = "generic_cases.rs"]
pub mod generic_cases;

#[path = "length_constant_cases.rs"]
pub mod length_constant_cases;

#[path = "iteration_cases.rs"]
pub mod iteration_cases;

#[path = "array_cases.rs"]
pub mod array_cases;

#[path = "sum_cases.rs"]
pub mod sum_cases;

#[path = "constant_cases.rs"]
pub mod constant_cases;

// 全経路に同じ入力と既知の期待バイト列を渡します。
#[path = "truncation_cases.rs"]
pub mod truncation_cases;

pub const CASES: &[(&str, &str)] = &[
    (
        r#"
        print(""); print("日本語\0\r\n\t\"\\\u{1f600}");
        print("a\0x" != "a\0y"); print("a\0" == "a"); print("" == "");
        print("\u{e9}" == "e\u{301}"); print("日本語" == "\u{65e5}本語");
        print(42); print(true); print(1.5f64); print("end");
    "#,
        "\n日本語\0\r\n\t\"\\😀\ntrue\nfalse\ntrue\nfalse\ntrue\n42\ntrue\n1.5\nend\n",
    ),
    (
        r#"
        type Label { id: i64, text: string = "既定", }
        fn identity(text: string) -> string { return text; }
        fn forward(text: string) -> string { return identity(text); }
        fn make() -> [[Label; 1]; 2] {
            mut rows: [[Label; 1]; 2] = [[Label { id: 0, }], [Label { id: 1, text: "保存", }]];
            saved: infer = rows;
            rows[1][0] = Label { id: 2, text: "変更", };
            print(rows[1][0].text);
            return saved;
        }
        fn replace(original: [string; 2]) -> [string; 2] {
            mut words: infer = original;
            words[0] = "replacement";
            return words;
        }
        fn main() -> void {
            original: infer = make();
            mut copy: infer = original;
            for (mut i: i64 = 0; i < 3; i = i + 1) {
                copy[1][0] = Label { id: 3, text: forward("\0end"), };
            }
            print(original[0][0].text); print(original[1][0].text); print(copy[1][0].text);
            mut text: string = "old"; saved: infer = text; text = "new";
            print(saved); print(text);
            words: [string; 2] = ["first", "second"];
            changed: infer = replace(words);
            print(words[0]); print(changed[0]); print(changed[1]);
        }
    "#,
        "変更\n既定\n保存\n\0end\nold\nnew\nfirst\nreplacement\nsecond\n",
    ),
    (
        r#"
        fn mark(text: string) -> string { print(text); return text; }
        fn pair(left: string, right: string) -> string { return right; }
        fn index() -> i64 { print("index"); return 0; }
        fn fail() -> string { print(["bad"][1]); return "bad"; }
        type Pair { first: string = mark("default"), second: string, }
        print(mark("left") == mark("right"));
        print(pair(mark("arg1"), mark("arg2")));
        value: Pair = Pair { second: mark("explicit"), }; print(value.first);
        mut words: [string; 2] = [mark("item1"), mark("item2")];
        words[index()] = mark("replacement"); print(words[0]);
        print(false && fail() == "bad"); print(true || fail() != "bad");
        for (mut flag: bool = true; flag; flag = mark("update1") == mark("update2")) {
            if mark("condition1") != mark("condition2") { continue; }
        }
    "#,
        "left\nright\nfalse\narg1\narg2\narg2\nexplicit\ndefault\ndefault\nitem1\nitem2\nindex\nreplacement\nreplacement\nfalse\ntrue\ncondition1\ncondition2\nupdate1\nupdate2\n",
    ),
    PRODUCT_UPDATES[0],
    PRODUCT_UPDATES[1],
    PRODUCT_UPDATES[2],
    PRODUCT_UPDATES[3],
    sum_cases::CASES[0],
    sum_cases::CASES[1],
    sum_cases::CASES[2],
    sum_cases::CASES[3],
    sum_cases::CASES[4],
    constant_cases::CASES[0],
    constant_cases::CASES[1],
    array_cases::CASES[0],
    array_cases::CASES[1],
    array_cases::CASES[2],
    iteration_cases::CASES[0],
    iteration_cases::CASES[1],
    iteration_cases::CASES[2],
    iteration_cases::CASES[3],
    generic_cases::CASES[0],
    generic_cases::CASES[1],
    generic_cases::CASES[2],
    length_constant_cases::CASES[0],
    length_constant_cases::CASES[1],
];

pub const PRODUCT_UPDATES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/product_update.ceru"),
        "9223372036854775808\n9223372036854775809\n1\n3\n10\n99\n20\nfalse\ntrue\ntrue\n受信\0\r\n\n",
    ),
    (
        include_str!("../../examples/product_update_order.ceru"),
        "base\ndefault\nreplacement\n2\n2\nreplacement\n2\nreplacement\nfalse\ntrue\nbase\ndefault\n0\nbase\ndefault\n1\n",
    ),
    (
        r#"
        type Inner { value: f64, flag: bool, }
        type Row { items: [i64; 2], inner: Inner, label: string, }
        fn make(a: i64, b: i64, c: i64, d: i64, e: i64, f: i64, g: i64) -> Row {
            print(a);
            return Row { items: [a, g], inner: Inner { value: f64(g), flag: true }, label: "保管\0\r\n" };
        }
        row: Row = Row {
            ..make(1, 2, 3, 4, 5, 6, 7),
            inner: make(10, 20, 30, 40, 50, 60, 70).inner,
        };
        print(row.items[0]); print(row.items[1]);
        print(row.inner.value == 70.0); print(row.inner.flag); print(row.label);
     "#,
        "1\n10\n1\n7\ntrue\ntrue\n保管\0\r\n\n",
    ),
    (
        r#"
        type P { x: i64 = 1 / 0, y: [i64; 1], }
        fn base() -> P { print("base"); return P { x: 1, y: [2] }; }
        a: P = P { ..base() };
        b: P = P { ..base(), x: 3, y: [4] };
        print(a.x); print(a.y[0]); print(b.x); print(b.y[0]);
     "#,
        "base\nbase\n1\n2\n3\n4\n",
    ),
    truncation_cases::CASES[0],
    truncation_cases::CASES[1],
    truncation_cases::CASES[2],
];

pub const UNUSED_DEFAULT: &str =
    r#"type Unused { flag: bool = "a" == "a", } print(1); print(true);"#;

pub const BYTE_LENGTH: (&str, &str) = (
    include_str!("../../examples/string_byte_length.ceru"),
    "0\n9\n3\n2\n3\n4\n7\n3\n9\nleft\nright\n9\nfalse\nfalse\n6\n10\n",
);

pub const OUT_OF_BOUNDS: &[&str] = &[
    r#"print(byte_len(["a"][1]));"#,
    r#"print(["a"][-1]);"#,
    r#"mut values: [string; 1] = ["a"]; values[1] = "replacement";"#,
];
