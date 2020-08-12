
dir_array=(*/)
for dir in "${dir_array[@]}"
do
	echo $dir
	mol_array=($dir*/)
	for mol in "${mol_array[@]}"
	do
		echo $mol
		echo "# $mol" > ${mol%?}.dat
		pdbqt_array=($mol*/*pdbqt)
		for pdbqt in "${pdbqt_array[@]}"
		do
			echo $pdbqt
			echo "# $pdbqt" >> ${mol%?}.dat
			grep "USER: SCORE" $pdbqt >> ${mol%?}.dat
			time python3 prep_pdb.py $pdbqt ${pdbqt%%.*}.pdb
		done
		#time python3 ...
	done
	echo "time python3 violin_plot.py '${dir%?}/*dat' ${dir%?}/jmp" 
	time python3 violin_plot.py '${dir%?}/*dat' ${dir%?}/jmp
done

