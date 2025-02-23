# FPGA-Based Accelerator for the L-BFGS Algorithm in 3D Face Reconstruction

We utilize FPGAs to develop a high-throughput hardware accelerator of the Limited-Memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS) optimization algorithm used in FaceScape algorithm. The accelerator design mainly targets two general components: a general-purpose L-BFGS computation module, primarily comprising the SDU and LSU, and a specialized Objective Function Unit (OFU) with a Gradient Calculation Unit (GCU) tailored for 3D face reconstruction. Additionally, we log the runtime at each step to facilitate the comparison of hardware acceleration across different modules.

## Benchmarking

We select 330 face images from the FaceScape dataset as the testing data for evaluation. Please note that the results were obtained using an Intel i7-12700 processor with a 64-bit operating system. Performance may vary with different hardware setups, potentially yielding better or worse results. Therefore, the results should be used as a reference rather than an absolute measure.

## Purpose of the Code

This code replaces the L-BFGS algorithm in the bilinear model fitting stage of the original FaceScape project with a detailed step-by-step implementation. The original algorithm directly employed SciPy’s implementation. By exposing the inner workings of this algorithm, we can observe the computation time at each step. Additionally, for a clearer comparison of software and hardware performance, we also implement the accelerated component of our hardware design in optimized C language and compile it using GCC.

## References

- Virtanen, P., et al. (2020). SciPy 1.0: Fundamental Algorithms for Scientific Computing in Python. Nature Methods, 17, 261-272. [doi:10.1038/s41592-019-0686-2](https://www.nature.com/articles/s41592-019-0686-2)
- Yang, H., Zhu, H., Wang, Y., Huang, M., Shen, Q., Yang, R., & Cao, X. (2020). Facescape: a large-scale high quality 3d face dataset and detailed riggable 3d face prediction. In Proceedings of the ieee/cvf conference on computer vision and pattern recognition (pp. 601-610).
- Zhu, H., Yang, H., Guo, L., Zhang, Y., Wang, Y., Huang, M., ... & Cao, X. (2023). Facescape: 3d facial dataset and benchmark for single-view 3d face reconstruction. IEEE transactions on pattern analysis and machine intelligence.
- [SciPy Library](https://www.scipy.org)
  
## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

Special thanks to the contributors of the [FaceScape project](https://github.com/zhuhao-nju/facescape.git) for their open-source code.

For any questions or contributions, please open an issue or submit a pull request.

## Usage

To use the modified L-BFGS optimizer in your project, you can clone this repository and import the necessary modules.

```bash
git clone https://github.com/Jerrypan29/L-BFGS.git
```

After cloning, locate the RTL files and IP cores in the repository, and then import them into Vivado.



