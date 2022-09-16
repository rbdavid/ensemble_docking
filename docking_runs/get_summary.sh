
FILES=(*out)
for file in "${FILES[@]}"
do 
	echo $file $(grep "reading ligand" "$file" | wc -l)
done 


#cd /lustre/or-hydra/cades-bsd/davidsonrb/covalent_docking/
#
#dirs_array=(*/)
#echo $dir_array
#for dir in "${dir_array[@]}"
#do 
#	echo $dir 
#	ls -l $dir*/*pdbqt | wc -l
#done

