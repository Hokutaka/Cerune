// 全経路で共通の、既知のバイト列を持つ動的文字列ケースです。
pub const OWNED_ARGUMENTS: (&str, &str) = (
    include_str!("../../examples/owned_arguments.ceru"),
    "[\"保存\"]\n[\"変更\"]\n左\n右\n[\"左!\"]\n[\"右!\"]\ntrue\n1\n",
);

pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/string_concat.ceru"),
        "こんにちは、世界\nこんにちは、世界！\n[\"こんにちは、世界\", \"こんにちは、世界！\"]\n[\"新しい挨拶\", \"こんにちは、世界！\"]\n9\ntrue\ntrue\n反復中\n反復中\n",
    ),
    (
        r#"
        type Box { text: string, other: string = concat("既", "定") }
        enum Item { Text { value: Box }, Empty }
        fn identity<T>(value: T) -> T { return value; }
        fn make() -> Item {
            local: Box = Box { text: concat("返", "却") };
            return Item::Text { value: identity::<Box>(local) };
        }
        mut item: Item = make();
        saved: Item = item;
        item = Item::Empty {};
        print(saved);
        print(item);
        print(match saved {
            Item::Text { value: b } if concat(b.text, "!") == "返却!" => concat(b.other, b.text),
            Item::Text { value: _ } => "bad",
            Item::Empty {} => "empty",
        });
        const TEXT: string = concat("静", "的");
        const N: i64 = byte_len(concat("ab", "c"));
        values: [string; N] = [TEXT, concat("", ""), concat("e", "\u{301}")];
        print(values);
        print(concat("a\0\r", "\n日"));
    "#,
        "Text{value: {text: \"返却\", other: \"既定\"}}\nEmpty{}\n既定返却\n[\"静的\", \"\", \"e\u{301}\"]\na\0\r\n日\n",
    ),
    (
        r#"
        fn mark(v: string) -> string { print(v); return concat(v, "!"); }
        fn index(v: i64) -> i64 { print(v); return v; }
        print(concat(mark("left"), mark("right")));
        print(false && concat(mark("skip"), "x") == "");
        print(true || concat(mark("skip"), "x") == "");
        mut a: [[string; 1]; 1] = [[concat("a", "b")]];
        saved: infer = a;
        a[index(0)][index(0)] = concat(a[0][0], mark("rhs"));
        print(saved); print(a);
        for (mut s: string = concat("a", ""); byte_len(s) < 4; s = concat(s, "a")) {
            if byte_len(s) == 2 { continue; }
            print(s);
        }
    "#,
        "left\nright\nleft!right!\nfalse\ntrue\n0\n0\nrhs\n[[\"ab\"]]\n[[\"abrhs!\"]]\na\naaa\n",
    ),
    (
        r#"
        fn choice(flag: bool) -> string {
            outer: string = concat("o", "k");
            while true {
                inner: string = concat(outer, "!");
                if flag { return inner; }
                break;
            }
            return outer;
        }
        mut count: i64 = 0;
        while concat("y", "es") == "yes" {
            local: string = choice(count == 1);
            count = count + 1;
            if count == 1 { continue; }
            print(local);
            break;
        }
        mut value: string = concat("s", "afe");
        value = value;
        print(value);
        print(choice(false));
    "#,
        "ok!\nsafe\nok\n",
    ),
    OWNED_ARGUMENTS,
];
