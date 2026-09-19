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
    int64_t cerune_binding_0_sum = 0;
    for (int64_t cerune_binding_1_i = 0; (cerune_binding_1_i < 6); cerune_binding_1_i = cerune_i64_add(cerune_binding_1_i, 1, " node=18 bytes=51..56\n")) {
        if (cerune_binding_1_i < 2) {
            continue;
        }
        cerune_binding_0_sum = cerune_i64_add(cerune_binding_0_sum, cerune_binding_1_i, " node=14 bytes=110..117\n");
    }
    printf("%lld\n", (long long)(cerune_binding_0_sum));
    return 0;
}
