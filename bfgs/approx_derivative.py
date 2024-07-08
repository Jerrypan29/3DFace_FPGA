import numpy as np
def _eps_for_method(x0_dtype, f0_dtype, method):
    EPS = np.finfo(np.float64).eps
    #EPS = np.finfo(np.float32).eps


    x0_is_fp = False
    if np.issubdtype(x0_dtype, np.inexact):
        # if you're a floating point type then over-ride the default EPS
        EPS = np.finfo(x0_dtype).eps
        x0_itemsize = np.dtype(x0_dtype).itemsize
        x0_is_fp = True

    if np.issubdtype(f0_dtype, np.inexact):
        f0_itemsize = np.dtype(f0_dtype).itemsize
        # choose the smallest itemsize between x0 and f0
        if x0_is_fp and f0_itemsize < x0_itemsize:
            EPS = np.finfo(f0_dtype).eps

    if method in ["2-point", "cs"]:
        return EPS**0.5
    elif method in ["3-point"]:
        return EPS**(1/3)
    else:
        raise RuntimeError("Unknown step method, should be one of "
                           "{'2-point', '3-point', 'cs'}")


def _compute_absolute_step(rel_step, x0, f0, method):
    sign_x0 = (x0 >= 0).astype(float) * 2 - 1
    rstep = _eps_for_method(x0.dtype, f0.dtype, method)
    if rel_step is None:
        abs_step = rstep * sign_x0 * np.maximum(1.0, np.abs(x0))
    else:
        abs_step = rel_step * sign_x0 * np.abs(x0)
        dx = ((x0 + abs_step) - x0)
        abs_step = np.where(dx == 0,
                            rstep * sign_x0 * np.maximum(1.0, np.abs(x0)),
                            abs_step)

    return abs_step


def _dense_difference(fun, x0, f0, h, method):
    m = f0.size
    n = x0.size
    J_transposed = np.empty((n, m))
    h_vecs = np.diag(h)

    for i in range(h.size):
        if method == '2-point':
            x = x0 + h_vecs[i]
            dx = x[i] - x0[i]  # Recompute dx as exactly representable number.
            df = fun(x) - f0

        elif method == '3-point':
            x1 = x0 - h_vecs[i]
            x2 = x0 + h_vecs[i]
            dx = x2[i] - x1[i]
            f1 = fun(x1)
            f2 = fun(x2)
            df = f2 - f1

            '''print("f1:")
            print(f1)
            print("f2:")
            print(f2) '''
         

        elif method == 'cs':
            f1 = fun(x0 + h_vecs[i]*1.j)
            df = f1.imag
            dx = h_vecs[i, i]
        else:
            raise RuntimeError("Never be here.")

        J_transposed[i] = df / dx

    if m == 1:
        J_transposed = np.ravel(J_transposed)

    return J_transposed.T

def approx_derivative(fun,x0,method='3-point',f0=None,rel_step=None,abs_step=None,args=()):
    def fun_wrapped(x):
        return fun(x,*args)
    if f0 is None:
        f0 = fun_wrapped(x0)
    if abs_step is None:
        h=_compute_absolute_step(rel_step, x0, f0, method)
        #print("步长:")
        #print(h)

    else:
        sign_x0 = (x0 >= 0).astype(float) * 2 - 1
        h = abs_step
        
        dx = ((x0 + h) - x0)
        h = np.where(dx == 0,
                     _eps_for_method(x0.dtype, f0.dtype, method) *
                     sign_x0 * np.maximum(1.0, np.abs(x0)),
                     h)
        #print("步长:")
        #print(h)
    return _dense_difference(fun_wrapped, x0, f0, h,
                                     method)
