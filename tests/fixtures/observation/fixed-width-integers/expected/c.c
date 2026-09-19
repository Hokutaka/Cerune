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

static int64_t cerune_check_i32(int64_t value, const char *code, const char *origin) {
    if (value < -2147483648LL || value > 2147483647LL) cerune_runtime_fail(code, origin);
    return value;
}

static int64_t cerune_check_u32(int64_t value, const char *code, const char *origin) {
    if (value < 0LL || value > 4294967295LL) cerune_runtime_fail(code, origin);
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

int64_t cerune_fn_add_0(int64_t cerune_binding_0_left, int64_t cerune_binding_1_right);

int64_t cerune_fn_add_0(int64_t cerune_binding_0_left, int64_t cerune_binding_1_right) {
    return cerune_check_i32(cerune_i64_add(cerune_binding_0_left, cerune_binding_1_right, " node=1 bytes=50..62\n"), "integer-overflow", " node=1 bytes=50..62\n");
}

int main(void) {
    int64_t cerune_binding_2_small = cerune_fn_add_0(cerune_check_i32(cerune_i64_neg(3, " node=6 bytes=83..85\n"), "integer-overflow", " node=6 bytes=83..85\n"), 5);
    int64_t cerune_binding_3_large = 4294967295;
    printf("%lld\n", (long long)(cerune_binding_2_small));
    printf("%lld\n", (long long)(cerune_check_u32(cerune_i64_div(cerune_binding_3_large, 2, " node=14 bytes=136..145\n"), "division-overflow", " node=14 bytes=136..145\n")));
    printf("%lld\n", (long long)(cerune_binding_3_large));
    printf("%s\n", ((cerune_binding_3_large > 2147483648)) ? "true" : "false");
    printf("%lld\n", (long long)(cerune_check_u32(cerune_binding_2_small, "integer-conversion-out-of-range", " node=25 bytes=200..219\n")));
    return 0;
}
