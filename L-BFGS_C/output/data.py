import pandas as pd
import os

# 获取当前文件夹路径
current_dir = os.getcwd()

# 存储所有txt文件内容的字典
data = {}

# 遍历当前文件夹下的所有文件
for filename in os.listdir(current_dir):
    if filename.endswith('.txt'):
        # 读取txt文件内容
        with open(os.path.join(current_dir, filename), 'r', encoding='utf-8') as file:
            lines = file.readlines()
            # 去掉每行末尾的换行符
            lines = [line.strip() for line in lines]
            # 将每个文件的内容存入字典
            data[filename] = lines

# 创建DataFrame并按列存储
df = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in data.items()]))

# 将DataFrame写入Excel文件
output_file = 'summary.xlsx'
df.to_excel(output_file, index=False)