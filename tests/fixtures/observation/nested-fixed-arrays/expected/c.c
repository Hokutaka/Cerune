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

typedef struct cerune_array_i64_3 {
    int64_t items[3];
} cerune_array_i64_3;

static int64_t cerune_array_get_i64_3(cerune_array_i64_3 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 3) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

typedef struct cerune_array_array_i64_3_2 {
    cerune_array_i64_3 items[2];
} cerune_array_array_i64_3_2;

static cerune_array_i64_3 cerune_array_get_array_i64_3_2(cerune_array_array_i64_3_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

int main(void) {
    cerune_array_array_i64_3_2 cerune_binding_0_matrix = (cerune_array_array_i64_3_2){ .items = { (cerune_array_i64_3){ .items = { 1, 2, 3 } }, (cerune_array_i64_3){ .items = { 4, 5, 6 } } } };
    cerune_array_array_i64_3_2 cerune_binding_1_copy = cerune_binding_0_matrix;
    cerune_binding_0_matrix = (cerune_array_array_i64_3_2){ .items = { (cerune_array_i64_3){ .items = { 7, 8, 9 } }, (cerune_array_i64_3){ .items = { 10, 11, 12 } } } };
    printf("%lld\n", (long long)(cerune_array_get_i64_3(cerune_array_get_array_i64_3_2(cerune_binding_1_copy, 1, " node=24 bytes=125..132\n"), 2, " node=23 bytes=125..135\n")));
    printf("%lld\n", (long long)(cerune_array_get_i64_3(cerune_array_get_array_i64_3_2(cerune_binding_0_matrix, 0, " node=30 bytes=144..153\n"), 1, " node=29 bytes=144..156\n")));
    return 0;
}
