import numpy as np

def quant_nd(x, num_bits=32, exp_bits=8, mant_bits=23, add_noise=True ):
    eps = float(1e-32)
    mid_exp = 2**(exp_bits-1)-1
    max_exp = 2**(exp_bits)-2 - mid_exp
    min_exp = 1 - mid_exp
    
    max_mant = (2**(mant_bits)-1)/(2**(mant_bits))
    int_mant = 2**mant_bits
    maxnorm = float(2**(max_exp)*(1+max_mant)) # ����񻯸�����
    minnorm = float(2**(min_exp))  # ��С��񻯸�����
    minsub  = float(2**(min_exp)*(2**(-mant_bits))) #
    #print(minsub)
    x = np.where(np.greater(np.abs(x),minsub),x,np.zeros_like(x))
    
    sign = np.sign(x)
    nzero = np.not_equal(x, 0.0).astype(np.float32)
    
    x = np.abs(x)
    x = np.clip(x,minsub, maxnorm)
    
    is_norm = np.greater(x, minnorm)
    
    e = np.floor(np.log2(x+eps))
    f = x/np.power(2, e) - (1.0)  # fraction part value, float, [1, 2)
    
    norm_x = np.power(2,e)*( np.round(f * int_mant)/int_mant + 1 )
    sub_x = np.round((x / 2**min_exp)*int_mant) / int_mant *(2**min_exp)
    
    output = np.where(is_norm, norm_x, sub_x)*sign*nzero

    return output

def quant(to_quant_arr,num_bit = 8 ,decimal_bit = 3,*args):
    """
    this is a quant function
    num_bit is the bitwidth of the whole number after_quant,
    decimal_bit is the bitwidth of decimal_part of the number
    args is the array to be quant, it can be a list
    """
    step_unit = pow(0.5,decimal_bit)
    #print(step_unit)
    out = list(to_quant_arr)
    for i in range(len(out)):
        if (out[i] >= pow(2, num_bit - 1 - decimal_bit)):
            out[i] = pow(2, num_bit - decimal_bit) - 1
            print("error, overflow, postive",out[i])
        elif(out[i] < -pow(2, num_bit - 1 - decimal_bit)):
            out[i] = - pow(2, num_bit - decimal_bit)
            print("error, overflow, negative",out[i])
        else:
            out[i] = step_unit * (round(out[i] / step_unit))       
    return out
if __name__ == "__main__":
    #torch.set_printoptions(precision=10)
    x = np.random.randn(3,3, requires_grad=True)
    
'''
from torch.autograd.function import InplaceFunction
import torch

class LowFloat(InplaceFunction):

    @staticmethod
    def forward(ctx, input, num_bits=8, exp_bits=5, mant_bits=2, add_noise=True):
        assert  num_bits == (exp_bits + mant_bits + 1)
        ctx.inplace = False
        if ctx.inplace:
            ctx.mark_dirty(input)
            x = input
        else:
            x = input.clone()

        with torch.no_grad():
            #print("hahahaha")
            
            eps = float(1e-32)
            mid_exp = 2**(exp_bits-1)-1
            max_exp = 2**(exp_bits)-2 - mid_exp
            min_exp = 1 - mid_exp

            max_mant = (2**(mant_bits)-1)/(2**(mant_bits))
            int_mant = 2**mant_bits
            maxnorm = float(2**(max_exp)*(1+max_mant))
            minnorm = float(2**(min_exp))
            minsub  = float(2**(min_exp)*(2**(-mant_bits)))

            x = torch.where(x.abs().ge(minsub), x, torch.zeros_like(x))
            # extract information
            sign = x.sign()
            nzero = torch.ne(x, 0.0).to(torch.float32)
            x.abs_()
            x.clamp_(minsub, maxnorm)

            is_norm = torch.ge(x, minnorm)

            e = torch.log2(x+eps).floor()
            f = x.div(torch.pow(2, e)).sub(1.0)

            if add_noise:
                noise = torch.rand_like(x)
                 # norm case
                norm_x = torch.pow(2, e).mul(
                    f.mul(int_mant).add(noise).floor().div(int_mant).add(1.0))

                # sub-normal case
                sub_x = x.div(2**min_exp).mul(int_mant).add(noise).floor().div(int_mant).mul(2**min_exp)
            else : 
                # norm case
                norm_x = torch.pow(2, e).mul(
                    f.mul(int_mant).round().div(int_mant).add(1.0))

                # sub-normal case
                sub_x = x.div(2**min_exp).mul(int_mant).round().div(int_mant).mul(2**min_exp)

            output = torch.where(is_norm, norm_x, sub_x)*sign*nzero
        return output

    @staticmethod
    def backward(ctx, grad_output):
        grad_input = grad_output
        return grad_input, None, None, None, None

def quant(x, num_bits=16, exp_bits=8, mant_bits=7, add_noise=False ):
    x = torch.from_numpy(x)
    return LowFloat().apply(x, num_bits, exp_bits, mant_bits, add_noise)

def quant_nd(x , num_bits=16, exp_bits=8, mant_bits=7, add_noise=False ):
    #print(type(x))
    x = torch.from_numpy(x)
    out = LowFloat().apply(x, num_bits, exp_bits, mant_bits, add_noise)   
    return out.detach().numpy()

def quant_f(x, num_bits=16, exp_bits=8, mant_bits=7, add_noise=False ):
    #print(type(x))
    x = torch.tensor(x)
    out = LowFloat().apply(x, num_bits, exp_bits, mant_bits, add_noise)   
    return out.detach().numpy()

if __name__ == "__main__":
    #torch.set_printoptions(precision=10)
    x = torch.randn(3,3, requires_grad=True)
    x_nd = np.random.randn(3,3)
    #print(x_nd)
    #print(quant_nd(x_nd))
    #print((quant_f(6556656.)))
    #print((quant_f(-655665436.)))
    #print(x.grad)

'''

