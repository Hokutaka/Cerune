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

bool cerune_fn_report_0(bool cerune_binding_0_value);

bool cerune_fn_report_0(bool cerune_binding_0_value) {
    printf("%s\n", (cerune_binding_0_value) ? "true" : "false");
    return cerune_binding_0_value;
}

int main(void) {
    cerune_array_i64_2 cerune_binding_1_values = (cerune_array_i64_2){ .items = { 4, 9 } };
    int64_t cerune_binding_2_index = 2;
    printf("%s\n", (((cerune_binding_2_index < 2) && (cerune_array_get_i64_2(cerune_binding_1_values, cerune_binding_2_index, " node=16 bytes=134..147\n") > 0))) ? "true" : "false");
    printf("%s\n", (((cerune_binding_2_index == 2) || cerune_fn_report_0(false))) ? "true" : "false");
    printf("%s\n", ((false || (cerune_fn_report_0(true) && ((cerune_binding_2_index > 0) || cerune_fn_report_0(false))))) ? "true" : "false");
    return 0;
}
