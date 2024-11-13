# -*- coding: utf-8 -*-
"""
Spyder 编辑器

这是一个临时脚本文件。
"""
import numpy as np
import random
from functools import partial
from decimal import Decimal

def Trans2bin (a,bw=16):
    '''
    把一个十进制数据a转化为二进制的补码b，固定位宽为bw
    可以修改想要得到的结果的位宽bw
    '''
    int_number1 = int(a)
    int_number2 = bin(2**bw+(int_number1)).replace('0b','')
    # print(len(int_number2))
    if (len(int_number2)>bw) :
        int_number2 = int_number2[1:bw+1] #截取第一位到第bw+1位的数据（把溢出的数据截至掉）
    else :
        int_number2 = int_number2
    return(int_number2) #返回的是字符串类型

def flatten(x):
    """
    

    Parameters
    ----------
    x : ndarray
        数据展平和恢复

    Returns
    -------
    TYPE
        DESCRIPTION.

    """
    original_shape = x.shape
    return x.flatten(), partial(np.reshape, newshape=original_shape)

a = np.random.random((2,3,4))
a_, unflatten = flatten(a)
#print(a - unflatten(a))

class Quantizer:
    def __init__(self, arr=None, Nlevels = 256,scale = 1e-20,veri = True,*args):
        
        #self.quant_array, self.unflatten = flatten(arr)
        self.arr = arr
        
        self.scale = scale
        self.Nlevels = Nlevels
        
        
        self.max =  float('inf')
        self.min =  -float('inf')
        
        #self.Nlevels = 256
        self.ze_p = 0 # type:int
    
    def initial_array(self,arr):
        self.arr = arr
        self.arr_mean = np.mean(arr)
        self.arr_std = np.std(arr)
        
    def append_array(self,arr1):
        self.arr = np.append(self.arr,arr1)
        self.arr_mean = np.mean(self.arr)
        self.arr_std = np.std(self.arr)        
        
    def _set_max_min(self,principle,*args):
        """

        Parameters
        ----------
        principle :  == 0 
            max_min
        principle == 1
            3sigma princile
        principle == 2
            need to be setted handed
        else
            pass
        
        Quantizer._set_max_min(2,3,8)

        Returns
        -------
        None.

        """
        
        if principle == 0:
            self.max = np.max(self.arr)
            self.min = np.min(self.arr)
        elif principle == 1:
            self.max = self.arr_mean + 3 * self.arr_std
            self.min = self.arr_mean - 3 * self.arr_std
        elif principle == 2:
            print(type(args),args)
            if args:    
                self.min,self.max = args
            else:
                print("error")
        else:
            pass
        
    @ staticmethod
    def clamp(x,a,b):
        """
        a is upper bound
        b is lower bound
        x,a,b can only be a yuansu
        """
        if x <= a:
            return a
        elif x >= b:
            return b
        else:
            return x
        
    def uniform_affine_quant(self, x):
        """

        Parameters
        ----------
        x : TYPE float
            DESCRIPTION.
            return the quantization of x

        Returns
        -------
        None.

        """
        x_int = np.round(x/self.scale) + self.ze_p
        x_quant = np.clip(x_int, 0, self.Nlevels - 1)  # 截断函数 np.clip
        
        return x_quant
    
    def uniform_affine_dequant(self, x_quant):
        """
        

        Parameters
        ----------
        x : TYPE int
            DESCRIPTION.

        Returns
        -------
        None.

        """
        x_float = (x_quant - self.ze_p) * self.scale
        return x_float
    
    
    def uniform_symmetric_quant(self, x, signed=True):
        """

        Parameters
        ----------
        x : TYPE
            DESCRIPTION.
        signed : TYPE, optional
            DESCRIPTION. The default is True.

        Returns
        -------
        None.

        """
        x_int = np.round(x/self.scale)
        if signed:
            x_quant = np.clip(x_int, -self.Nlevels/2,self.Nlevels/2-1)
            return x_quant
        else:
            x_quant = np.clip(x_int,0,self.Nlevels-1)
            return x_quant
    
    def restric_symmetric_quant(self, x, signed = True):
        """
        

        Parameters
        ----------
        x_quant : TYPE
            DESCRIPTION.
        signed : TYPE, optional
            DESCRIPTION. The default is True.

        Returns
        -------
        x_Q : TYPE
            DESCRIPTION.

        """
        
        x_int = round(x/self.scale)
        if signed:
            x_Q = np.clip(x_int,-(self.N_levels/2 - 1), self.N_levels/2 - 1)
            return x_Q
        else:
            x_Q = np.clip(x_int, 0, self.N_levels-2)
            
    def uniform_symmetric_dequant(self,x_quant, signed=True):
        """
        

        Parameters
        ----------
        x : TYPE
            DESCRIPTION.
        signed : TYPE, optional
            DESCRIPTION. The default is True.

        Returns
        -------
        None.

        """
        x_out = x_quant * self.scale
        return x_out
    
    def stochastic_quant(self,x):
        epsilon = random.uniform(-1/2,1/2)
        x_int = round((x + epsilon)/self.scale) + self.ze_p
        x_quant = self.clamp(x_int, 0, self.N_levels - 1)
        return x_quant
    
    def mquant(self,num_bit):
        self._set_max_min(0) # using 3sigama principle to determine max and min
        self.Nlevels = 2 ** num_bit
        
        self.scale = (self.max - self.min )/ self.Nlevels
        self.ze_p = - int(round(self.min/self.scale))
        
        #print(self.min,self.max,self.ze_p)
        
        return self.uniform_affine_quant(self.arr)
    def mdequant(self,q_arr):
        return self.scale * (q_arr - self.ze_p)
    
    def m_uni_quant(self,num_bit):
        self._set_max_min(1) #using 3sigama principle to determine max and min 
        self.Nlevels = 2 ** num_bit
        self.scale = max(abs(self.min),abs(self.max)) /(self.Nlevels/2)
        
        return self.uniform_symmetric_quant(self.arr)
    def m_uni_dequant(self,q_arr):
        return self.scale * q_arr

    def method_quant(self,num_bit):
        self._set_max_min(1) #using 3sigama principle to determine max and min 
        self.Nlevels = 2 ** num_bit
        self.scale = max(abs(self.min),abs(self.max)) /(self.Nlevels/2)
        self.arr = self.uniform_symmetric_quant(self.arr)
        #print(self.arr)
        return self
    def method_dequant(self):
        self.arr = self.scale * self.arr
        #print(self.arr)
        return self.arr

    @staticmethod
    def quant(to_quant_arr,num_bit = 32 ,decimal_bit = 14,*args):
        """
        this is a quant function
        num_bit is the bitwidth of the whole number after_quant,
        decimal_bit is the bitwidth of decimal_part of the number
        args is the array to be quant, it can be a list
        """
        step_unit = pow(0.5,decimal_bit)
        #print(step_unit)

        out = []
        out.append(to_quant_arr)
        for i in range(len(out)):
            if (out[i] >= pow(2, num_bit - 1 - decimal_bit)):
                out[i] = pow(2, num_bit - decimal_bit) - 1
                #out[i] = out[i] * step_unit
                print("error, overflow, postive",out[i])
            elif(out[i] < -pow(2, num_bit - 1 - decimal_bit)):
                out[i] = - pow(2, num_bit - decimal_bit)
                #out[i] = out[i] * step_unit
                print("error, overflow, negative",out[i])
            else:
                out[i] = step_unit * (np.round(out[i] / step_unit))
                #print(out[i])
            # print(out[i])
        #for item in out:
            #print(item)
            
        return out[0]
    @staticmethod  
    def Qua(to_quant_arr,num_bit = 32 ,decimal_bit = 18,*args):
        """
        this is a quant function
        num_bit is the bitwidth of the whole number after_quant,
        decimal_bit is the bitwidth of decimal_part of the number
        args is the array to be quant, it can be a list
        """
        step_unit = pow(0.5,decimal_bit)
        to_quant_arr[to_quant_arr >= pow(2, num_bit - 1 - decimal_bit)] =  (pow(2, num_bit - decimal_bit) - 1)  
        to_quant_arr[to_quant_arr < -pow(2, num_bit - 1 - decimal_bit)] =  (- pow(2, num_bit - decimal_bit))
        to_quant_arr = step_unit * np.round(to_quant_arr/step_unit)
        return to_quant_arr

    def print_(self):
        print('quant')


