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

typedef struct cerune_type_Row_0 {
    cerune_array_i64_3 values;
} cerune_type_Row_0;

int main(void) {
    cerune_type_Row_0 cerune_binding_0_first = (cerune_type_Row_0){ .values = (cerune_array_i64_3){ .items = { 1, 2, 3 } } };
    cerune_type_Row_0 cerune_binding_1_second = cerune_binding_0_first;
    cerune_binding_0_first = (cerune_type_Row_0){ .values = (cerune_array_i64_3){ .items = { 4, 5, 6 } } };
    printf("%lld\n", (long long)(cerune_array_get_i64_3((cerune_binding_1_second).values, 1, " node=15 bytes=145..161\n")));
    printf("%lld\n", (long long)(cerune_array_get_i64_3((cerune_binding_0_first).values, 2, " node=20 bytes=170..185\n")));
    return 0;
}
