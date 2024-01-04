import matplotlib.pyplot as plt

levels = ['Level1', 'Level2', 'Level3', 'Level4', 'Level5']

psnr_values = [29.69, 26.7, 24.2, 22.2, 21.2]
ssim_values = [0.88, 0.88, 0.88, 0.88, 0.88]
cw_ssim_values = [0.91, 0.91, 0.91, 0.91, 0.91]
unique_values = [0.69, 0.61, 0.49, 0.32, 0.23]
ms_unique_values = [0.81, 0.77, 0.71, 0.63, 0.58]
csv_values = [0.97, 0.97, 0.97, 0.96, 0.96]
summer_values = [4.48, 4.46, 4.4, 4.38, 4.33]

fig, ax1 = plt.subplots(figsize=(10, 6))

# Left y-axis (for PSNR)
ax1.set_xlabel('Levels', fontsize=10)
ax1.set_ylabel('PSNR', color='tab:blue', fontsize=14)
ax1.plot(levels, psnr_values, marker='o', color='tab:blue', label='PSNR')
ax1.tick_params(axis='y', labelcolor='tab:blue', labelsize=12)
ax1.set_ylim(20, 30)  # Set the left y-axis range

# Right y-axis (for other metrics)
ax2 = ax1.twinx()
ax2.set_ylabel('SSIM, CW-SSIM, UNIQUE, MS-UNIQUE, CSV, SUMMER', color='tab:red', fontsize=14)
ax2.plot(levels, ssim_values, marker='o', color='tab:orange', label='SSIM')
ax2.plot(levels, cw_ssim_values, marker='o', color='tab:green', label='CW-SSIM')
ax2.plot(levels, unique_values, marker='o', color='tab:red', label='UNIQUE')
ax2.plot(levels, ms_unique_values, marker='o', color='tab:purple', label='MS-UNIQUE')
ax2.plot(levels, csv_values, marker='o', color='tab:brown', label='CSV')
ax2.plot(levels, summer_values, marker='o', color='tab:pink', label='SUMMER')
ax2.tick_params(axis='y', labelcolor='tab:red', labelsize=12)
ax2.set_ylim(0, 1)  # Set the right y-axis range

fig.tight_layout()
plt.title('Metrics vs. Levels of Decolorization in CURE-TSR', fontsize=16)
plt.grid(True)
plt.show()
