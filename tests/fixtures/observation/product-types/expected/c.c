#include <stdint.h>
#include <stdio.h>

typedef struct cerune_type_Point_0 {
    double x;
    double y;
} cerune_type_Point_0;

typedef struct cerune_type_Segment_1 {
    cerune_type_Point_0 start;
    cerune_type_Point_0 end;
} cerune_type_Segment_1;

int main(void) {
    cerune_type_Point_0 cerune_binding_0_current = (cerune_type_Point_0){ .y = 2.0, .x = 0.0 };
    cerune_type_Point_0 cerune_binding_1_saved = cerune_binding_0_current;
    cerune_binding_0_current = (cerune_type_Point_0){ .x = 4.0, .y = 5.0 };
    cerune_type_Segment_1 cerune_binding_2_segment = (cerune_type_Segment_1){ .start = cerune_binding_1_saved, .end = cerune_binding_0_current };
    printf("%.17g\n", (double)((cerune_binding_1_saved).x));
    printf("%.17g\n", (double)((cerune_binding_1_saved).y));
    printf("%.17g\n", (double)(((cerune_binding_2_segment).start).y));
    printf("%.17g\n", (double)(((cerune_binding_2_segment).end).x));
    return 0;
}
