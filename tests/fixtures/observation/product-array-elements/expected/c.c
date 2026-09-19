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

typedef struct cerune_type_Point_0 {
    int64_t x;
    int64_t y;
} cerune_type_Point_0;

typedef struct cerune_array_type_Point_0_2 {
    cerune_type_Point_0 items[2];
} cerune_array_type_Point_0_2;

static cerune_type_Point_0 cerune_array_get_type_Point_0_2(cerune_array_type_Point_0_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

int main(void) {
    cerune_array_type_Point_0_2 cerune_binding_0_points = (cerune_array_type_Point_0_2){ .items = { (cerune_type_Point_0){ .x = 1, .y = 2 }, (cerune_type_Point_0){ .x = 3, .y = 4 } } };
    cerune_array_type_Point_0_2 cerune_binding_1_copy = cerune_binding_0_points;
    cerune_binding_0_points = (cerune_array_type_Point_0_2){ .items = { (cerune_type_Point_0){ .x = 5, .y = 6 }, (cerune_type_Point_0){ .x = 7, .y = 8 } } };
    printf("%lld\n", (long long)((cerune_array_get_type_Point_0_2(cerune_binding_1_copy, 1, " node=20 bytes=204..211\n")).x));
    printf("%lld\n", (long long)((cerune_array_get_type_Point_0_2(cerune_binding_0_points, 0, " node=25 bytes=222..231\n")).y));
    return 0;
}
