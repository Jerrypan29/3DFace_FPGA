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

// 矩阵乘法
void multiplyMatrices(double M[], double x[], double result[]) {
    for (int i = 0; i < ROWS_M; i++) {
        result[i] = 0; // 初始化结果矩阵
        for (int j = 0; j < COLS_M; j++) {
            result[i] += M[i * COLS_M + j] * x[j]; // 矩阵相乘
        }
    }
}

// 打印矩阵的函数
void printMatrix(double matrix[], int rows) {
    for (int i = 0; i < rows; i++) {
        printf("%lf\n", matrix[i]);
    }
}

// 计算线性变换
void calculatelm(double v[], double result[], double c0, double c1, double c2, double tran, int rows) {
    for (int i = 0; i < rows; i++) {
        result[i] = v[i * 3 + 0] * c0 + v[i * 3 + 1] * c1 + v[i * 3 + 2] * c2 + tran;
    }
}



double OFU(double x[50]) {
    double v[ROWS_M];    
    
    // 进行矩阵乘法
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



//需要两个temp 
/*
double GCU(double x[50]) {
    double g[50];       // 存储每个 x[i] 的导数
    double y1, y2;      // 用于存储 OFU 函数的值
    double deltax = 1e-5; // 定义一个很小的增量
    double x_temp1[50];  // 用于存储修改后的 x 数组
    double x_temp2[50];

    // 遍历 x 数组中的每个元素
    for (int i = 0; i < 50; i++) {
        // 复制 x 数组到临时数组 x_temp 中
        for (int j = 0; j < 50; j++) {
            x_temp1[j] = x[j];
            x_temp2[j] = x[j];
        }

        // 计算 OFU(x)
        // 当前 x 的函数值

        // 修改 x_temp[i]，增加一个 deltax
        x_temp1[i] += deltax;
        x_temp2[i] -= deltax;

        // 计算 OFU(x_temp)，即 x[i] 增加 deltax 后的函数值
        
        y1 = OFU(x_temp1); 
        y2 = OFU(x_temp2);

        // 使用有限差分法计算导数
        
        
        printf("f1: %lf\n", y1);
        printf("f2: %lf\n", y2);
        g[i] = (y2 - y1) / (2*deltax);
    }

    // 打印导数数组 g
    for (int i = 0; i < 50; i++) {
        printf("g[%d] = %lf\n", i, g[i]);
    }

    return 0; // 
}

*/


void GCU(double x[50], double g[50]) {      
    double y1, y2;       // 用于存储 OFU 函数的值
    double deltax = 1e-5; // 定义一个很小的增量
    double original;     // 用于存储 x[i] 的原始值

    // 遍历 x 数组中的每个元素
    for (int i = 0; i < 50; i++) {
        // 保存 x[i] 的原始值
        original = x[i];

        // 计算 x[i] + deltax 和 x[i] - deltax 时的函数值
        x[i] = original + deltax;
        y1 = OFU(x); 

        x[i] = original - deltax;
        y2 = OFU(x);

        // 使用有限差分法计算导数
        g[i] = (y1 - y2) / (2 * deltax);

        // 恢复 x[i] 的原始值
        x[i] = original;
    }

}
	


