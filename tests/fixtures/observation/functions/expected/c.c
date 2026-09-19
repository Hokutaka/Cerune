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

int64_t cerune_fn_add_0(int64_t cerune_binding_0_left, int64_t cerune_binding_1_right);
void cerune_fn_show_1(int64_t cerune_binding_2_value);

int64_t cerune_fn_add_0(int64_t cerune_binding_0_left, int64_t cerune_binding_1_right) {
    return cerune_i64_add(cerune_binding_0_left, cerune_binding_1_right, " node=1 bytes=50..62\n");
}

void cerune_fn_show_1(int64_t cerune_binding_2_value) {
    printf("%lld\n", (long long)(cerune_binding_2_value));
}

int main(void) {
    int64_t cerune_binding_3_answer = cerune_fn_add_0(20, 22);
    cerune_fn_show_1(cerune_binding_3_answer);
    return 0;
}
