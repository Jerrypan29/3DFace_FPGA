#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>

#define ROWS_M 204
#define COLS_M 50
#define ROWS_X COLS_M 
#define COLS_X 1

typedef struct {
    double M[ROWS_M * COLS_M];
    double x_m[ROWS_X];
    double id_var_1[ROWS_X];
    double lmpos[136];
    double c0, c1, c2, c3, c4, c5, tranx, trany;
} Data;

extern Data global_data;

// ����˷�
void multiplyMatrices(double M[], double x[], double result[]) {
    for (int i = 0; i < ROWS_M; i++) {
        result[i] = 0; // ��ʼ���������
        for (int j = 0; j < COLS_M; j++) {
            result[i] += M[i * COLS_M + j] * x[j]; // �������
        }
    }
}

// ��ӡ����ĺ���
void printMatrix(double matrix[], int rows) {
    for (int i = 0; i < rows; i++) {
        printf("%lf\n", matrix[i]);
    }
}

// �������Ա任
void calculatelm(double v[], double result[], double c0, double c1, double c2, double tran, int rows) {
    for (int i = 0; i < rows; i++) {
        result[i] = v[i * 3 + 0] * c0 + v[i * 3 + 1] * c1 + v[i * 3 + 2] * c2 + tran;
    }
}



double OFU(double x[50]) {
    double v[ROWS_M];    
    
    // ���о���˷�
    multiplyMatrices(global_data.M, x, v);
    
    double lmx[ROWS_M/3];
    double lmy[ROWS_M/3];
    calculatelm(v, lmx, global_data.c0, global_data.c1, global_data.c2, global_data.tranx, ROWS_M/3);
    calculatelm(v, lmy, global_data.c3, global_data.c4, global_data.c5, global_data.trany, ROWS_M/3);
    
    double point = 0.0;
    for (int i = 0; i < 68; i++) {
        point += (lmx[i] - global_data.lmpos[i*2]) * (lmx[i] - global_data.lmpos[i*2]);  
    }
	
    for (int i = 0; i < 68; i++) {
        point += (lmy[i] - global_data.lmpos[i*2+1]) * (lmy[i] - global_data.lmpos[i*2+1]);  
    }
	
    double weight = 1.0;
    double regu = 0.0;
    for (int i = 0; i < 50; i++) {
        regu += (x[i] - global_data.x_m[i]) * (x[i] - global_data.x_m[i]) * weight * global_data.id_var_1[i];
    }

    double function = point + regu;
    return function;
}



//��Ҫ����temp 
/*
double GCU(double x[50]) {
    double g[50];       // �洢ÿ�� x[i] �ĵ���
    double y1, y2;      // ���ڴ洢 OFU ������ֵ
    double deltax = 1e-5; // ����һ����С������
    double x_temp1[50];  // ���ڴ洢�޸ĺ�� x ����
    double x_temp2[50];

    // ���� x �����е�ÿ��Ԫ��
    for (int i = 0; i < 50; i++) {
        // ���� x ���鵽��ʱ���� x_temp ��
        for (int j = 0; j < 50; j++) {
            x_temp1[j] = x[j];
            x_temp2[j] = x[j];
        }

        // ���� OFU(x)
        // ��ǰ x �ĺ���ֵ

        // �޸� x_temp[i]������һ�� deltax
        x_temp1[i] += deltax;
        x_temp2[i] -= deltax;

        // ���� OFU(x_temp)���� x[i] ���� deltax ��ĺ���ֵ
        
        y1 = OFU(x_temp1); 
        y2 = OFU(x_temp2);

        // ʹ�����޲�ַ����㵼��
        
        
        printf("f1: %lf\n", y1);
        printf("f2: %lf\n", y2);
        g[i] = (y2 - y1) / (2*deltax);
    }

    // ��ӡ�������� g
    for (int i = 0; i < 50; i++) {
        printf("g[%d] = %lf\n", i, g[i]);
    }

    return 0; // 
}

*/


void GCU(double x[50], double g[50]) {      
    double y1, y2;       // ���ڴ洢 OFU ������ֵ
    double deltax = 1e-5; // ����һ����С������
    double original;     // ���ڴ洢 x[i] ��ԭʼֵ

    // ���� x �����е�ÿ��Ԫ��
    for (int i = 0; i < 50; i++) {
        // ���� x[i] ��ԭʼֵ
        original = x[i];

        // ���� x[i] + deltax �� x[i] - deltax ʱ�ĺ���ֵ
        x[i] = original + deltax;
        y1 = OFU(x); 

        x[i] = original - deltax;
        y2 = OFU(x);

        // ʹ�����޲�ַ����㵼��
        g[i] = (y1 - y2) / (2 * deltax);

        // �ָ� x[i] ��ԭʼֵ
        x[i] = original;
    }

}
	


