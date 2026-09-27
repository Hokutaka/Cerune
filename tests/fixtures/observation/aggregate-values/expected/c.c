#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#endif
#include <stdlib.h>

static void cerune_runtime_fail(const char *code, const char *origin) {
    fflush(stdout);
    fputs("cerune: runtime-v1 code=", stderr);
    fputs(code, stderr);
    fputs(origin, stderr);
    fflush(stderr);
    abort();
}

static int64_t cerune_i64_add(int64_t left, int64_t right, const char *origin) {
    if ((right > 0 && left > INT64_MAX - right) ||
        (right < 0 && left < INT64_MIN - right)) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return left + right;
}

static int64_t cerune_i64_neg(int64_t value, const char *origin) {
    if (value == INT64_MIN) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return -value;
}

typedef struct cerune_string {
    const unsigned char *data;
    size_t length;
} cerune_string;

static inline bool cerune_string_equal(cerune_string left, cerune_string right) {
    return left.length == right.length &&
        (left.length == 0 || memcmp(left.data, right.data, left.length) == 0);
}

static inline void cerune_print_string(cerune_string value) {
    fwrite(value.data, 1, value.length, stdout);
    fputc('\n', stdout);
}

static void cerune_write_escaped_byte(unsigned char value) {
    switch (value) {
    case 0:
        putchar(92);
        putchar(48);
        return;
    case 1:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(49);
        putchar(125);
        return;
    case 2:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(50);
        putchar(125);
        return;
    case 3:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(51);
        putchar(125);
        return;
    case 4:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(52);
        putchar(125);
        return;
    case 5:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(53);
        putchar(125);
        return;
    case 6:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(54);
        putchar(125);
        return;
    case 7:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(55);
        putchar(125);
        return;
    case 8:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(56);
        putchar(125);
        return;
    case 9:
        putchar(92);
        putchar(116);
        return;
    case 10:
        putchar(92);
        putchar(110);
        return;
    case 11:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(98);
        putchar(125);
        return;
    case 12:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(99);
        putchar(125);
        return;
    case 13:
        putchar(92);
        putchar(114);
        return;
    case 14:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(101);
        putchar(125);
        return;
    case 15:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(48);
        putchar(102);
        putchar(125);
        return;
    case 16:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(48);
        putchar(125);
        return;
    case 17:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(49);
        putchar(125);
        return;
    case 18:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(50);
        putchar(125);
        return;
    case 19:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(51);
        putchar(125);
        return;
    case 20:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(52);
        putchar(125);
        return;
    case 21:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(53);
        putchar(125);
        return;
    case 22:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(54);
        putchar(125);
        return;
    case 23:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(55);
        putchar(125);
        return;
    case 24:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(56);
        putchar(125);
        return;
    case 25:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(57);
        putchar(125);
        return;
    case 26:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(97);
        putchar(125);
        return;
    case 27:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(98);
        putchar(125);
        return;
    case 28:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(99);
        putchar(125);
        return;
    case 29:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(100);
        putchar(125);
        return;
    case 30:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(101);
        putchar(125);
        return;
    case 31:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(49);
        putchar(102);
        putchar(125);
        return;
    case 34:
        putchar(92);
        putchar(34);
        return;
    case 92:
        putchar(92);
        putchar(92);
        return;
    case 127:
        putchar(92);
        putchar(117);
        putchar(123);
        putchar(55);
        putchar(102);
        putchar(125);
        return;
    default: putchar(value); return;
    }
}
static void cerune_write_string(cerune_string value) {
    for (size_t i = 0; i < value.length; ++i) putchar(value.data[i]);
}
static void cerune_write_quoted(cerune_string value) {
    putchar(34);
    for (size_t i = 0; i < value.length; ++i) cerune_write_escaped_byte(value.data[i]);
    putchar(34);
}
static void cerune_write_i64(int64_t value) { printf("%lld", (long long)value); }
static void cerune_write_u64(uint64_t value) { printf("%llu", (unsigned long long)value); }
static void cerune_write_f32(float value) { printf("%.9g", (double)value); }
static void cerune_write_f64(double value) { printf("%.17g", (double)value); }
static void cerune_write_bool(bool value) { fputs(value ? "true" : "false", stdout); }

typedef struct cerune_array_i64_2 {
    int64_t items[2];
} cerune_array_i64_2;

