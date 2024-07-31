# FPGA-Based Accelerator for the L-BFGS Algorithm in 3D Face Reconstruction

We utilize FPGAs to develop a high-throughput hardware accelerator of the Limited-Memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS) optimization algorithm used in FaceScape algorithm. The accelerator design mainly targets two general components: the Search Direction Unit and the Line Search Unit, along with a dedicated hardware accelerator for the FaceScape Objective Function Unit. This repository includes a portion of the FaceScape project's code, replacing the SciPy library's L-BFGS optimizer. We have made minor modifications to the line searching conditions for faster convergence while maintaining accuracy and log runtime at each step, facilitating comparison of hardware acceleration across modules.

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

## References

- [SciPy Library](https://www.scipy.org)
- Virtanen, P., et al. (2020). SciPy 1.0: Fundamental Algorithms for Scientific Computing in Python. Nature Methods, 17, 261-272. [doi:10.1038/s41592-019-0686-2](https://www.nature.com/articles/s41592-019-0686-2)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to the contributors of the [FaceScape project](https://github.com/zhuhao-nju/facescape.git) for their open-source code.

For any questions or contributions, please open an issue or submit a pull request.



