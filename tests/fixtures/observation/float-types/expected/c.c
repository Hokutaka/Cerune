#include <stdint.h>
#include <stdio.h>

int main(void) {
    float cerune_binding_0_single = (0.1f + 0.2f);
    double cerune_binding_1_double = (0.1 + 0.2);
    double cerune_binding_2_inferred = (0.1 + 0.2);
    float cerune_binding_3_suffixed = (0.1f + 0.2f);
    printf("%.9g\n", (double)(cerune_binding_0_single));
    printf("%.17g\n", (double)(cerune_binding_1_double));
    printf("%.17g\n", (double)(cerune_binding_2_inferred));
    printf("%.9g\n", (double)(cerune_binding_3_suffixed));
    return 0;
}
