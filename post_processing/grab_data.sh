

dir_array=(*/)
for dir in "${dir_array[@]}"
do
	if [ "$dir" == "__pycache__/" ]; then
		continue
	fi
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
		temp=${mol%?}
		echo "sed -e 's.AAA.$temp.g' -e 's.BBB.${temp##*/}.g' -e 's.CCC.$mol*/*pdb.g' < docking_poses.config > temp.config"
		sed -e "s.AAA.$temp.g" -e "s.BBB.${temp##*/}.g" -e "s.CCC.$mol*/*pdb.g" < docking_poses.config > temp.config
		echo "time python3 docking_poses.py temp.config IO.py"
		time python3 docking_poses.py temp.config IO.py
	done
	echo "time python3 violin_plot.py '${dir%?}/*dat' ${dir%?}/jmp" 
	time python3 violin_plot.py "${dir%?}/*dat" ${dir%?}/jmp
done

