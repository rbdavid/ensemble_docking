
# ----------------------------------------
# PREAMBLE:
# ----------------------------------------

import sys
import glob
import os
import importlib
import numpy as np
import MDAnalysis
from IO import *

# ----------------------------------------
# VARIABLE DECLARATION: 
# ----------------------------------------

config_file = sys.argv[1]
IO_functions_file = sys.argv[2]

config_parser = importlib.import_module(IO_functions_file.split('.py')[0],package=None).config_parser
summary = importlib.import_module(IO_functions_file.split('.py')[0],package=None).summary

# ----------------------------------------
# FUNCTIONS: 
# ----------------------------------------

def main():
    # ----------------------------------------
    # FILE NAMING VARIABLES
    # ----------------------------------------
    summary_file_name = parameters['output_directory'] + 'summary.txt'
    dx_file_name = parameters['output_directory'] + parameters['dx_output_file_name']
    pdb_list = glob.glob(parameters['pdb_string'])

    # ----------------------------------------
    # LOAD IN THE STRUCTURES TO BE ANALYZED 
    # ----------------------------------------
    positions = np.array([[0.,0.,0.]])

    for pdb in pdb_list:
        u = MDAnalysis.Universe(pdb)
        selection = u.select_atoms(parameters['selection'])
        for ts in u.trajectory:
            positions = np.append(positions,selection.positions,axis=0)
    
    # ----------------------------------------
    # ANALYZE POSITION DATA AND CREATE DX FILES
    # ----------------------------------------
    half_max_counts = create_dx(positions[1:],float(parameters['dx_delta']),dx_file_name)
    
    # ----------------------------------------
    # OUTPUTTING SUMMARY INFORMATION
    # ----------------------------------------
    if parameters['summary_boolean']:
        summary(summary_file_name,sys.argv,parameters)

# ----------------------------------------
# CREATING PARAMETER DICTIONARY
# ----------------------------------------
parameters = {}
config_parser(config_file,parameters)

# ----------------------------------------
# LOADING IN NECESSARY FUNCTIONS FROM MODULE FILES
# ----------------------------------------

create_dx = importlib.import_module(parameters['visualization_functions_file'].split('.')[0],package=None).create_dx

# ----------------------------------------
# MAIN
# ----------------------------------------
if parameters['output_directory'][-1] != os.sep:
    parameters['output_directory'] += os.sep

if os.path.exists(parameters['output_directory']):
    print('The output directory, ', parameters['output_directory'], 'already exists. Please select a different directory name for output.')
    sys.exit()
else:
    os.mkdir(parameters['output_directory'])

# ----------------------------------------
# MAIN
# ----------------------------------------
if __name__ == '__main__':
    main()

