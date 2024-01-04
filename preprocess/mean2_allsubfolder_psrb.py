import os
import numpy as np


def calculate_mean_of_second_column(csv_file):
    # 使用numpy读取CSV文件
    data = np.loadtxt(csv_file, delimiter=',', skiprows=1)

    # 计算第二列的均值
    mean_value = np.mean(data[:, 1])
    return mean_value


def process_folder(folder_path):
    # 获取文件夹下的所有子文件夹
    subfolders = [f.path for f in os.scandir(folder_path) if f.is_dir()]

    for subfolder in subfolders:
        print(f"Processing folder: {subfolder}")

        # 获取子文件夹下的所有CSV文件
        csv_files = [f.path for f in os.scandir(subfolder) if f.is_file() and f.name.endswith('.csv')]

        if csv_files:
            # 计算每个CSV文件的第二列均值
            means = [calculate_mean_of_second_column(csv_file) for csv_file in csv_files]

            # 输出均值
            t_sum = 0
            for i, mean_value in enumerate(means):
                print(f"  CSV file {i + 1}: Mean of second column = {mean_value}")
                t_sum+=mean_value
            print(f" Mean of second column = {t_sum/5}")

# 指定要处理的文件夹路径 TSR
folder_path = '../result/BF/cure_tsr/0result'
# folder_path = '../result/BF/test_summer'

# 处理文件夹
process_folder(folder_path)
