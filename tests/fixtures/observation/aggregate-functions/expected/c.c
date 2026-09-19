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

typedef struct cerune_array_array_i64_2_2 {
    cerune_array_i64_2 items[2];
} cerune_array_array_i64_2_2;

static cerune_array_i64_2 cerune_array_get_array_i64_2_2(cerune_array_array_i64_2_2 value, int64_t index, const char *origin) {
    if (index < 0 || index >= 2) {
        cerune_runtime_fail("array-index-out-of-bounds", origin);
    }
    return value.items[index];
}

typedef struct cerune_type_Point_0 {
    int64_t x;
    int64_t y;
} cerune_type_Point_0;

cerune_type_Point_0 cerune_fn_move_x_0(cerune_type_Point_0 cerune_binding_0_point, int64_t cerune_binding_1_amount);
cerune_type_Point_0 cerune_fn_move_twice_1(cerune_type_Point_0 cerune_binding_2_point, int64_t cerune_binding_3_amount);
cerune_array_i64_2 cerune_fn_first_row_2(cerune_array_array_i64_2_2 cerune_binding_4_matrix);
cerune_array_array_i64_2_2 cerune_fn_duplicate_3(cerune_array_i64_2 cerune_binding_5_row);
cerune_array_array_i64_2_2 cerune_fn_duplicate_first_row_4(cerune_array_array_i64_2_2 cerune_binding_6_matrix);

cerune_type_Point_0 cerune_fn_move_x_0(cerune_type_Point_0 cerune_binding_0_point, int64_t cerune_binding_1_amount) {
    return (cerune_type_Point_0){ .x = cerune_i64_add((cerune_binding_0_point).x, cerune_binding_1_amount, " node=2 bytes=118..134\n"), .y = (cerune_binding_0_point).y };
}

cerune_type_Point_0 cerune_fn_move_twice_1(cerune_type_Point_0 cerune_binding_2_point, int64_t cerune_binding_3_amount) {
    return cerune_fn_move_x_0(cerune_fn_move_x_0(cerune_binding_2_point, cerune_binding_3_amount), cerune_binding_3_amount);
}

cerune_array_i64_2 cerune_fn_first_row_2(cerune_array_array_i64_2_2 cerune_binding_4_matrix) {
    return cerune_array_get_array_i64_2_2(cerune_binding_4_matrix, 0, " node=15 bytes=332..341\n");
}

cerune_array_array_i64_2_2 cerune_fn_duplicate_3(cerune_array_i64_2 cerune_binding_5_row) {
    return (cerune_array_array_i64_2_2){ .items = { cerune_binding_5_row, cerune_binding_5_row } };
}

cerune_array_array_i64_2_2 cerune_fn_duplicate_first_row_4(cerune_array_array_i64_2_2 cerune_binding_6_matrix) {
    return cerune_fn_duplicate_3(cerune_fn_first_row_2(cerune_binding_6_matrix));
}

int main(void) {
    cerune_type_Point_0 cerune_binding_7_original = (cerune_type_Point_0){ .x = 2, .y = 3 };
    cerune_type_Point_0 cerune_binding_8_moved = cerune_fn_move_twice_1(cerune_binding_7_original, 5);
    cerune_array_array_i64_2_2 cerune_binding_9_matrix = (cerune_array_array_i64_2_2){ .items = { (cerune_array_i64_2){ .items = { 1, 2 } }, (cerune_array_i64_2){ .items = { 3, 4 } } } };
    cerune_array_array_i64_2_2 cerune_binding_10_rows = cerune_fn_duplicate_first_row_4(cerune_binding_9_matrix);
    printf("%lld\n", (long long)((cerune_binding_7_original).x));
    printf("%lld\n", (long long)((cerune_binding_8_moved).x));
    printf("%lld\n", (long long)((cerune_binding_8_moved).y));
    printf("%lld\n", (long long)(cerune_array_get_i64_2(cerune_array_get_array_i64_2_2(cerune_binding_9_matrix, 1, " node=56 bytes=760..769\n"), 0, " node=55 bytes=760..772\n")));
    printf("%lld\n", (long long)(cerune_array_get_i64_2(cerune_array_get_array_i64_2_2(cerune_binding_10_rows, 0, " node=62 bytes=781..788\n"), 1, " node=61 bytes=781..791\n")));
    printf("%lld\n", (long long)(cerune_array_get_i64_2(cerune_array_get_array_i64_2_2(cerune_binding_10_rows, 1, " node=68 bytes=800..807\n"), 0, " node=67 bytes=800..810\n")));
    return 0;
}
