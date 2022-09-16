
#FILES=7jir_frame_1_rbd_3wats.pdb
FILES=*wats.pdb
for f in $FILES
do 
	echo $f
	# prep a batch script to submit the docking run for file $f
	#sed -e "s?AAA?${f::-4}?g" docking_run_contd.sh > batch.sh
	sed -e "s?AAA?${f::-4}?g" docking_run.sh > batch.sh
	# submit the docking run
	sbatch batch.sh
done

