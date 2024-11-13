#include <stdio.h>
#include <stdlib.h>

// ��������ά��
#define DIM 50

// �����������
double dot_product(const double* a, const double* b, int size) {
    double result = 0.0;
    for (int i = 0; i < size; i++) {
        result += a[i] * b[i];
    }
    return result;
}

// �������� q = q - alpha[i] * y[i]
void vector_subtract(double* q, const double* y, double alpha, int size) {
    for (int i = 0; i < size; i++) {
        q[i] -= alpha * y[i];
    }
}

// �����ӷ� r = r + s[i] * (alpha[i] - beta)
void vector_add(double* r, const double* s, double alpha_minus_beta, int size) {
    for (int i = 0; i < size; i++) {
        r[i] += s[i] * alpha_minus_beta;
    }
}

// ��Hessian����˻�����
void SDU(const double gxk[DIM], const double (*s)[DIM], const double (*y)[DIM], const double rho[], int maxcor, double result[DIM]) {
    double q[DIM];
    double alpha[maxcor+1];  // �洢alphaֵ
    double r[DIM];

    // ����maxcor��ֵ
    //maxcor = maxcor + 1;

    // ��ʼ�� q Ϊ gxk
    for (int i = 0; i < DIM; i++) {
        q[i] = gxk[i];
    }

    // ��һ�׶μ��� alpha �͸��� q
    for (int i = maxcor ; i >= 0; i--) {
        alpha[i] = rho[i] * dot_product(s[i], q, DIM);
        vector_subtract(q, y[i], alpha[i], DIM);
    }
    
    // ��ʼ�� r Ϊ q
    for (int i = 0; i < DIM; i++) {
        r[i] = q[i];
    }

    // �ڶ��׶μ��� beta �͸��� r
    for (int i = 0; i <= maxcor; i++) {
        double beta = rho[i] * dot_product(y[i], r, DIM);
        vector_add(r, s[i], alpha[i] - beta, DIM);
    }

    // ������洢�� result ����
    for (int i = 0; i < DIM; i++) {
        result[i] = r[i];
    }
}

