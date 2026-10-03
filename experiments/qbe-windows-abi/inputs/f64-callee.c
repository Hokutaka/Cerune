static volatile double value = 2.5;
double source(void) { return value; }
int check(long long a, long long b, long long c, long long d, double x) {
    return a == 1 && b == 2 && c == 3 && d == 4 && x == 2.5;
}
