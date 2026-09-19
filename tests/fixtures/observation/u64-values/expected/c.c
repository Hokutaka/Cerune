#include <math.h>
#include <float.h>
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

static uint64_t cerune_convert_i64_u64(int64_t value, const char *origin) {
    if (value < 0) cerune_runtime_fail("integer-conversion-out-of-range", origin);
    return (uint64_t)value;
}

static uint64_t cerune_u64_div(uint64_t left, uint64_t right, const char *origin) {
    if (right == 0) cerune_runtime_fail("division-by-zero", origin);
    return left / right;
}

static uint64_t cerune_u64_shr(uint64_t left, uint64_t right, const char *origin) {
    if (right >= 64) cerune_runtime_fail("invalid-shift-count", origin);
    return left >> right;
}

int main(void) {
    int64_t _cerune_bit_left_9, _cerune_bit_right_9;
    int64_t _cerune_bit_left_13, _cerune_bit_right_13;
    uint64_t cerune_binding_0_maximum = UINT64_C(18446744073709551615);
    printf("%llu\n", (unsigned long long)(cerune_binding_0_maximum));
    printf("%s\n", ((cerune_binding_0_maximum > UINT64_C(0))) ? "true" : "false");
    printf("%llu\n", (unsigned long long)((_cerune_bit_left_9 = cerune_binding_0_maximum, _cerune_bit_right_9 = UINT64_C(2), cerune_u64_div(_cerune_bit_left_9, _cerune_bit_right_9, " node=9 bytes=79..90\n"))));
    printf("%llu\n", (unsigned long long)((_cerune_bit_left_13 = cerune_binding_0_maximum, _cerune_bit_right_13 = UINT64_C(63), cerune_u64_shr(_cerune_bit_left_13, _cerune_bit_right_13, " node=13 bytes=99..112\n"))));
    printf("%llu\n", (unsigned long long)(cerune_convert_i64_u64(42, " node=17 bytes=121..131\n")));
    return 0;
}
