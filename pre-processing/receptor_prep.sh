#!/bin/bash
#SBATCH -A bsd
#SBATCH -p batch
###SBATCH -p burst 
#SBATCH -t 12:00:00
#SBATCH --mem=0
#SBATCH -N 1
#SBATCH -n 32 
#SBATCH -c 1 
#SBATCH --mail-type=ALL
#SBATCH --mail-user=davidsonrb@ornl.gov
#SBATCH -J agfr_rbd
#SBATCH -o ./AAA.out
#SBATCH -e ./AAA.err

export OUTPUT_DIR="redoing_docking/AAA"
export SLURM_SUBMIT_DIR="/lustre/or-hydra/cades-bsd/davidsonrb"
export MGL_HOME="/home/davidsonrb/Apps/mgltools_x86_64Linux2_1.5.6/MGLToolsPckgs/AutoDockTools/Utilities24"
#export ADFR_HOME="/home/davidsonrb/Apps/ADFRsuite_x86_64Linux_1.0"
export ADFR_HOME="/home/davidsonrb/Apps/ADFRsuite_x86_64Linux_1.0/bin"

#source $ADFR_HOME/initADFRsuite.sh

# transfer over receptor trg file to lustre directory
mkdir -p $SLURM_SUBMIT_DIR/$OUTPUT_DIR

# move pdb file and leave to greener pastures
cp AAA.pdb $SLURM_SUBMIT_DIR/$OUTPUT_DIR
cd $SLURM_SUBMIT_DIR/$OUTPUT_DIR

sed -i "s/ T / A /g" AAA.pdb

# prepare pdbqt files from the pdb
/home/davidsonrb/Apps/mgltools_x86_64Linux2_1.5.6/bin/pythonsh $MGL_HOME/prepare_receptor4.py -A 'None' -U 'nphs_lps' -r AAA.pdb -o AAA.pdbqt # 'nphs_lps' -> remove nonpolar Hs, lone pairs, and merge charges

# create the .trg file to prepare for docking
# noncovalent docking
$ADFR_HOME/agfr -r AAA.pdbqt -o AAA_nc -b user 43.0 31.8 -2.7 30.0 30.0 30.0 -s 0.25 

# remove unwanted HG atom from active site CYS residue. 
#sed "/HG  CYS T 111/d" AAA.pdbqt > AAA_c.pdbqt
# covalent docking
$ADFR_HOME/agfr -r AAA.pdbqt -o AAA_c  -b user 43.0 31.8 -2.7 30.0 30.0 30.0 -s 0.25 -c 1091 1094 -t 1090 -x A:CYS111

