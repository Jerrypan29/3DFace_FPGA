import subprocess
import os
import shutil
# 设置 exe 文件的路径
exe_path = 'L-BFGS_C.exe'  # 替换为你的 exe 文件路径
output_dir = './output'  # 输出结果保存的目录
txt_dir = './txt'

# 确保输出目录存在
os.makedirs(output_dir, exist_ok=True)
os.makedirs(txt_dir, exist_ok=True)

# 循环运行 exe 文件
for i in range(330):  # 这里设置循环次数，可以根据需要调整
    try:

        source_dir = f'./Dataset/{i}/'
        for file in os.listdir(source_dir):
            if file.endswith('.txt'):
                shutil.copy(os.path.join(source_dir, file), os.path.join(txt_dir, file))

        # 运行 exe 文件并获取输出
        result = subprocess.run(exe_path, capture_output=True, text=True, check=True)

        # 设置输出文件名
        output_file = os.path.join(output_dir, f'{i}.txt')

        # 将输出结果写入文件
        with open(output_file, 'w') as f:
            f.write(result.stdout)  # 写入标准输出
            f.write(result.stderr)   # 写入标准错误（如果有的话）

        print(f'Run {i} completed. Output saved to {output_file}.')

    except subprocess.CalledProcessError as e:
        print(f'An error occurred while running {exe_path}: {e}')



