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

int main(void) {
    bool cerune_binding_0_truth = true;
    bool cerune_binding_1_negated = (!cerune_binding_0_truth);
    bool cerune_binding_2_same = (cerune_binding_0_truth == true);
    bool cerune_binding_3_integer_order = (cerune_i64_add(1, 2, " node=11 bytes=94..99\n") < 4);
    bool cerune_binding_4_float_difference = (0.1f != 0.2f);
    printf("%s\n", (cerune_binding_0_truth) ? "true" : "false");
    printf("%s\n", (cerune_binding_1_negated) ? "true" : "false");
    printf("%s\n", (cerune_binding_2_same) ? "true" : "false");
    printf("%s\n", (cerune_binding_3_integer_order) ? "true" : "false");
    printf("%s\n", (cerune_binding_4_float_difference) ? "true" : "false");
    return 0;
}
