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

static int64_t cerune_saturating_trunc_f64_u8(double value, const char *origin) {
    /* policy: saturating_trunc */
    double number = (double)value;
    (void)origin;
    if (isnan(number)) return 0;
    if (isinf(number)) return number > 0.0 ? INT64_C(255) : INT64_C(0);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < 0.0) return INT64_C(0);
    if (number >= 256.0) return INT64_C(255);
    return (int64_t)number;
}

static int64_t cerune_floor_f64_i64(double value, const char *origin) {
    /* policy: floor */
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((0) ? 1 : 0) - ((fraction < 0.0) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (int64_t)number;
}

static int64_t cerune_saturating_floor_f64_u8(double value, const char *origin) {
    /* policy: saturating_floor */
    double number = (double)value;
    (void)origin;
    if (isnan(number)) return 0;
    if (isinf(number)) return number > 0.0 ? INT64_C(255) : INT64_C(0);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((0) ? 1 : 0) - ((fraction < 0.0) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < 0.0) return INT64_C(0);
    if (number >= 256.0) return INT64_C(255);
    return (int64_t)number;
}

static int64_t cerune_ceil_f64_i64(double value, const char *origin) {
    /* policy: ceil */
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((fraction > 0.0) ? 1 : 0) - ((0) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (int64_t)number;
}

static int64_t cerune_saturating_ceil_f64_u8(double value, const char *origin) {
    /* policy: saturating_ceil */
    double number = (double)value;
    (void)origin;
    if (isnan(number)) return 0;
    if (isinf(number)) return number > 0.0 ? INT64_C(255) : INT64_C(0);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((fraction > 0.0) ? 1 : 0) - ((0) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < 0.0) return INT64_C(0);
    if (number >= 256.0) return INT64_C(255);
    return (int64_t)number;
}

static int64_t cerune_round_f64_i64(double value, const char *origin) {
    /* policy: round */
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((fraction >= 0.5) ? 1 : 0) - ((fraction <= -0.5) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (int64_t)number;
}

static int64_t cerune_saturating_round_f64_u8(double value, const char *origin) {
    /* policy: saturating_round */
    double number = (double)value;
    (void)origin;
    if (isnan(number)) return 0;
    if (isinf(number)) return number > 0.0 ? INT64_C(255) : INT64_C(0);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((fraction >= 0.5) ? 1 : 0) - ((fraction <= -0.5) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < 0.0) return INT64_C(0);
    if (number >= 256.0) return INT64_C(255);
    return (int64_t)number;
}

static int64_t cerune_round_ties_even_f64_i64(double value, const char *origin) {
    /* policy: round_ties_even */
    double number = (double)value;
    if (!isfinite(number)) cerune_runtime_fail("conversion-not-finite", origin);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((fraction > 0.5 || (fraction == 0.5 && whole % 2 != 0)) ? 1 : 0) - ((fraction < -0.5 || (fraction == -0.5 && whole % 2 != 0)) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < -9223372036854775808.0 || number >= 9223372036854775808.0) cerune_runtime_fail("conversion-out-of-range", origin);
    return (int64_t)number;
}

static int64_t cerune_saturating_round_ties_even_f64_u8(double value, const char *origin) {
    /* policy: saturating_round_ties_even */
    double number = (double)value;
    (void)origin;
    if (isnan(number)) return 0;
    if (isinf(number)) return number > 0.0 ? INT64_C(255) : INT64_C(0);
    /* round finite input; values at or beyond 2^52 are integral */
    if (number > -4503599627370496.0 && number < 4503599627370496.0) {
        int64_t whole = (int64_t)number;
        double fraction = number - (double)whole;
        int64_t delta = ((fraction > 0.5 || (fraction == 0.5 && whole % 2 != 0)) ? 1 : 0) - ((fraction < -0.5 || (fraction == -0.5 && whole % 2 != 0)) ? 1 : 0);
        whole += delta;
        number = (double)whole;
    }
    /* apply range policy after rounding, then convert */
    if (number < 0.0) return INT64_C(0);
    if (number >= 256.0) return INT64_C(255);
    return (int64_t)number;
}

double cerune_fn_value_0(double cerune_binding_0_x);

double cerune_fn_value_0(double cerune_binding_0_x) {
    return cerune_binding_0_x;
}

int main(void) {
    printf("%lld\n", (long long)(cerune_floor_f64_i64(cerune_fn_value_0((-2.5)), " node=7 bytes=79..102\n")));
    printf("%lld\n", (long long)(cerune_ceil_f64_i64(cerune_fn_value_0((-2.5)), " node=12 bytes=111..133\n")));
    printf("%lld\n", (long long)(cerune_round_f64_i64(cerune_fn_value_0(2.5), " node=17 bytes=142..164\n")));
    printf("%lld\n", (long long)(cerune_round_ties_even_f64_i64(cerune_fn_value_0(2.5), " node=21 bytes=173..205\n")));
    printf("%lld\n", (long long)(cerune_saturating_trunc_f64_u8(cerune_fn_value_0(300.0), " node=25 bytes=214..248\n")));
    printf("%lld\n", (long long)(cerune_saturating_floor_f64_u8(cerune_fn_value_0((-0.1)), " node=29 bytes=257..290\n")));
    printf("%lld\n", (long long)(cerune_saturating_ceil_f64_u8(cerune_fn_value_0(255.1), " node=34 bytes=299..332\n")));
    printf("%lld\n", (long long)(cerune_saturating_round_f64_u8(cerune_fn_value_0(255.5), " node=38 bytes=341..375\n")));
    printf("%lld\n", (long long)(cerune_saturating_round_ties_even_f64_u8(cerune_fn_value_0(254.5), " node=42 bytes=384..428\n")));
    printf("%lld\n", (long long)(3));
    return 0;
}
