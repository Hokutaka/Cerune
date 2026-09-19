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

static int64_t cerune_check_i8(int64_t value, const char *code, const char *origin) {
    if (value < -128LL || value > 127LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_check_u8(int64_t value, const char *code, const char *origin) {
    if (value < 0LL || value > 255LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_check_i16(int64_t value, const char *code, const char *origin) {
    if (value < -32768LL || value > 32767LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_check_u16(int64_t value, const char *code, const char *origin) {
    if (value < 0LL || value > 65535LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_i64_add(int64_t left, int64_t right, const char *origin) {
    if ((right > 0 && left > INT64_MAX - right) ||
        (right < 0 && left < INT64_MIN - right)) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return left + right;
}

static int64_t cerune_i64_div(int64_t left, int64_t right, const char *origin) {
    if (right == 0) {
        cerune_runtime_fail("division-by-zero", origin);
    }
    if (left == INT64_MIN && right == -1) {
        cerune_runtime_fail("division-overflow", origin);
    }
    return left / right;
}

static int64_t cerune_i64_neg(int64_t value, const char *origin) {
    if (value == INT64_MIN) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return -value;
}

int64_t cerune_fn_average_0(int64_t cerune_binding_0_left, int64_t cerune_binding_1_right);

int64_t cerune_fn_average_0(int64_t cerune_binding_0_left, int64_t cerune_binding_1_right) {
    int64_t _cerune_eval_0;
    int64_t _cerune_eval_1;
    return cerune_check_u8(cerune_check_u16(cerune_i64_div(cerune_check_u16((_cerune_eval_0 = cerune_check_u16(cerune_binding_0_left, "integer-conversion-out-of-range", " node=4 bytes=55..64\n"), _cerune_eval_1 = cerune_check_u16(cerune_binding_1_right, "integer-conversion-out-of-range", " node=6 bytes=67..77\n"), cerune_i64_add(_cerune_eval_0, _cerune_eval_1, " node=3 bytes=54..78\n")), "integer-overflow", " node=3 bytes=54..78\n"), 2, " node=2 bytes=54..82\n"), "division-overflow", " node=2 bytes=54..82\n"), "integer-conversion-out-of-range", " node=1 bytes=51..83\n");
}

int main(void) {
    int64_t cerune_binding_2_offset = cerune_check_i8(cerune_i64_neg(3, " node=10 bytes=101..103\n"), "integer-overflow", " node=10 bytes=101..103\n");
    int64_t cerune_binding_3_reading = cerune_check_i16(cerune_i64_neg(32000, " node=13 bytes=120..126\n"), "integer-overflow", " node=13 bytes=120..126\n");
    printf("%lld\n", (long long)(cerune_check_i16(cerune_i64_add(cerune_binding_3_reading, cerune_check_i16(cerune_binding_2_offset, "integer-conversion-out-of-range", " node=18 bytes=144..155\n"), " node=16 bytes=134..155\n"), "integer-overflow", " node=16 bytes=134..155\n")));
    printf("%lld\n", (long long)(cerune_fn_average_0(240, 80)));
    printf("%s\n", ((127 > -128)) ? "true" : "false");
    printf("%lld\n", (long long)(cerune_check_u16(255, "integer-conversion-out-of-range", " node=29 bytes=212..231\n")));
    return 0;
}
