import os
import numpy as np

folder_path = '../result/BF/NWPU_RESISC45/Poisson1'
# folder_path = '../result/BF/test_summer/5'
csv_files = [f for f in os.listdir(folder_path) if f.endswith('.csv')]

mean_list = []
for file in csv_files:
    data = np.genfromtxt(os.path.join(folder_path, file), delimiter=',')
    mean_list.append(np.mean(data[:, 1]))

mean_of_second_column = sum(mean_list) / len(mean_list)
print(f'指定文件夹内所有 CSV 文件的第二列的均值为 {mean_of_second_column:.2f}')

