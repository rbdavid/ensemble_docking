#!/bin/bash
#SBATCH -A bsd
#SBATCH -p batch
###SBATCH -p burst 
#SBATCH -t 24:00:00
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
export ADFR_HOME="/home/davidsonrb/Apps/ADFRsuite_x86_64Linux_1.0/bin"
export LIGAND_HOME="/lustre/or-hydra/cades-bsd/davidsonrb/Ligand_Home"

## transfer over receptor trg file to lustre directory
#mkdir -p $SLURM_SUBMIT_DIR/$OUTPUT_DIR
#
## move pdb file and leave to greener pastures
#cp AAA.pdb $SLURM_SUBMIT_DIR/$OUTPUT_DIR
#cd $SLURM_SUBMIT_DIR/$OUTPUT_DIR
#
## prepare pdbqt files from the pdb
#/home/davidsonrb/Apps/mgltools_x86_64Linux2_1.5.6/bin/pythonsh $MGL_HOME/prepare_receptor4.py -A 'None' -U 'nphs_lps' -r AAA.pdb -o AAA.pdbqt # 'nphs_lps' -> remove nonpolar Hs, lone pairs, and merge charges
#
## create the .trg file to prepare for docking
## noncovalent docking
#$ADFR_HOME/agfr -r AAA.pdbqt -o AAA_nc -b user 43.0 31.8 -2.7 30.0 30.0 30.0 -s 0.25 
## covalent docking
#$ADFR_HOME/agfr -r AAA.pdbqt -o AAA_c  -b user 43.0 31.8 -2.7 30.0 30.0 30.0 -s 0.25 -c 1091 1094 -t 1090 -x A:CYS111
#
#mkdir -p $SLURM_SUBMIT_DIR/$OUTPUT_DIR/covalent_docking
cd $SLURM_SUBMIT_DIR/$OUTPUT_DIR/covalent_docking

suffix=$(grep -v '#' $LIGAND_HOME/covalent_docking.txt)
for i in $suffix
do
	echo "docking $i ligands"
	mkdir $i
	cd $i
	for pdbqt in $LIGAND_HOME/$i/*pdbqt
	do
		ligname="${pdbqt##*/}"
		ligname="${ligname%%.*}"
		if [ -f "$ligname"_cov_out.pdbqt ]; then
			echo reading ligand $pdbqt
		else
			# dock a single ligand to the protein
  			$ADFR_HOME/adfr -O -t ../../AAA_c.trg -l $pdbqt --jobName cov -C 1 2 3 --seed 1234567 --maxCores 32 --nbRuns 50 --clusteringRMSDCutoff 0.5 --noImproveStop 15 --maxEvals 100000000 # -p 1000
		fi
	done
	cd ../
done

mkdir -p $SLURM_SUBMIT_DIR/$OUTPUT_DIR/noncovalent_docking
cd $SLURM_SUBMIT_DIR/$OUTPUT_DIR/noncovalent_docking

suffix=$(grep -v '#' $LIGAND_HOME/noncovalent_docking.txt)
for i in $suffix
do
	echo "docking $i ligands"
	mkdir $i
	cd $i
	for pdbqt in $LIGAND_HOME/$i/*pdbqt
	do
		ligname="${pdbqt##*/}"
		ligname="${ligname%%.*}"
		if [ -f "$ligname"_noncov_out.pdbqt ]; then
			echo reading ligand $pdbqt
		else
			# dock a single ligand to the protein
  			$ADFR_HOME/adfr -O -t ../../AAA_nc.trg -l $pdbqt --jobName noncov --seed 1234567 --maxCores 32 --nbRuns 50 --clusteringRMSDCutoff 0.5 --noImproveStop 15 --maxEvals 100000000
		fi
	done
	cd ../
done

