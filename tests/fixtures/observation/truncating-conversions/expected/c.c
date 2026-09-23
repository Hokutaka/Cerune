#include <math.h>
#include <float.h>
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

static int64_t cerune_convert_f64_i64(double value, const char *origin) {
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    if (number == 0.0 && signbit(number)) cerune_runtime_fail("conversion-negative-zero", origin);
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-out-of-range", origin);
    int64_t result = (int64_t)number;
    if ((double)result != number) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

static int64_t cerune_trunc_f64_u8(double value, const char *origin) {
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    if (number <= -1.0 || number >= 256.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (int64_t)number;
}

static int64_t cerune_trunc_f64_i64(double value, const char *origin) {
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    if (number < -9223372036854776000.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (int64_t)number;
}

static uint64_t cerune_trunc_f64_u64(double value, const char *origin) {
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    if (number <= -1.0 || number >= 18446744073709551616.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (uint64_t)number;
}

int main(void) {
    printf("%lld\n", (long long)(cerune_trunc_f64_i64((-3.7), " node=1 bytes=6..22\n")));
    printf("%lld\n", (long long)(cerune_trunc_f64_u8(255.9, " node=5 bytes=31..47\n")));
    printf("%llu\n", (unsigned long long)(cerune_trunc_f64_u64((-0.9), " node=8 bytes=56..72\n")));
    printf("%lld\n", (long long)(cerune_convert_f64_i64(2.0, " node=12 bytes=81..98\n")));
    return 0;
}
