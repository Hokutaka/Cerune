#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#endif
#include <stdlib.h>

static void cerune_runtime_fail(const char *code, const char *origin) {
    fflush(stdout);
    fputs("cerune: runtime-v1 code=", stderr);
    fputs(code, stderr);
    fputs(origin, stderr);
    fflush(stderr);
    abort();
}

typedef struct cerune_string {
    const unsigned char *data;
    size_t length;
} cerune_string;

static inline bool cerune_string_equal(cerune_string left, cerune_string right) {
    return left.length == right.length &&
        (left.length == 0 || memcmp(left.data, right.data, left.length) == 0);
}

static inline void cerune_print_string(cerune_string value) {
    fwrite(value.data, 1, value.length, stdout);
    fputc('\n', stdout);
}


typedef struct cerune_string_owner {
    struct cerune_string_owner *next;
    uint64_t references;
    size_t length;
    unsigned char data[];
} cerune_string_owner;
static cerune_string_owner *cerune_string_owners;
static uint64_t cerune_string_live_bytes;
static void cerune_string_retain(cerune_string value) {
    for (cerune_string_owner *p = cerune_string_owners; p; p = p->next)
        if (p->data == value.data) { ++p->references; return; }
}
static void cerune_string_release(cerune_string value) {
    cerune_string_owner **link = &cerune_string_owners;
    while (*link) {
        cerune_string_owner *p = *link;
        if (p->data == value.data) {
            if (--p->references == 0) {
                *link = p->next;
                cerune_string_live_bytes -= p->length;
                free(p);
            }
            return;
        }
        link = &p->next;
    }
}
static cerune_string cerune_string_concat(cerune_string left, cerune_string right, const char *origin) {
    if (right.length > (uint64_t)INT64_MAX - left.length ||
        right.length > SIZE_MAX - left.length ||
        left.length + right.length > SIZE_MAX - sizeof(cerune_string_owner))
        cerune_runtime_fail("allocation-size-overflow", origin);
    size_t length = left.length + right.length;
    if (!length) return (cerune_string){(const unsigned char *)"", 0};
    if ((uint64_t)length > UINT64_C(67108864) - cerune_string_live_bytes)
        cerune_runtime_fail("allocation-limit-exceeded", origin);
    cerune_string_owner *p = malloc(sizeof(cerune_string_owner) + length);
    if (!p) cerune_runtime_fail("allocation-failed", origin);
    p->next = cerune_string_owners;
    p->references = 1;
    p->length = length;
    memcpy(p->data, left.data, left.length);
    memcpy(p->data + left.length, right.data, right.length);
    cerune_string_owners = p;
    cerune_string_live_bytes += length;
    return (cerune_string){p->data, length};
}
cerune_string cerune_fn__ownership0_0(void);
cerune_string cerune_fn__ownership1_1(cerune_string cerune_binding_5__owned5);
cerune_string cerune_fn__ownership2_2(cerune_string cerune_binding_7__owned7);
cerune_string cerune_fn__ownership3_3(cerune_string cerune_binding_11__owned11, cerune_string cerune_binding_12__owned12);
cerune_string cerune_fn__ownership4_4(cerune_string cerune_binding_13__owned13);
cerune_string cerune_fn__ownership5_5(cerune_string cerune_binding_16__owned16);

cerune_string cerune_fn__ownership0_0(void) {
    cerune_string cerune_binding_2__owned2 = (cerune_string){ (const unsigned char *)"\346\227\245", 3 };
    cerune_string_retain(cerune_binding_2__owned2);
    cerune_string cerune_binding_3__owned3 = (cerune_string){ (const unsigned char *)"\346\234\254", 3 };
    cerune_string_retain(cerune_binding_3__owned3);
    cerune_string cerune_binding_4__owned4 = cerune_string_concat(cerune_binding_2__owned2, cerune_binding_3__owned3, " node=1 bytes=19..39\n");
    cerune_string_release(cerune_binding_3__owned3);
    cerune_string_release(cerune_binding_2__owned2);
    return cerune_binding_4__owned4;
}

cerune_string cerune_fn__ownership1_1(cerune_string cerune_binding_5__owned5) {
    cerune_string cerune_binding_6__owned6 = cerune_binding_5__owned5;
    cerune_string_retain(cerune_binding_6__owned6);
    return cerune_binding_6__owned6;
}

cerune_string cerune_fn__ownership2_2(cerune_string cerune_binding_7__owned7) {
    cerune_string cerune_binding_8__owned8 = cerune_binding_7__owned7;
    cerune_string_retain(cerune_binding_8__owned8);
    cerune_string cerune_binding_9__owned9 = (cerune_string){ (const unsigned char *)"\041", 1 };
    cerune_string_retain(cerune_binding_9__owned9);
    cerune_string cerune_binding_10__owned10 = cerune_string_concat(cerune_binding_8__owned8, cerune_binding_9__owned9, " node=7 bytes=70..87\n");
    cerune_string_release(cerune_binding_9__owned9);
    cerune_string_release(cerune_binding_8__owned8);
    return cerune_binding_10__owned10;
}

cerune_string cerune_fn__ownership3_3(cerune_string cerune_binding_11__owned11, cerune_string cerune_binding_12__owned12) {
    cerune_string_release(cerune_binding_11__owned11);
    return cerune_binding_12__owned12;
}

cerune_string cerune_fn__ownership4_4(cerune_string cerune_binding_13__owned13) {
    cerune_string cerune_binding_14__owned14 = cerune_binding_13__owned13;
    cerune_string_retain(cerune_binding_14__owned14);
    return cerune_binding_14__owned14;
}

cerune_string cerune_fn__ownership5_5(cerune_string cerune_binding_16__owned16) {
    cerune_string cerune_binding_17__owned17 = cerune_binding_16__owned16;
    cerune_string_retain(cerune_binding_17__owned17);
    return cerune_binding_17__owned17;
}

int main(void) {
#ifdef _WIN32
    if (_setmode(_fileno(stdout), _O_BINARY) == -1) {
        fputs("cerune: cannot set stdout to binary mode\n", stderr);
        return 1;
    }
#endif
    cerune_string cerune_binding_0_text = cerune_fn__ownership0_0();
    cerune_string cerune_binding_1_saved = cerune_fn__ownership1_1(cerune_binding_0_text);
    cerune_binding_0_text = cerune_fn__ownership3_3(cerune_binding_0_text, cerune_fn__ownership2_2(cerune_binding_0_text));
    cerune_string cerune_binding_15__owned15 = cerune_fn__ownership4_4(cerune_binding_1_saved);
    cerune_print_string(cerune_binding_15__owned15);
    cerune_string_release(cerune_binding_15__owned15);
    cerune_string cerune_binding_18__owned18 = cerune_fn__ownership5_5(cerune_binding_0_text);
    cerune_print_string(cerune_binding_18__owned18);
    cerune_string_release(cerune_binding_18__owned18);
    cerune_string_release(cerune_binding_1_saved);
    cerune_string_release(cerune_binding_0_text);
    return 0;
}