static int64_t cerune_array_get_i64_2(cerune_array_i64_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

typedef struct cerune_type_Item_0 {
    int64_t _dtag;
    int64_t _dValue_dn;
} cerune_type_Item_0;

bool cerune_fn__equal0_0(cerune_array_i64_2 cerune_binding_5__left, cerune_array_i64_2 cerune_binding_6__right);
bool cerune_fn__match_bind1_1(cerune_type_Item_0 cerune_binding_8__capture1);
int64_t cerune_fn__match_bind2_2(cerune_type_Item_0 cerune_binding_9__capture1);
int64_t cerune_fn__match_select3_3(cerune_type_Item_0 cerune_binding_10__capture1);
int64_t cerune_fn__match_select4_4(cerune_type_Item_0 cerune_binding_11__capture1);
int64_t cerune_fn__match_bind5_5(void);
void cerune_fn__display6_6(cerune_type_Item_0 cerune_binding_12__value);

bool cerune_fn__equal0_0(cerune_array_i64_2 cerune_binding_5__left, cerune_array_i64_2 cerune_binding_6__right) {
    int64_t _cerune_eval_0;
    int64_t _cerune_eval_1;
    for (int64_t cerune_binding_7__index = 0; (cerune_binding_7__index < 2); cerune_binding_7__index = cerune_i64_add(cerune_binding_7__index, 1, " node=63 bytes=70..84\n")) {
        if (!(_cerune_eval_0 = cerune_array_get_i64_2(cerune_binding_5__left, cerune_binding_7__index, " node=52 bytes=70..84\n"), _cerune_eval_1 = cerune_array_get_i64_2(cerune_binding_6__right, cerune_binding_7__index, " node=55 bytes=70..84\n"), (_cerune_eval_0 == _cerune_eval_1))) {
            return false;
        }
    }
    return true;
}

bool cerune_fn__match_bind1_1(cerune_type_Item_0 cerune_binding_8__capture1) {
    int64_t cerune_binding_2_n = (cerune_binding_8__capture1)._dValue_dn;
    return (cerune_binding_2_n > 0);
}

int64_t cerune_fn__match_bind2_2(cerune_type_Item_0 cerune_binding_9__capture1) {
    int64_t cerune_binding_3_n = (cerune_binding_9__capture1)._dValue_dn;
    return cerune_binding_3_n;
}

int64_t cerune_fn__match_select3_3(cerune_type_Item_0 cerune_binding_10__capture1) {
    if ((cerune_binding_10__capture1)._dtag == 0) {
        return 0;
    } else {
        return cerune_i64_neg(1, " node=41 bytes=254..256\n");
    }
}

int64_t cerune_fn__match_select4_4(cerune_type_Item_0 cerune_binding_11__capture1) {
    if ((((cerune_binding_11__capture1)._dtag == 0) && cerune_fn__match_bind1_1(cerune_binding_11__capture1))) {
        return cerune_fn__match_bind2_2(cerune_binding_11__capture1);
    } else {
        return cerune_fn__match_select3_3(cerune_binding_11__capture1);
    }
}

int64_t cerune_fn__match_bind5_5(void) {
    cerune_type_Item_0 cerune_binding_1__match0 = (cerune_type_Item_0){ ._dtag = 0, ._dValue_dn = 7 };
    return cerune_fn__match_select4_4(cerune_binding_1__match0);
}

void cerune_fn__display6_6(cerune_type_Item_0 cerune_binding_12__value) {
    if ((cerune_binding_12__value)._dtag == 0) {
        cerune_write_string((cerune_string){ (const unsigned char *)"\126\141\154\165\145", 5 });
        cerune_write_string((cerune_string){ (const unsigned char *)"\173", 1 });
        cerune_write_string((cerune_string){ (const unsigned char *)"\156\072\040", 3 });
        cerune_write_i64((cerune_binding_12__value)._dValue_dn);
        cerune_write_string((cerune_string){ (const unsigned char *)"\175", 1 });
    }
    if ((cerune_binding_12__value)._dtag == 1) {
        cerune_write_string((cerune_string){ (const unsigned char *)"\105\155\160\164\171", 5 });
        cerune_write_string((cerune_string){ (const unsigned char *)"\173", 1 });
        cerune_write_string((cerune_string){ (const unsigned char *)"\175", 1 });
    }
    cerune_print_string((cerune_string){ (const unsigned char *)"", 0 });
    return;
}

int main(void) {
#ifdef _WIN32
    if (_setmode(_fileno(stdout), _O_BINARY) == -1) {
        fputs("cerune: cannot set stdout to binary mode\n", stderr);
        return 1;
    }
#endif
    cerune_array_i64_2 cerune_binding_0_left = (cerune_array_i64_2){ .items = { 1, 2 } };
    printf("%s\n", (cerune_fn__equal0_0(cerune_binding_0_left, (cerune_array_i64_2){ .items = { 1, 3 } })) ? "true" : "false");
    cerune_fn__display6_6((cerune_type_Item_0){ ._dtag = 0, ._dValue_dn = 7 });
    int64_t cerune_binding_4_result = cerune_fn__match_bind5_5();
    printf("%lld\n", (long long)(cerune_binding_4_result));
    return 0;
}
