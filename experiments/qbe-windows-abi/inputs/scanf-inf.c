#include <stdio.h>
int main(void) {
    double value = 0;
    int count = sscanf("inf", "%lf", &value);
    printf("matched=%d positive_large=%d\n", count, value > 1e300);
    return 0;
}
