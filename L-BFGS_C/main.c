#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <windows.h>


#define N 50
#define MAX_SAVE 10	
#define MAX_ITER 100 
#define EPSILON0 1e-3 
#define EPSILON1 1e-5 
#define ROWS_M 204
#define COLS_M 50
#define ROWS_X COLS_M 
#define COLS_X 1



extern double OFU(double x[50]);
extern void readMatrix(const char* filename, double matrix[], int rows, int cols);
extern double GCU(double x[50], double g[50]);
extern double derphi0(double gk[50], double dk[50]);
extern double LSU(double x[50], double gk[50], double dk[50], double phi_0, double derphi0);
extern void SDU(const double gxk[N], const double s[][N], const double y[][N], const double rho[], int m, double result[N]);


void readCoefficients(const char* filename, double* c0, double* c1, double* c2, double* c3, double* c4, double* c5, double* tranx, double* trany) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }

    double value;
    int line = 0;
    while (fscanf(file, "%lf", &value) != EOF) {
        line++;
        if (line == 1) {
            *c0 = value;
        } else if (line == 2) {
            *c1 = value;
        } else if (line == 3) {
            *c2 = value;
        } else if (line == 4) {
            *c3 = value;
        } else if (line == 5) {
            *c4 = value;
        } else if (line == 6) {
            *c5 = value;
        } else if (line == 7) {
            *tranx = value;
        } else if (line == 8) {
            *trany = value;
            break;
        }
    }

    fclose(file);
}


void readMatrix(const char* filename, double matrix[], int rows, int cols) {
    FILE* file = fopen(filename, "r");
    if (file == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            fscanf(file, "%lf", &matrix[i * cols + j]);
        }
    }
    
    fclose(file);
}

void update_vector(double* x, double* g, double* d, double alpha, double* x_new) {
    // Update x: x_new = x + alpha * d
    for (int i = 0; i < 50; i++) {
        x_new[i] = x[i] + alpha * d[i];
    }
}

int minimum(int a, int b) {
    return (a <= b) ? a : b;
}


double get_time_in_seconds() {
    LARGE_INTEGER frequency;
    LARGE_INTEGER start;
    QueryPerformanceFrequency(&frequency); 
    QueryPerformanceCounter(&start);       
    return (double)start.QuadPart / frequency.QuadPart; 
}


typedef struct {
    double M[ROWS_M * COLS_M];
    double x_m[ROWS_X];
    double id_var_1[ROWS_X];
    double lmpos[136];
    double c0, c1, c2, c3, c4, c5, tranx, trany;
} Data;

Data global_data;