class Quant:
    def __init__(self, arr=None, Nlevels = 256,scale = 2**-10,veri = True,*args):
        
        #self.quant_array, self.unflatten = flatten(arr)
        self.arr = arr
        
        self.scale = scale
        self.Nlevels = Nlevels
        
        
        self.max =  float('inf')
        self.min =  -float('inf')

        self.ze_p = 0 # type:int
    
    def initial_array(self,arr):
        self.arr = arr
        self.arr_mean = np.mean(arr)
        self.arr_std = np.std(arr)
        
    def append_array(self,arr1):
        self.arr = np.append(self.arr,arr1)
        self.arr_mean = np.mean(self.arr)
        self.arr_std = np.std(self.arr)        
        
    def _set_max_min(self,principle,*args):
        """

        Parameters
        ----------
        principle :  == 0 
            max_min
        principle == 1
            3sigma princile
        principle == 2
            need to be setted handed
        else
            pass
        """
        
        if principle == 0:
            self.max = np.max(self.arr)
            self.min = np.min(self.arr)
        elif principle == 1:
            self.max = self.arr_mean + 3 * self.arr_std
            self.min = self.arr_mean - 3 * self.arr_std
        elif principle == 2:
            print(type(args),args)
            if args:    
                self.min,self.max = args
            else:
                print("error")
        else:
            pass
        
    def uniform_affine_quant(self, x):
        x_int = np.round(x/self.scale) + self.ze_p
        x_quant = np.clip(x_int, 0, self.Nlevels - 1)  # 截断函数 np.clip
        return x_quant
    
    def uniform_affine_dequant(self, x_quant):
        x_float = (x_quant - self.ze_p) * self.scale
        return x_float
    

    def uniform_symmetric_quant(self, x, signed=True):
        x_int = np.round(x/self.scale)
        if signed:
            x_quant = np.clip(x_int, -self.Nlevels/2,self.Nlevels/2-1)
            return x_quant
        else:
            x_quant = np.clip(x_int,0,self.Nlevels-1)
            return x_quant

    def uniform_symmetric_dequant(self,x_quant, signed=True):
        x_out = x_quant * self.scale
        return x_out


    def method_quant(self,num_bit):
        self._set_max_min(1) #using 3sigama principle to determine max and min 
        self.Nlevels = 2 ** num_bit
        self.scale = max(abs(self.min),abs(self.max)) /(self.Nlevels/2)
        self.arr = self.uniform_symmetric_quant(self.arr)
        #print(self.arr)
        return self
    def method_dequant(self):
        self.arr = self.scale * self.arr
        #print(self.arr)
        return self.arr

    @staticmethod
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

    
    def print_(self):
        print(self.arr)

if __name__ == "__main__":
    
    # double_array = 2 + 15 * np.random.randdom((10,10,10))  产生0-1 均匀分布
    double_array = 15 * np.random.randn(1000,1000,10)  #  randn generate a gauss distribution, double_array ~ N(2,128^2)
    
    A = Quantizer()
    A.initial_array(double_array)
    #out = A.quant(num_bit = 8, decimal_bit = 3)
    out = A.mquant(16)
    out_f = A.mdequant(out)
    print(out)
    
    print(np.mean(out)/np.max(out))
    print('非对称量化误差为',np.sum(np.abs(out_f - double_array))/np.sum(np.abs(double_array)))
    
    out = A.m_uni_quant(16)
    out_f = A.m_uni_dequant(out)
    #print(out_f-double_array)
    #print(np.mean(out)/np.max(out))
    print('对称量化误差为',np.sum(np.abs(out_f - double_array))/np.sum(np.abs(double_array)))
      
    
    
    #cQuantizer.clamp(2.3,2,4)  # verify that Quantizer is a staticmethod
    #print("haha")
    for item in out:
        pass
        #print(item,' ')
    
        
    
