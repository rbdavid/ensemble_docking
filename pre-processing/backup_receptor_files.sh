
export SLURM_SUBMIT_DIR="/lustre/or-hydra/cades-bsd/davidsonrb"
export PROJECT_STORAGE_DIR="/nfs/data/cades-bsd/davidsonrb"

cd $SLURM_SUBMIT_DIR/new_box/
array=(*/)	# create an array with all available directories 
for dir in "${array[@]}"
do
	cd $SLURM_SUBMIT_DIR/new_box/$dir/
	mkdir -p $PROJECT_STORAGE_DIR/new_box/receptor_files/$dir
	cp *pdb $PROJECT_STORAGE_DIR/new_box/receptor_files/$dir
	cp *pdbqt $PROJECT_STORAGE_DIR/new_box/receptor_files/$dir
	cp *log $PROJECT_STORAGE_DIR/new_box/receptor_files/$dir
	cp *trg $PROJECT_STORAGE_DIR/new_box/receptor_files/$dir
done

