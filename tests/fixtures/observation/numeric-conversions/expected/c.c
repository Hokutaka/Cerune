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

static double cerune_convert_i16_f64(int64_t value, const char *origin) {
    double result = (double)value;
    double number = (double)result;
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-inexact", origin);
    if ((int64_t)number != value) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

static float cerune_convert_u32_f32(int64_t value, const char *origin) {
    float result = (float)value;
    double number = (double)result;
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-inexact", origin);
    if ((int64_t)number != value) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

static double cerune_convert_u32_f64(int64_t value, const char *origin) {
    double result = (double)value;
    double number = (double)result;
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-inexact", origin);
    if ((int64_t)number != value) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

static double cerune_convert_i64_f64(int64_t value, const char *origin) {
    double result = (double)value;
    double number = (double)result;
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-inexact", origin);
    if ((int64_t)number != value) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

static int64_t cerune_convert_f32_i16(float value, const char *origin) {
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    if (number == 0.0 && signbit(number)) cerune_runtime_fail("conversion-negative-zero", origin);
    if (number < -32768.0 || number >= 32768.0) cerune_runtime_fail("conversion-out-of-range", origin);
    int64_t result = (int64_t)number;
    if ((double)result != number) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

static double cerune_convert_f32_f64(float value, const char *origin) {
    if (isnan(value)) cerune_runtime_fail("conversion-nan", origin);
    return (double)value;
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

static float cerune_convert_f64_f32(double value, const char *origin) {
    if (isnan(value)) cerune_runtime_fail("conversion-nan", origin);
    if (isinf(value)) return signbit(value) ? -INFINITY : INFINITY;
    if (value > (double)FLT_MAX || value < -(double)FLT_MAX) cerune_runtime_fail("conversion-out-of-range", origin);
    float result = (float)value;
    if ((double)result != value) cerune_runtime_fail("conversion-inexact", origin);
    return result;
}

double cerune_fn_measure_0(int64_t cerune_binding_0_value);

double cerune_fn_measure_0(int64_t cerune_binding_0_value) {
    double _cerune_eval_0;
    double _cerune_eval_1;
    return (_cerune_eval_0 = cerune_convert_i16_f64(cerune_binding_0_value, " node=2 bytes=43..53\n"), _cerune_eval_1 = cerune_convert_i64_f64(2, " node=4 bytes=56..62\n"), (_cerune_eval_0 / _cerune_eval_1));
}

int main(void) {
    int64_t cerune_binding_1_count = 42;
    double cerune_binding_2_wide = cerune_convert_u32_f64(cerune_binding_1_count, " node=9 bytes=95..114\n");
    float cerune_binding_3_narrow = cerune_convert_f64_f32(cerune_binding_2_wide, " node=12 bytes=130..139\n");
    printf("%lld\n", (long long)(cerune_convert_f32_i16(cerune_binding_3_narrow, " node=15 bytes=147..158\n")));
    printf("%lld\n", (long long)(cerune_convert_f64_i64(cerune_binding_2_wide, " node=18 bytes=167..176\n")));
    printf("%.17g\n", (double)(cerune_convert_f32_f64(cerune_binding_3_narrow, " node=21 bytes=185..196\n")));
    printf("%.9g\n", (double)(cerune_convert_u32_f32(cerune_binding_1_count, " node=24 bytes=205..215\n")));
    printf("%.17g\n", (double)(cerune_fn_measure_0(3)));
    printf("%.9g\n", (double)(cerune_convert_f64_f32((-0.0), " node=30 bytes=243..252\n")));
    return 0;
}
