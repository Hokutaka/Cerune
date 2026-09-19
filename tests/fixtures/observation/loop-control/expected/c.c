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
    int64_t cerune_binding_0_value = 0;
    int64_t cerune_binding_1_sum = 0;
    while (cerune_binding_0_value < 10) {
        cerune_binding_0_value = cerune_i64_add(cerune_binding_0_value, 1, " node=9 bytes=70..79\n");
        if (cerune_binding_0_value < 3) {
            continue;
        }
        if (cerune_binding_0_value > 5) {
            break;
        }
        cerune_binding_1_sum = cerune_i64_add(cerune_binding_1_sum, cerune_binding_0_value, " node=23 bytes=177..188\n");
    }
    printf("%lld\n", (long long)(cerune_binding_1_sum));
    printf("%lld\n", (long long)(cerune_binding_0_value));
    return 0;
}
