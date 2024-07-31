# FPGA-Based Accelerator for the L-BFGS Algorithm in 3D Face Reconstruction

We utilize FPGAs to develop a high-throughput hardware accelerator of the Limited-Memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS) optimization algorithm used in FaceScape algorithm. The accelerator design mainly targets two general components: the Search Direction Unit (SDU) and the Line Search Unit (LSU), along with a dedicated hardware accelerator for the FaceScape Objective Function Unit (OFU). This repository includes a portion of the FACESCAPE project's code, replacing the SciPy library's L-BFGS optimizer. We have made minor modifications to the line searching conditions for faster convergence while maintaining accuracy and log runtime at each step, facilitating comparison of hardware acceleration across modules.

## Modifications

The modifications to the L-BFGS code focus on the line search conditions. By adjusting these conditions, we have achieved faster convergence in our benchmarks.

## Benchmarking

The software benchmark is based on the open-source [FaceScape face reconstruction project](https://github.com/zhuhao-nju/facescape.git) in Python code, running on an Intel i7-13700 @4.5GHz processor with a 64-bit operating system. For convenience, we have reproduced the packaged L-BFGS code from the SciPy library and made minor modifications to the line search conditions.

## Purpose of the Code

This code is specifically used to replace the bilinear model fitting stage in the original FaceScape project, where the L-BFGS algorithm implemented with SciPy is utilized. By opening up this algorithm, we can observe the computation time at each step, which allows for an easier comparison of software and hardware performance. Additionally, we have made minor modifications to the line searching conditions for faster convergence while maintaining accuracy.

## Usage

To use the modified L-BFGS optimizer in your project, you can clone this repository and import the necessary modules.

```bash
git clone https://github.com/Jerrypan29/L-BFGS.git


