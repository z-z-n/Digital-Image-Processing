import os
import numpy as np


def calculate_column_means(csv_file):
    # 使用numpy加载CSV文件
    data = np.loadtxt(csv_file, delimiter=',', skiprows=1)

    # 计算第2-7列的每列平均值
    column_means = np.mean(data[:, 1:8], axis=0)
    return column_means


def process_folder(folder_path):
    # 获取文件夹下的所有CSV文件
    csv_files = [f.path for f in os.scandir(folder_path) if f.is_file() and f.name.endswith('.csv')]

    if csv_files:
        # 计算每个CSV文件的第2-7列每列平均值
        for i, csv_file in enumerate(csv_files):
            means = calculate_column_means(csv_file)

            # 输出每列平均值
            print(f"CSV file {i + 1} ({csv_file}): Column Means = {means}")


# 指定要处理的文件夹路径
folder_path = '../result/BF/cure_or/0result/2Decolorization'
# folder_path = '../result/CF/sidd/denoised'
# 处理文件夹
process_folder(folder_path)
