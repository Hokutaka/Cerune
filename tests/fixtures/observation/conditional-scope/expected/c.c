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

static int64_t cerune_i64_neg(int64_t value, const char *origin) {
    if (value == INT64_MIN) {
        cerune_runtime_fail("integer-overflow", origin);
    }
    return -value;
}

int main(void) {
    int64_t cerune_binding_0_value = 1;
    if (cerune_binding_0_value < 2) {
        cerune_binding_0_value = 42;
        bool cerune_binding_1_value = true;
        printf("%s\n", (cerune_binding_1_value) ? "true" : "false");
    } else {
        cerune_binding_0_value = cerune_i64_neg(1, " node=13 bytes=115..117\n");
    }
    printf("%lld\n", (long long)(cerune_binding_0_value));
    return 0;
}
