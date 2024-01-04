import matplotlib.pyplot as plt

levels = ['Level1', 'Level2', 'Level3', 'Level4', 'Level5']

psnr_values = [29.69, 26.7, 24.2, 22.2, 21.2]
ssim_values = [0.88, 0.88, 0.88, 0.88, 0.88]
cw_ssim_values = [0.91, 0.91, 0.91, 0.91, 0.91]
unique_values = [0.69, 0.61, 0.49, 0.32, 0.23]
ms_unique_values = [0.81, 0.77, 0.71, 0.63, 0.58]
csv_values = [0.97, 0.97, 0.97, 0.96, 0.96]
summer_values = [4.48, 4.46, 4.4, 4.38, 4.33]

plt.figure(figsize=(10, 6))

plt.plot(levels, psnr_values, marker='o', label='PSNR')
plt.plot(levels, ssim_values, marker='o', label='SSIM')
plt.plot(levels, cw_ssim_values, marker='o', label='CW-SSIM')
plt.plot(levels, unique_values, marker='o', label='UNIQUE')
plt.plot(levels, ms_unique_values, marker='o', label='MS-UNIQUE')
plt.plot(levels, csv_values, marker='o', label='CSV')
plt.plot(levels, summer_values, marker='o', label='SUMMER')

plt.xlabel('Levels')
plt.ylabel('Values')
plt.title('Metrics vs. Levels')
plt.legend()
plt.grid(True)
plt.show()
