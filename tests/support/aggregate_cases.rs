pub const CASES: &[(&str, &str)] = &[
    (
        include_str!("../../examples/aggregate_comparison.ceru"),
        "左\n右\ntrue\n保存\nfalse\ntrue\ntrue\n",
    ),
    (
        include_str!("../../examples/aggregate_display.ceru"),
        "[1.5, 2.5]\nReady{reading: {value: 1.5, label: \"空\\n\\0\\r\\t\\\"\\\\\"}, flags: [true, false]}\nMissing{}\n[[0, 18446744073709551615], [1, 2]]\n9\n",
    ),
    (
        r#"
        type Row { values: [f64; 2], text: string, }
        enum Choice { Row { row: Row }, Empty, }
        a: Row = Row { text: "e\u{301}", values: [0.0, 0.0 / 0.0] };
        b: Row = Row { values: [-0.0, 0.0 / 0.0], text: "e\u{301}" };
        print(a == b); print(a != b);
        print([0.0] == [-0.0]);
        print(["\u{e9}"] == ["e\u{301}"]);
        print(["a\0x"] != ["a\0y"]);
        print(Choice::Empty {} == Choice::Empty {});
        print(Choice::Row { row: a } != Choice::Row { row: b });
        mut copy: Row = a; copy = Row { ..copy, text: "changed" };
        print(a.text == "e\u{301}");
        print(["\u{1}", "\u{1b}", "\u{7f}", "日本語", "😀"]);
    "#,
        "false\ntrue\ntrue\nfalse\ntrue\ntrue\ntrue\ntrue\n[\"\\u{01}\", \"\\u{1b}\", \"\\u{7f}\", \"日本語\", \"😀\"]\n",
    ),
    (
        include_str!("../../examples/match_values.ceru"),
        "空\n空欄\n未登録\n[3, 4]\n[0, 18446744073709551615]\n",
    ),
    (
        include_str!("../../examples/match_guards.ceru"),
        "対象\n負数?\n正数?\n7\nEmpty{}\nfalse\n1\n",
    ),
    (
        include_str!("../../examples/bounded_sequence.ceru"),
        "0\n1\n[7, 0, 0, 0]\n[99, 0, 0, 0]\nFull{rejected: 50}\nInvalidLength{length: -1}\n",
    ),
    (
        include_str!("../../examples/array_window.ceru"),
        "対象\n開始\n終了\nCopied{value: {storage: [20, 30, 0, 0], length: 2}}\n[10, 99, 30, 40]\nCopied{value: {storage: [0, 0, 0, 0], length: 0}}\nInvalid{start: -1, end: 2}\nInvalid{start: 3, end: 2}\nInvalid{start: 0, end: 5}\nfalse\n",
    ),
];
