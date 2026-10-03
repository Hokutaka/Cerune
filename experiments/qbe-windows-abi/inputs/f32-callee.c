static volatile float value = 1.5;
float source(void) { return value; }
int check(long long a, long long b, long long c, long long d, float x) {
    return a == 1 && b == 2 && c == 3 && d == 4 && x == 1.5;
}
