// 構文だけでなく、全経路で値・実行順・独立性を照合します。
pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/sum_divide.ceru"),
        "45\nゼロでは割れません\n結果が範囲外です\n処理を続行\n",
    ),
    (
        include_str!("../../examples/sum_lookup.ceru"),
        "空\0\r\n\n6\n未登録\n",
    ),
    (
        include_str!("../../examples/sum_values.ceru"),
        "subject\nlimit\npacket\ndefault\n99\n10\n18446744073709551615\ndata\nchanged\nempty\n",
    ),
    (
        r#"
        enum One { Value { n: i64 } }
        enum Choice { Yes { words: [string; 2] }, No, }
        enum Wrapper { Inner { value: Choice }, Empty, }
        const FIXED: Wrapper = Wrapper::Inner { value: Choice::Yes { words: ["\u{e9}", "e\u{301}"] } };
        fn one(value: One) -> i64 {
            match value { One::Value { n: n } => { return n; }, }
        }
        fn subject() -> Wrapper { print("once"); return FIXED; }
        match subject() {
            Wrapper::Inner { value: inner } => {
                match inner {
                    Choice::No {} => { print("unexpected"); },
                    Choice::Yes { words: words } => { print(words[0] == words[1]); },
                }
            },
            Wrapper::Empty {} => { print(1 / 0); },
        }
        print(one(One::Value { n: 7 }));
        mut n: i64 = 0;
        while n < 3 {
            n = n + 1;
            match (Choice::Yes { words: ["a", "b"] }) {
                Choice::Yes { words: _ } => {
                    if n < 3 { continue; }
                    break;
                },
                Choice::No {} => { print("unexpected"); },
            }
            print("unreachable");
        }
        print(n);
        fn skipped() -> bool { print("unexpected"); return true; }
        print(false && skipped());
        print(true || skipped());
    "#,
        "once\nfalse\n7\n3\nfalse\ntrue\n",
    ),
    (
        r#"
        enum Number { Scalars { a: i8, b: u16, ok: bool, f: f32, d: f64 }, Empty { text: string } }
        type Container { value: Number = Number::Empty { text: "default" }, n: i64 }
        fn exact(flag: bool) -> i64 { if flag { return 7; } else { return 8; } }
        fn passthrough(v: [Container; 1]) -> [Container; 1] { return v; }
        mut values: [Container; 1] = [Container { value: Number::Scalars { a: -128, b: 65535, ok: true, f: -0.0, d: 0.0 / 0.0 }, n: 1 }];
        saved: [Container; 1] = passthrough(values);
        values[0] = Container { n: 2 };
        match saved[0].value {
            Number::Empty { text: _ } => { print("unexpected"); },
            Number::Scalars { a: a, b: b, ok: ok, f: f, d: d } => {
                print(a); print(b); print(ok); print(1.0f32 / f < 0.0f32); print(d != d);
            },
        }
        match values[0].value {
            Number::Scalars { a: _, b: _, ok: _, f: _, d: _ } => { print("unexpected"); },
            Number::Empty { text: text } => { print(text); },
        }
        print(exact(true)); print(exact(false));
        enum Collision { X_Y { z: i64 }, X { Y_z: i64 } }
        fn collision(value: Collision) -> i64 {
            match value {
                Collision::X_Y { z: n } => { return n; },
                Collision::X { Y_z: n } => { return n; },
            }
        }
        print(collision(Collision::X_Y { z: 1 }));
        print(collision(Collision::X { Y_z: 2 }));
    "#,
        "-128\n65535\ntrue\ntrue\ntrue\ndefault\n7\n8\n1\n2\n",
    ),
];
