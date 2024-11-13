import pandas as pd
import os


current_dir = os.getcwd()


data = {}


for filename in os.listdir(current_dir):
    if filename.endswith('.txt'):
     
        with open(os.path.join(current_dir, filename), 'r', encoding='utf-8') as file:
            lines = file.readlines()
            lines = [line.strip() for line in lines]
            data[filename] = lines

df = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in data.items()]))

output_file = 'summary.xlsx'
df.to_excel(output_file, index=False)