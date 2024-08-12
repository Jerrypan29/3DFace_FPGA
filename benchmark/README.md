# Using Git LFS for Large Files

## Overview

This project uses Git Large File Storage (LFS) to manage large files. If you see Git LFS file pointers instead of actual file content, you need to install and configure Git LFS to properly fetch these files.

## Installing Git LFS

1. **Install Git LFS**: Visit the [Git LFS official website](https://git-lfs.github.com/) and follow the instructions to install it.

2. **Initialize Git LFS**:
   Run the following command in your Git repository to initialize Git LFS:
   ```bash
   git lfs install
