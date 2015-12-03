package com;


public class Simple0 {


    public Simple0() {

    }

    public static long ackermann(long m, long n) {
        if (m == 0) return n + 1;
        if (n == 0) return ackermann(m - 1, 1);
        return ackermann(m - 1, ackermann(m, n - 1));
    }

}