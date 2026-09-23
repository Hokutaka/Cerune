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

cerune_array_i64_2 cerune_fn_values_0(void);

cerune_array_i64_2 cerune_fn_values_0(void) {
    printf("%lld\n", (long long)(42));
    return (cerune_array_i64_2){ .items = { 1, 2 } };
}

int main(void) {
    cerune_array_i64_2 cerune_binding_0__for_in_snapshot_0_54 = cerune_fn_values_0();
    int64_t cerune_binding_1__for_in_length_0_54 = ((void)(cerune_binding_0__for_in_snapshot_0_54), INT64_C(2));
    for (int64_t cerune_binding_2__for_in_cursor_0_54 = 0; (cerune_binding_2__for_in_cursor_0_54 < cerune_binding_1__for_in_length_0_54); cerune_binding_2__for_in_cursor_0_54 = cerune_i64_add(cerune_binding_2__for_in_cursor_0_54, 1, " node=35 bytes=54..98\n")) {
        int64_t cerune_binding_3_i = cerune_binding_2__for_in_cursor_0_54;
        int64_t cerune_binding_4_value = cerune_array_get_i64_2(cerune_binding_0__for_in_snapshot_0_54, cerune_binding_2__for_in_cursor_0_54, " node=20 bytes=69..85\n");
        if (cerune_binding_3_i == 0) {
            continue;
        }
        cerune_binding_4_value = cerune_i64_add(cerune_binding_4_value, 10, " node=29 bytes=141..151\n");
        printf("%lld\n", (long long)(cerune_binding_4_value));
    }
    return 0;
}
