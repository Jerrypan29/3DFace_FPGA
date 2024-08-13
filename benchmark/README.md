# Benchmark for SVFR Methods

This benchmark focuses on the software execution of each step in the algorithm. By documenting the computation time at every stage, it provides a reference point for calculating the speedup that could be achieved with hardware acceleration.

## Steps to Run the Benchmark

### 1. Set Up the Environment

The code is tested on CentOS 7 with Python 3. To ensure a consistent environment, it is recommended to use Anaconda to create a virtual environment.

#### Steps to Set Up the Environment:

1. **Create a New Conda Environment**:
   - Open a terminal and create a new Conda environment with Python 3:
     ```bash
     conda create --name svfr_benchmark python=3.8
     ```
   - Activate the environment:
     ```bash
     conda activate svfr_benchmark
     ```

2. **Install Required Libraries**:
   - Install the necessary Python libraries from the `requirements.txt` file:
     ```bash
     pip install -r requirements.txt
     ```

### 2. Download Bilinear Model

#### Using Git LFS for Large Files

The `bilinear_model_v1.6` folder contains large model files managed using Git Large File Storage (LFS). These files are stored as pointers in the Git repository, and you'll need Git LFS installed to access the actual files.

##### Installing Git LFS
1. **Install Git LFS**: Visit the [Git LFS official website](https://git-lfs.github.com/) and follow the instructions to install it.

2. **Initialize Git LFS**:  
   Run the following command in your Git repository to initialize Git LFS:
   ```bash
   git lfs install
   
3. **Pull LFS Files**:
   ```bash
   git lfs pull
   
#### Download and Replace Models

If you encounter issues with Git LFS or prefer to manually replace the model files, you can download the models from the following links and replace them in the `bilinear_model_v1.6` folder:

- **[Google Drive](https://drive.google.com/drive/folders/1nI5rI2lxSdJ4jv3o3026GWmZcbtf6OSc)**: Download the required model files from this link.
- **[NJU Box](https://box.nju.edu.cn/d/b8ca3f2d4a95437993f5/)**: Download the required model files from this link.

After downloading the models, follow these steps to replace the files:

1. Extract the downloaded model files.
2. Copy the extracted files into the `bilinear_model_v1.6` folder, overwriting the existing model files.
3. Ensure that the model file names match the original files to avoid any path or file name mismatches.

### 3. Run the Benchmark

To evaluate the performance of the software implementation, follow these steps:

**Execute the Benchmark Script**:
   - Run the `test_demo.py` script to start the benchmark. This script will execute the algorithm and record the computation time for each step.
     ```bash
     python test_demo.py
     ```
   - As the script runs, it will output the time taken for each major step in the algorithm, providing detailed insights into the performance of each component.

 **Visualize the Results**:

To gain a better understanding of how well the model performs, use the provided Jupyter notebook to visualize the results:

1. **Open the Visualization Notebook**:
   - Launch Jupyter Notebook in your environment:
     ```bash
     jupyter notebook
     ```
   - Open the `test_demo.ipynb` notebook from the Jupyter interface.

2. **Run the Visualization Cells**:
   - Execute the cells in the notebook to generate plots and visualizations that illustrate the model fitting effect.
   - These visualizations will help in assessing the accuracy and performance of the model, allowing for a more intuitive comparison between different methods.


