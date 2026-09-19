#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

static void cerune_runtime_fail(const char *code, const char *origin) {
    fflush(stdout);
    fputs("cerune: runtime-v1 code=", stderr);
    fputs(code, stderr);
    fputs(origin, stderr);
    fflush(stderr);
    abort();
}

static int64_t cerune_i64_rem(int64_t left, int64_t right, const char *origin) {
    if (right == 0) cerune_runtime_fail("remainder-by-zero", origin);
    if (right == -1) return 0;
    return left % right;
}

static int64_t cerune_u8_bit_and(int64_t left, int64_t right, const char *origin) {
    return left & right;
}

static int64_t cerune_u8_bit_or(int64_t left, int64_t right, const char *origin) {
    return left | right;
}

static int64_t cerune_u8_bit_xor(int64_t left, int64_t right, const char *origin) {
    return left ^ right;
}

static int64_t cerune_u8_shl(int64_t left, int64_t right, const char *origin) {
    if (right < 0 || right >= 8) cerune_runtime_fail("invalid-shift-count", origin);
    if (left < (0) || left > (255LL >> right)) cerune_runtime_fail("integer-overflow", origin);
    return left * (INT64_C(1) << right);
}

static int64_t cerune_i8_shr(int64_t left, int64_t right, const char *origin) {
    if (right < 0 || right >= 8) cerune_runtime_fail("invalid-shift-count", origin);
    return left >= 0 ? (int64_t)((uint64_t)left >> right)
        : -1 - (int64_t)((uint64_t)(-1 - left) >> right);
}

static int64_t cerune_u8_shr(int64_t left, int64_t right, const char *origin) {
    if (right < 0 || right >= 8) cerune_runtime_fail("invalid-shift-count", origin);
    return left >= 0 ? (int64_t)((uint64_t)left >> right)
        : -1 - (int64_t)((uint64_t)(-1 - left) >> right);
}

static int64_t cerune_check_i8(int64_t value, const char *code, const char *origin) {
    if (value < -128LL || value > 127LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_check_u8(int64_t value, const char *code, const char *origin) {
    if (value < 0LL || value > 255LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_i64_neg(int64_t value, const char *origin) {
    if (value == INT64_MIN) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return -value;
}

int64_t cerune_fn_mark_0(int64_t cerune_binding_0_value);

int64_t cerune_fn_mark_0(int64_t cerune_binding_0_value) {
    printf("%lld\n", (long long)(cerune_binding_0_value));
    return cerune_binding_0_value;
}

int main(void) {
    int64_t _cerune_bit_left_5, _cerune_bit_right_5;
    int64_t _cerune_bit_left_11, _cerune_bit_right_11;
    int64_t _cerune_bit_left_15, _cerune_bit_right_15;
    int64_t _cerune_bit_left_18, _cerune_bit_right_18;
    int64_t _cerune_bit_left_21, _cerune_bit_right_21;
    int64_t _cerune_bit_left_27, _cerune_bit_right_27;
    int64_t _cerune_bit_left_31, _cerune_bit_right_31;
    int64_t _cerune_bit_left_36, _cerune_bit_right_36;
    int64_t _cerune_bit_left_41, _cerune_bit_right_41;
    int64_t _cerune_bit_left_49, _cerune_bit_right_49;
    int64_t cerune_binding_1_bits = cerune_check_u8((_cerune_bit_left_5 = 1, _cerune_bit_right_5 = 7, cerune_u8_shl(_cerune_bit_left_5, _cerune_bit_right_5, " node=5 bytes=68..74\n")), "integer-overflow", " node=5 bytes=68..74\n");
    printf("%lld\n", (long long)(cerune_binding_1_bits));
    printf("%lld\n", (long long)(cerune_check_u8((_cerune_bit_left_11 = cerune_binding_1_bits, _cerune_bit_right_11 = 7, cerune_u8_shr(_cerune_bit_left_11, _cerune_bit_right_11, " node=11 bytes=95..104\n")), "integer-overflow", " node=11 bytes=95..104\n")));
    printf("%lld\n", (long long)(cerune_check_u8((_cerune_bit_left_15 = 0, _cerune_bit_right_15 = 255, cerune_u8_bit_xor(_cerune_bit_left_15, _cerune_bit_right_15, " node=15 bytes=113..117\n")), "integer-overflow", " node=15 bytes=113..117\n")));
    printf("%lld\n", (long long)(cerune_check_u8((_cerune_bit_left_18 = cerune_fn_mark_0(1), _cerune_bit_right_18 = cerune_check_u8((_cerune_bit_left_21 = cerune_fn_mark_0(2), _cerune_bit_right_21 = cerune_fn_mark_0(3), cerune_u8_bit_xor(_cerune_bit_left_21, _cerune_bit_right_21, " node=21 bytes=136..155\n")), "integer-overflow", " node=21 bytes=136..155\n"), cerune_u8_bit_or(_cerune_bit_left_18, _cerune_bit_right_18, " node=18 bytes=126..155\n")), "integer-overflow", " node=18 bytes=126..155\n")));
    printf("%lld\n", (long long)(cerune_check_u8((_cerune_bit_left_27 = cerune_binding_1_bits, _cerune_bit_right_27 = 127, cerune_u8_bit_and(_cerune_bit_left_27, _cerune_bit_right_27, " node=27 bytes=164..174\n")), "integer-overflow", " node=27 bytes=164..174\n")));
    printf("%lld\n", (long long)((_cerune_bit_left_31 = cerune_i64_neg(7, " node=32 bytes=183..185\n"), _cerune_bit_right_31 = 3, cerune_i64_rem(_cerune_bit_left_31, _cerune_bit_right_31, " node=31 bytes=183..189\n"))));
    printf("%lld\n", (long long)((_cerune_bit_left_36 = INT64_MIN, _cerune_bit_right_36 = cerune_i64_neg(1, " node=38 bytes=221..223\n"), cerune_i64_rem(_cerune_bit_left_36, _cerune_bit_right_36, " node=36 bytes=198..223\n"))));
    printf("%lld\n", (long long)(cerune_check_i8((_cerune_bit_left_41 = cerune_check_i8(cerune_i64_neg(3, " node=42 bytes=232..236\n"), "integer-overflow", " node=42 bytes=232..236\n"), _cerune_bit_right_41 = 1, cerune_i8_shr(_cerune_bit_left_41, _cerune_bit_right_41, " node=41 bytes=232..241\n")), "integer-overflow", " node=41 bytes=232..241\n")));
    printf("%s\n", ((false && (cerune_check_u8((_cerune_bit_left_49 = cerune_binding_1_bits, _cerune_bit_right_49 = 1, cerune_u8_shl(_cerune_bit_left_49, _cerune_bit_right_49, " node=49 bytes=259..270\n")), "integer-overflow", " node=49 bytes=259..270\n") == 0))) ? "true" : "false");
    return 0;
}
