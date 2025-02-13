	
awk ' BEGIN {salary=$4 max_salar=0 FS=","} NR > 1
	{if (salary > max_salary) max_salary=salary ;END {print salary}'







		awk 'BEGIN {FS=","} NR > 1 {if $4 > 60000} END{print $2}'
		awk 'BEGIN{FS=","} NR > 1 {if ($4 > 60000) print $2}' employees.txt

		awk 'BEGIN {FS=","} NR > 1 {print $2 " "$4}' | 
		awk 'BEGIN {FS=","} NR > 1 {$5= $4*0.1} END {print $0}' employees.txt

#using arrays"

		awk 'BEGIN {FS=","} NR > 1 {departments[$3] += 1} END {for (department in departments) print department, departments[department]}' employees.txt