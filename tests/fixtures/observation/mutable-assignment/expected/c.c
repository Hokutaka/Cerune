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
    int64_t cerune_binding_0_count = 40;
    cerune_binding_0_count = cerune_i64_add(cerune_binding_0_count, 2, " node=3 bytes=29..38\n");
    float cerune_binding_1_ratio = 0.25f;
    cerune_binding_1_ratio = (cerune_binding_1_ratio * 2.0f);
    printf("%lld\n", (long long)(cerune_binding_0_count));
    printf("%.9g\n", (double)(cerune_binding_1_ratio));
    return 0;
}
