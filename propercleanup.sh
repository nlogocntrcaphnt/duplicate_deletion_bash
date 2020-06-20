#!/bin/bash

tolerance=5

counter1=1
counter2=1

for sub_folder_selected in $1*/
do

	for file_selected in "$sub_folder_selected"*.jpg
	do

		for sub_folder_comparison in $1*/
		do

    		for file_comparison in "$sub_folder_comparison"*.jpg
    		do

				echo "comparing $file_selected $file_comparison"
				if [[ $counter2 < $counter1 ]]; then
        			selected_ratio="$(identify -format "%[fx:w/h]" "$file_selected")"
        			comparison_ratio="$(identify -format "%[fx:w/h]" "$file_comparison")"

					ratio_difference=$(echo "$selected_ratio - $comparison_ratio" | bc)

        			echo "$selected_ratio $comparison_ratio"

        			if [[ $file_selected != $file_comparison ]] && [[ $(echo "$ratio_difference < 0.01" | bc) -eq 1 ]] && [[ $(echo "$ratio_difference > -0.01" | bc) -eq 1 ]]; then
						echo "comparing $file_selected $file_comparison" 
#            			resolution="$(identify -format "%wx%h" $file_selected)"
#            			convert "$file_comparison" -resize $resolution /tmp/conversion.png

            			compare -quiet -metric PHASH "$file_selected" "$file_comparison" /tmp/difference.png 2> /tmp/difference.txt
           				difference=$(cat /tmp/difference.txt)
						echo $difference

            			if [[ $(echo "$difference < $tolerance" | bc) -eq 1 ]]; then
                			rm "$file_comparison"
							echo "removed file"
            			fi
       				fi
					counter2=$(($counter2+1))
				else
					break
				fi
    		done
			if [[ $counter2 > $counter1 ]]; then
				break
			fi
				
		done
		counter1=$(($counter1+1))
		counter2=0
		
	done

done