int main()
{

	double x[N];   
    double f;     
    double g[N];  
    double d[N];  
    double s[MAX_SAVE][N]; 
    double y[MAX_SAVE][N]; 
    double rho[MAX_SAVE];  
	
	
	readMatrix("txt/x.txt", x, 50, 1);
	
	readMatrix("txt/M.txt", global_data.M, ROWS_M, COLS_M);
    readMatrix("txt/x.txt", global_data.x_m, ROWS_X, COLS_X);
    readMatrix("txt/1_div_id_var.txt", global_data.id_var_1, ROWS_X, COLS_X);
    readCoefficients("txt/cofficient.txt", &global_data.c0, &global_data.c1, &global_data.c2, &global_data.c3, &global_data.c4, &global_data.c5, &global_data.tranx, &global_data.trany);
    readMatrix("txt/lm_pos_div_scale.txt", global_data.lmpos, 136, 1);
	
	
	double cpu_time_used, SDU_time, LSU_time, OFU_time, start, end, SDU_start, SDU_end, LSU_start, LSU_end, OFU_start, OFU_end, GCU_start, GCU_end, GCU_time; 

	start = get_time_in_seconds();
	
	f = OFU(x);
	printf("iteration 0\n");
	printf("function value: %lf\n",f);
	
	printf("\niteration 1\n");
	GCU_start = get_time_in_seconds();
	GCU(x, g);	
	GCU_end = get_time_in_seconds();
	GCU_time = ((double) (GCU_end - GCU_start));
	printf("GCU time: %.12lfsec\n", GCU_time);


	for (int i = 0; i < 50; i++) {
        d[i] = -g[i];
    }

	
	int total_iter = 1; 
    int cnt_iter = 0;   
    double f_curr = f; 
    
	
	while (total_iter < MAX_ITER) {
		
		LSU_start = get_time_in_seconds();
        double derphi_0 = derphi0(g, d); 

        double alpha = LSU(x, g, d, f_curr, derphi_0); 
        LSU_end = get_time_in_seconds();
        LSU_time = ((double) (LSU_end - LSU_start));
    	printf("LSU+OFU time: %.12lfsec\n", LSU_time);
        
        //printf("alpha:%.12lf\n",alpha);
  
        
  
        double x_next[N], g_next[N];
        update_vector(x, g, d, alpha, x_next);
        
        OFU_start = get_time_in_seconds();
        f_curr = OFU(x_next);
        OFU_end = get_time_in_seconds();
        OFU_time = ((double) (OFU_end - OFU_start));
    	printf("OFU time: %.12lfsec\n", OFU_time);
        
        
        
        printf("function value: %lf\n",f_curr);
        
        
       

	        	
		double diff_f = fabs(f_curr - f);
		if (diff_f <= EPSILON0) {
            printf("\nSatisfy f condition and converge to the number of iterations %d\n", total_iter);
            end = get_time_in_seconds();
            cpu_time_used = ((double) (end - start));
            printf("CPU time per iteration: %.12lfsec\n", cpu_time_used/total_iter);
    		printf("CPU total time: %.12lfsec\n", cpu_time_used);
            break;
        }
		
		
		printf("\niteration %d\n",total_iter+1);
		
		GCU_start = get_time_in_seconds();
		GCU(x_next, g_next);	
		GCU_end = get_time_in_seconds();
		GCU_time = ((double) (GCU_end - GCU_start));
		printf("GCU time: %.12lfsec\n", GCU_time);
		
		
		
        for (int i = 0; i < N; i++) {
        	if (fabs(g_next[i])<= EPSILON1) {
            printf("Satisfy g condition and converge to the number of iterations %d\n", total_iter);
            end = get_time_in_seconds();
            cpu_time_used = ((double) (end - start));
    		printf("CPU time per iteration: %.12lfsec\n", cpu_time_used/total_iter);
    		printf("CPU total time: %.12lfsec\n", cpu_time_used);
            goto end_while;
        	}
        }
    
		
		if (cnt_iter >= MAX_SAVE) {
		    for (int j = 0; j < MAX_SAVE - 1; j++) {
		        for (int i = 0; i < N; i++) {
		            s[j][i] = s[j + 1][i];
		            y[j][i] = y[j + 1][i];
		        }
		    }
		    // update rho 
		    for (int j = 0; j < MAX_SAVE - 1; j++) {
		        rho[j] = rho[j + 1];
		    }
		
		    
		    for (int i = 0; i < N; i++) {
		        s[MAX_SAVE - 1][i] = x_next[i] - x[i];
		        y[MAX_SAVE - 1][i] = g_next[i] - g[i];
		    }
		    
		    // update rho_k
		    double sk_yk = 0.0;
		    for (int i = 0; i < N; i++) {
		        sk_yk += s[MAX_SAVE - 1][i] * y[MAX_SAVE - 1][i];
		    }
		    rho[MAX_SAVE - 1] = 1.0 / sk_yk;
		} else {
		    
		    for (int i = 0; i < N; i++) {
		        s[cnt_iter][i] = x_next[i] - x[i];
		        y[cnt_iter][i] = g_next[i] - g[i];
		    }
		
		   
		    double sk_yk = 0.0;
		    for (int i = 0; i < N; i++) {
		        sk_yk += s[cnt_iter][i] * y[cnt_iter][i];
		    }
		    rho[cnt_iter] = 1.0 / sk_yk;
		}


        for (int i = 0; i < N; i++) {
            x[i] = x_next[i];
            g[i] = g_next[i];
            
        }
        
        SDU_start = get_time_in_seconds();
        SDU(g, (const double (*)[N])s, (const double (*)[N])y, rho, minimum(cnt_iter, MAX_SAVE-1), d);
        
        for (int i = 0; i < N; i++) {
    		d[i] = -d[i];  
    	//	printf("%.10lf\n",d[i]);
		}
		
		
		SDU_end = get_time_in_seconds();
        SDU_time = ((double) (SDU_end - SDU_start));
    	printf("SDU time: %.12lfsec\n", SDU_time);

        f = f_curr;
     
        cnt_iter++;
        total_iter++;
    }
		
	
	end_while: return 0;

	}



