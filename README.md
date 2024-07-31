# FPGA-Based Accelerator for the L-BFGS Algorithm in 3D Face Reconstruction

We utilize FPGAs to develop a high-throughput hardware accelerator of the Limited-Memory Broyden-Fletcher-Goldfarb-Shanno (L-BFGS) optimization algorithm used in FaceScape algorithm. The accelerator design mainly targets two general components: the Search Direction Unit and the Line Search Unit, along with a dedicated hardware accelerator for the FaceScape Objective Function Unit. We have made minor adjustments to the line search conditions to enhance convergence speed while preserving accuracy. Additionally, we log the runtime at each step to facilitate the comparison of hardware acceleration across different modules.

## Benchmarking

Please note that the results were obtained using an Intel i7-13700 @4.5GHz processor with a 64-bit operating system. Performance may vary with different hardware setups, potentially yielding better or worse results. Therefore, the results should be used as a reference rather than an absolute measure.

## Purpose of the Code

This code replaces the L-BFGS algorithm in the bilinear model fitting stage of the original FaceScape project with a detailed step-by-step implementation. The original algorithm directly employed SciPy’s implementation. By exposing the inner workings of this algorithm, we can observe the computation time at each step, facilitating a more straightforward comparison of software and hardware performance. Additionally, we have made minor modifications to the line search conditions to achieve faster convergence while maintaining accuracy. 

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

## Bibtex

If you are interested in our work, please consider citing:

```
@inproceedings{xiong2023efficient,
title={Efficient {FPGA-Based} Accelerator of the {L-BFGS} Algorithm for {IoT} Applications},
author={Xiong, Huiyang and Xiong, Bohang and Wang, Wenhao and Tian, Jing and Zhu, Hao and Wang, Zhongfeng},
booktitle={2023 IEEE International Symposium on Circuits and Systems (ISCAS)},
pages={1--5},
year={2023},
organization={IEEE}
}
```

## Usage

To use the modified L-BFGS optimizer in your project, you can clone this repository and import the necessary modules.

```bash
git clone https://github.com/Jerrypan29/L-BFGS.git

