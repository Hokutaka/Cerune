int check(long long a, long long b, long long c, long long d, float value) {
    return value == 1.5f;
}
int main(void) { return 1 - check(1, 2, 3, 4, 1.5f); }
