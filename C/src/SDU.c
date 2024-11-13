#include <stdio.h>
#include <stdlib.h>

// 定义数组维度
#define DIM 50

// 计算向量点积
double dot_product(const double* a, const double* b, int size) {
    double result = 0.0;
    for (int i = 0; i < size; i++) {
        result += a[i] * b[i];
    }
    return result;
}

// 向量减法 q = q - alpha[i] * y[i]
void vector_subtract(double* q, const double* y, double alpha, int size) {
    for (int i = 0; i < size; i++) {
        q[i] -= alpha * y[i];
    }
}

// 向量加法 r = r + s[i] * (alpha[i] - beta)
void vector_add(double* r, const double* s, double alpha_minus_beta, int size) {
    for (int i = 0; i < size; i++) {
        r[i] += s[i] * alpha_minus_beta;
    }
}

// 逆Hessian矩阵乘积计算
void SDU(const double gxk[DIM], const double (*s)[DIM], const double (*y)[DIM], const double rho[], int maxcor, double result[DIM]) {
    double q[DIM];
    double alpha[maxcor+1];  // 存储alpha值
    double r[DIM];

    // 调整maxcor的值
    //maxcor = maxcor + 1;

    // 初始化 q 为 gxk
    for (int i = 0; i < DIM; i++) {
        q[i] = gxk[i];
    }

    // 第一阶段计算 alpha 和更新 q
    for (int i = maxcor ; i >= 0; i--) {
        alpha[i] = rho[i] * dot_product(s[i], q, DIM);
        vector_subtract(q, y[i], alpha[i], DIM);
    }
    
    // 初始化 r 为 q
    for (int i = 0; i < DIM; i++) {
        r[i] = q[i];
    }

    // 第二阶段计算 beta 和更新 r
    for (int i = 0; i <= maxcor; i++) {
        double beta = rho[i] * dot_product(y[i], r, DIM);
        vector_add(r, s[i], alpha[i] - beta, DIM);
    }

    // 将结果存储到 result 数组
    for (int i = 0; i < DIM; i++) {
        result[i] = r[i];
    }
}

