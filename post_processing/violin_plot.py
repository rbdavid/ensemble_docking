
# USAGE: python3 location/of/data_files.dat location/to/write/out/to/root

import matplotlib.pyplot as plt
import numpy as np
import sys
import glob

data_files = sorted(glob.glob(sys.argv[1]))
output_file_root = sys.argv[2]

#print(data_files)

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

#print(data_labels,len(data_list),len(data_list[0]))

feb_data = []
for i in range(len(data_list)):
    data_list[i] = sorted(data_list[i],key=lambda x: x[0])
    temp = []
    with open(output_file_root+'_%s.ranked'%(data_labels[i]),'w') as W:
        for data in data_list[i]:
            temp.append(data[0])
            W.write('%f  %s\n'%(data[0],data[1])) 
    feb_data.append(np.array(temp))

#print(feb_data)

top_dockers = np.array([data[0] for data in feb_data])
#print(top_dockers)
sorted_indices = np.argsort(top_dockers)
#print(sorted_indices)

sorted_feb_data = []
sorted_data_labels = []
for i in sorted_indices:
    sorted_feb_data.append(feb_data[i])
    sorted_data_labels.append(data_labels[i])

#print(len(sorted_feb_data))

if len(feb_data) > 10:
    fig, ax = plt.subplots()
    ax.set_title('%s'%(output_file_root.split('/')[0]))
    ax.set_ylabel('FEB')
    ax.set_xlabel('Ligands')
    ax.violinplot(sorted_feb_data[:10],showmeans=True)
    
    ax.get_xaxis().set_tick_params(direction='out')
    ax.xaxis.set_ticks_position('bottom')
    ax.set_xticks(np.arange(1, len(data_labels) + 1))
    ax.set_xticklabels(sorted_data_labels[:10])
    ax.set_xlim(0.25, len(sorted_data_labels[:10]) + 0.75)
    
    fig.savefig(output_file_root+'.png',dpi=600,transparent=True)
else:
    fig, ax = plt.subplots()
    ax.set_title('%s'%(output_file_root.split('/')[0]))
    ax.set_ylabel('FEB')
    ax.set_xlabel('Ligands')
    ax.violinplot(sorted_feb_data,showmeans=True)
    
    ax.get_xaxis().set_tick_params(direction='out')
    ax.xaxis.set_ticks_position('bottom')
    ax.set_xticks(np.arange(1, len(sorted_data_labels) + 1))
    ax.set_xticklabels(sorted_data_labels)
    ax.set_xlim(0.25, len(sorted_data_labels) + 0.75)
    
    fig.savefig(output_file_root+'.png',dpi=600,transparent=True)

