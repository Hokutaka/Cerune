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

int main(void) {
    cerune_array_i64_3 cerune_binding_0_values = (cerune_array_i64_3){ .items = { 2, 4, 6 } };
    cerune_array_i64_3 cerune_binding_1_copy = cerune_binding_0_values;
    cerune_binding_0_values = (cerune_array_i64_3){ .items = { 1, 3, 5 } };
    printf("%lld\n", (long long)(cerune_array_get_i64_3(cerune_binding_1_copy, 2, " node=13 bytes=85..92\n")));
    printf("%lld\n", (long long)(cerune_array_get_i64_3(cerune_binding_0_values, 1, " node=17 bytes=101..110\n")));
    return 0;
}
