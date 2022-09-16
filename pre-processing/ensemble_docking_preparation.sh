
#FILES=7jir_frame_1_rbd_3wats.pdb
FILES=7jir_frame_*wats.pdb
for f in $FILES
do 
	echo $f
	# prep a batch script to submit the docking run for file $f
	sed -e "s?AAA?${f::-4}?g" receptor_prep.sh > batch.sh
	# submit the docking run
	sbatch batch.sh
done

