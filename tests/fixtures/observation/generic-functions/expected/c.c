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

static int64_t cerune_i64_neg(int64_t value, const char *origin) {
    if (value == INT64_MIN) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return -value;
}

typedef struct cerune_array_u64_2 {
    uint64_t items[2];
} cerune_array_u64_2;

static uint64_t cerune_array_get_u64_2(cerune_array_u64_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

typedef struct cerune_array_i64_1 {
    int64_t items[1];
} cerune_array_i64_1;

static int64_t cerune_array_get_i64_1(cerune_array_i64_1 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 1) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

uint64_t cerune_fn__generic_0_first_0(cerune_array_u64_2 cerune_binding_0_values);
int64_t cerune_fn__generic_1_first_1(cerune_array_i64_1 cerune_binding_1_values);

uint64_t cerune_fn__generic_0_first_0(cerune_array_u64_2 cerune_binding_0_values) {
    return cerune_array_get_u64_2(cerune_binding_0_values, 0, " node=4 bytes=60..69\n");
}

int64_t cerune_fn__generic_1_first_1(cerune_array_i64_1 cerune_binding_1_values) {
    return cerune_array_get_i64_1(cerune_binding_1_values, 0, " node=8 bytes=60..69\n");
}

int main(void) {
    printf("%llu\n", (unsigned long long)(cerune_fn__generic_0_first_0((cerune_array_u64_2){ .items = { UINT64_C(18446744073709551615), UINT64_C(1) } })));
    printf("%lld\n", (long long)(cerune_fn__generic_1_first_1((cerune_array_i64_1){ .items = { cerune_i64_neg(7, " node=19 bytes=172..174\n") } })));
    printf("%llu\n", (unsigned long long)(cerune_fn__generic_0_first_0((cerune_array_u64_2){ .items = { UINT64_C(42), UINT64_C(0) } })));
    return 0;
}
