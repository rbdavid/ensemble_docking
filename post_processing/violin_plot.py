
# USAGE: python3 location/of/data_files.dat location/to/write/out/to/root

import matplotlib.pyplot as plt
import numpy as np
import sys
import glob

data_files = sorted(glob.glob(sys.argv[1]))
output_file_root = sys.argv[2]

data_list = []
data_labels = []
for f in data_files:
    data_labels.append(f.split('/')[-1].split('.')[0])
    lig_data = []
    string = ''
    with open(f,'r') as _file:
        for line in _file:
            if line[0] != '#':
                temp = line.split()
                lig_data.append([float(temp[-1]),string])
            else:
                string = line[2:-3]
    data_list.append(lig_data)

feb_data = []
for i in range(len(data_list)):
    data_list[i] = sorted(data_list[i],key=lambda x: x[0])
    temp = []
    with open(output_file_root+'.ranked','w') as W:
        for data in data_list[i]:
            temp.append(data[0])
            W.write('%f  %s\n'%(data[0],data[1])) 
    feb_data.append(np.array(temp))

fig, ax = plt.subplots()
ax.set_title('jmp molecules')
ax.set_ylabel('FEB')
ax.violinplot(feb_data,showmeans=True)

ax.get_xaxis().set_tick_params(direction='out')
ax.xaxis.set_ticks_position('bottom')
ax.set_xticks(np.arange(1, len(data_labels) + 1))
ax.set_xticklabels(data_labels)
ax.set_xlim(0.25, len(data_labels) + 0.75)
ax.set_xlabel('Sample name')

fig.savefig(output_file_root+'.png',dpi=600,transparent=True)

