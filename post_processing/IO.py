
# ----------------------------------------
# PREAMBLE:
# ----------------------------------------

import importlib
import MDAnalysis
import sys

# ----------------------------------------
# FUNCTIONS: 
# ----------------------------------------
def config_parser(config_file,parameters):	# Function to take config file and create/fill the parameter dictionary 
    """ Function to take config file and create/fill the parameter dictionary (created before function call). 
    
    Usage: 
        parameters = {}     # initialize the dictionary to be filled with keys and values
        config_parser(config_file,parameters)
    
    Arguments:
        config_file: string object that corresponds to the local or global position of the config file to be used for this analysis.
    
    """
    necessary_parameters = ['output_directory','visualization_functions_file','pdb_string','selection','dx_output_file_name']

    all_parameters = ['output_directory','visualization_functions_file','pdb_string','selection','dx_output_file_name','summary_boolean','dx_delta']

    for i in range(len(necessary_parameters)):
        parameters[necessary_parameters[i]] = ''

    # SETTING DEFAULT PARAMETERS FOR OPTIONAL PARAMETERS:
    parameters['summary_boolean'] = False 
    parameters['dx_delta'] = 1.0

    # GRABBING PARAMETER VALUES FROM THE CONFIG FILE:
    with open(config_file) as f:
        exec(compile(f.read(),config_file,'exec'),parameters)

    for key, value in list(parameters.items()):
        if value == '':
            print('%s has not been assigned a value. This variable is necessary for the script to run. Please declare this variable within the config file.' %(key))
            sys.exit()

def summary(summary_file_name,arguments,parameters):
    """ Function to create a text file that holds important information about the analysis that was just performed. Outputs the version of MDAnalysis, how to rerun the analysis, and the parameters used in the analysis.
    
    Usage:
        summary(summary_file_name,arguments,parameters)
    
    Arguments:
        summary_file_name: string object of the file name to be written that holds the summary information.
    
    """
    with open(summary_file_name,'w') as f:
        f.write('Using MDAnalysis version: %s\n' %(MDAnalysis.version.__version__))
        f.write('To recreate this analysis, run this line:\n')
        for i in range(len(arguments)):
            f.write('%s ' %(arguments[i]))
        f.write('\n\n')
        f.write('Parameters used:\n')
        for key, value in list(parameters.items()):
            if key == '__builtins__':
                continue
            if type(value) == int or type(value) == float:
                f.write("%s = %s\n" %(key,value))
            else:
                f.write("%s = '%s'\n" %(key,value))
        
