#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stddef.h>
#include <string.h>
#ifdef _WIN32
#include <io.h>
#include <fcntl.h>
#endif

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

int main(void) {
#ifdef _WIN32
    if (_setmode(_fileno(stdout), _O_BINARY) == -1) {
        fputs("cerune: cannot set stdout to binary mode\n", stderr);
        return 1;
    }
#endif
    cerune_string cerune_binding_0_text = (cerune_string){ (const unsigned char *)"\346\227\245\346\234\254\350\252\236\012\000", 11 };
    cerune_string cerune_binding_1_saved = cerune_binding_0_text;
    cerune_binding_0_text = (cerune_string){ (const unsigned char *)"\143\150\141\156\147\145\144", 7 };
    printf("%s\n", ((cerune_string_equal(cerune_binding_1_saved, (cerune_string){ (const unsigned char *)"\346\227\245\346\234\254\350\252\236\012\000", 11 }))) ? "true" : "false");
    cerune_print_string(cerune_binding_0_text);
    return 0;
}
