import subprocess
import os
import shutil

exe_path = 'L-BFGS_C.exe'  
output_dir = './output'  
txt_dir = './txt'


os.makedirs(output_dir, exist_ok=True)
os.makedirs(txt_dir, exist_ok=True)


for i in range(330):  
    try:

        source_dir = f'./Dataset/{i}/'
        for file in os.listdir(source_dir):
            if file.endswith('.txt'):
                shutil.copy(os.path.join(source_dir, file), os.path.join(txt_dir, file))

       
        result = subprocess.run(exe_path, capture_output=True, text=True, check=True)

        
        output_file = os.path.join(output_dir, f'{i}.txt')

        
        with open(output_file, 'w') as f:
            f.write(result.stdout)  
            f.write(result.stderr)   
        print(f'Run {i} completed. Output saved to {output_file}.')

    except subprocess.CalledProcessError as e:
        print(f'An error occurred while running {exe_path}: {e}')



