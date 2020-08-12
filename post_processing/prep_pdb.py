
# USAGE: python3 prep_pdb.py results.pdbqt output.pdb

import sys

results = sys.argv[1]
output = sys.argv[2]

line_list = []
with open(results,'r') as _file, open(output,'w') as _output:
    for line in _file:
        if line[:4] == 'ATOM' or line[:4] == 'MODE' or line[:6] == 'ENDMDL' or line[:11] == 'USER: SCORE':
            line_list.append(line)
    model_num = 0
    b_factor = 0.0
    occupancy = 0.0
    for line in line_list:
        if line[:4] == 'MODE' and model_num == 0:
            _output.write(line)
        elif line[:6] == 'ENDMDL':
            _output.write(line)
        elif line[:11] == 'USER: SCORE':
            b_factor = line.split()[-1]
        elif line[:4] == 'ATOM':
            occupancy = line.split('0.00 LIG')[1][:5]
            _output.write(line[:55]+'%5s'%(float(occupancy))+'%6.2f'%(float(b_factor))+'\n')

