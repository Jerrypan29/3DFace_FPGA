# Using Git LFS for Large Files

The `bilinear_model_v1.6` folder contains large model files that are managed using Git Large File Storage (LFS). Due to their size, these files are not stored directly in the Git repository but are instead replaced with pointers. To access the actual files, you need to have Git LFS installed and properly configured.

## Installing Git LFS

1. **Install Git LFS**: Visit the [Git LFS official website](https://git-lfs.github.com/) and follow the instructions to install it.

2. **Initialize Git LFS**:
   
   Run the following command in your Git repository to initialize Git LFS:
   ```bash
   git lfs install
   
4. **Pull LFS Files**:
   
   ```bash
   git lfs pull

# Download and Replace Models

If you encounter issues with Git LFS or prefer to manually replace the model files, you can download the models from the following links and replace them in the `bilinear_model_v1.6` folder:

- **[Google Drive](https://drive.google.com/drive/folders/1nI5rI2lxSdJ4jv3o3026GWmZcbtf6OSc)**: Download the required model files from this link.
- **[NJU Box](https://box.nju.edu.cn/d/b8ca3f2d4a95437993f5/)**: Download the required model files from this link.

After downloading the models, follow these steps to replace the files:

1. Extract the downloaded model files.
2. Copy the extracted files into the `bilinear_model_v1.6` folder, overwriting the existing model files.
3. Ensure that the model file names match the original files to avoid any path or file name mismatches.
