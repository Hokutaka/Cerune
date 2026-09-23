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

static int64_t cerune_i64_add(int64_t left, int64_t right, const char *origin) {
    if ((right > 0 && left > INT64_MAX - right) ||
        (right < 0 && left < INT64_MIN - right)) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return left + right;
}

typedef struct cerune_array_i64_2 {
    int64_t items[2];
} cerune_array_i64_2;

static int64_t cerune_array_get_i64_2(cerune_array_i64_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

int64_t cerune_fn_total_0(cerune_array_i64_2 cerune_binding_0_values);

int64_t cerune_fn_total_0(cerune_array_i64_2 cerune_binding_0_values) {
    int64_t _cerune_eval_0;
    int64_t _cerune_eval_1;
    return (_cerune_eval_0 = cerune_array_get_i64_2(cerune_binding_0_values, 0, " node=11 bytes=97..106\n"), _cerune_eval_1 = cerune_array_get_i64_2(cerune_binding_0_values, 1, " node=14 bytes=109..118\n"), cerune_i64_add(_cerune_eval_0, _cerune_eval_1, " node=10 bytes=97..118\n"));
}

int main(void) {
    cerune_array_i64_2 cerune_binding_1_values = (cerune_array_i64_2){ .items = { 3, 4 } };
    printf("%lld\n", (long long)(cerune_fn_total_0(cerune_binding_1_values)));
    return 0;
}
