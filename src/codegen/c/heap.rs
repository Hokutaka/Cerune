//! Cの静的文字列表現を保ち、動的領域だけを実行内のリストで管理します。
pub(super) fn support(limit: u64) -> String {
    SOURCE.replace("@LIMIT@", &limit.to_string())
}
const SOURCE: &str = r#"
typedef struct cerune_string_owner {
    struct cerune_string_owner *next;
    uint64_t references;
    size_t length;
    unsigned char data[];
} cerune_string_owner;
static cerune_string_owner *cerune_string_owners;
static uint64_t cerune_string_live_bytes;
static void cerune_string_retain(cerune_string value) {
    for (cerune_string_owner *p = cerune_string_owners; p; p = p->next)
        if (p->data == value.data) { ++p->references; return; }
}
static void cerune_string_release(cerune_string value) {
    cerune_string_owner **link = &cerune_string_owners;
    while (*link) {
        cerune_string_owner *p = *link;
        if (p->data == value.data) {
            if (--p->references == 0) {
                *link = p->next;
                cerune_string_live_bytes -= p->length;
                free(p);
            }
            return;
        }
        link = &p->next;
    }
}
static cerune_string cerune_string_concat(cerune_string left, cerune_string right, const char *origin) {
    if (right.length > (uint64_t)INT64_MAX - left.length ||
        right.length > SIZE_MAX - left.length ||
        left.length + right.length > SIZE_MAX - sizeof(cerune_string_owner))
        cerune_runtime_fail("allocation-size-overflow", origin);
    size_t length = left.length + right.length;
    if (!length) return (cerune_string){(const unsigned char *)"", 0};
    if ((uint64_t)length > UINT64_C(@LIMIT@) - cerune_string_live_bytes)
        cerune_runtime_fail("allocation-limit-exceeded", origin);
    cerune_string_owner *p = malloc(sizeof(cerune_string_owner) + length);
    if (!p) cerune_runtime_fail("allocation-failed", origin);
    p->next = cerune_string_owners;
    p->references = 1;
    p->length = length;
    memcpy(p->data, left.data, left.length);
    memcpy(p->data + left.length, right.data, right.length);
    cerune_string_owners = p;
    cerune_string_live_bytes += length;
    return (cerune_string){p->data, length};
}
"#;
