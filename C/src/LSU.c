#include <stdio.h>
#include <math.h>


#define MAX_ITER 1000
#define c 1e-4
#define alpha_min 0
#define rho_lo 0.04
#define rho_hi 0.5



extern double OFU(double x[50]);




// Function prototypes
double phi(double x[50], double alpha, double dk[50]) {
    double x_alpha_dk[50];
    
    for (int i = 0; i < 50; i++) {
        x_alpha_dk[i] = x[i] + alpha * dk[i];
    }
    return OFU(x_alpha_dk); 
}


double derphi0(double gk[50], double dk[50]){
	double derphi0 = 0.0;
	for (int i = 0 ; i < 50 ; i++){
		derphi0 += gk[i] * dk[i];
	}
	return derphi0;
}

double LSU(double x[50], double gk[50], double dk[50], double phi_0, double derphi0) {
    double alpha_0 = 1.0;
    double alpha_1, alpha_2;
    double phi_alpha_0 = phi(x, alpha_0, dk);
    //printf("%lf",phi_alpha_0);
    double phi_alpha_1, phi_alpha_2;
    double lambda, mu, nu, sqrt_term;
    
    // First Armijo Condition Judgement
    if (phi_alpha_0 <= phi_0 + c * alpha_0 * derphi0) {
        return alpha_0;
    }
    
    // Quadratic interpolation computation
    alpha_1 = -(pow(alpha_0,2) * derphi0) /  (2.0 * (phi_alpha_0 - phi_0 - derphi0 * alpha_0));
    phi_alpha_1 = phi(x, alpha_1, dk);
    
    // Second Armijo Condition Judgement
    if (phi_alpha_1 <= phi_0 + c * alpha_1 * derphi0) {
        return alpha_1;
    }
    
    // Main loop
    int iter = 0;
    while (alpha_1 > alpha_min && iter < MAX_ITER) {
        // Cubic interpolation preparation
        lambda = pow(alpha_0,2) * pow(alpha_1,2) * (alpha_1 - alpha_0);
        mu = (alpha_0 * alpha_0) * (phi_alpha_1 - phi_0 - derphi0 * alpha_1) - (alpha_1 * alpha_1) * (phi_alpha_0 - phi_0 - derphi0 * alpha_0);
        mu = mu / lambda;
        nu = -(pow(alpha_0,3) * (phi_alpha_1 - phi_0 - derphi0 * alpha_1) + pow(alpha_1,3) * (phi_alpha_0 - phi_0 - derphi0 * alpha_0));
        nu = nu / lambda;

        // Cubic interpolation computation 
        sqrt_term = sqrt(nu * nu - 3 * mu * derphi0);
        alpha_2 = (-nu + sqrt_term) / (3 * mu);
        phi_alpha_2 = phi(x, alpha_2, dk);
        
        // Armijo Condition Judgement
        if (phi_alpha_2 <= phi_0 + c * alpha_2 * derphi0) {
            return alpha_2;
        }
        
        // Boundary check
        if (alpha_2 > rho_hi * alpha_1 || alpha_2 < rho_lo * alpha_1) {
            alpha_2 = alpha_1 / 2.0;
        }

        // Update variables for next iteration
        alpha_0 = alpha_1;
        alpha_1 = alpha_2;
        phi_alpha_0 = phi_alpha_1;
        phi_alpha_1 = phi_alpha_2;
        
        iter++;
    }
    
    return alpha_1;
}



