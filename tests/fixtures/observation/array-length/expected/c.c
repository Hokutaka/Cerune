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

typedef struct cerune_array_i64_2 {
    int64_t items[2];
} cerune_array_i64_2;

static int64_t cerune_array_get_i64_2(cerune_array_i64_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

cerune_array_i64_2 cerune_fn_values_0(void);

cerune_array_i64_2 cerune_fn_values_0(void) {
    printf("%lld\n", (long long)(42));
    return (cerune_array_i64_2){ .items = { 10, 20 } };
}

int main(void) {
    printf("%lld\n", (long long)(((void)(cerune_fn_values_0()), INT64_C(2))));
    printf("%s\n", ((false && (((void)(cerune_fn_values_0()), INT64_C(2)) == 2))) ? "true" : "false");
    return 0;
}
