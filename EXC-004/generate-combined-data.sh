#!/bin/bash

# Define directories
RAW_DATA="RAW-DATA"
COMBINED_DATA="COMBINED-DATA"
SAMPLE_TRANSLATION="$RAW_DATA/sample-translation.txt"

# Ensure the COMBINED-DATA directory exists
mkdir -p "$COMBINED_DATA"

# Read sample-translation.txt without associative arrays
while IFS=$'\t' read -r lib_name culture_name; do
    echo "$lib_name $culture_name" >> sample_map.txt
done < "$SAMPLE_TRANSLATION"

# Loop through each directory in RAW-DATA
for dir in "$RAW_DATA"/DNA*; do
    if [[ -d "$dir" ]]; then
        LIB_NAME=$(basename "$dir")
        CULTURE_NAME=$(grep "^$LIB_NAME " sample_map.txt | awk '{print $2}')
        
        # Process bins
        BIN_DIR="$dir/bins"
        MAG_COUNT=1
        BIN_COUNT=1
        
        if [[ -d "$BIN_DIR" ]]; then
            for file in "$BIN_DIR"/*.fasta; do
                BASENAME=$(basename "$file")
                TEMP_FILE="temp_reformatted.fasta"
                
                # Modify FASTA headers manually (preserve sequence numbers if present)
                awk -v prefix="$CULTURE_NAME" -v count=1 '
                    /^>/ {
                        match($0, />bin-[^ ]+/); 
                        bin_id = substr($0, RSTART, RLENGTH); 
                        gsub(/>/, "", bin_id);
                        print ">" prefix "_" bin_id "_seq" count;
                        count++;
                    } 
                    !/^>/ { print }' "$file" > "$TEMP_FILE"
                
                if [[ "$BASENAME" == "bin-unbinned.fasta" ]]; then
                    mv "$TEMP_FILE" "$COMBINED_DATA/${CULTURE_NAME}_UNBINNED.fa"
                else
                    # Get bin ID
                    BIN_ID=${BASENAME%.fasta}
                    
                    # Extract completion and contamination from checkm.txt
                    COMPLETION=$(grep "$BIN_ID" "$dir/checkm.txt" | awk '{print $(NF-1)}')
                    CONTAMINATION=$(grep "$BIN_ID" "$dir/checkm.txt" | awk '{print $NF}')
                    
                    if (( $(echo "$COMPLETION >= 50 && $CONTAMINATION < 5" | bc -l) )); then
                        FILE_TYPE="MAG"
                        FILE_INDEX=$(printf "%03d" $MAG_COUNT)
                        ((MAG_COUNT++))
                    else
                        FILE_TYPE="BIN"
                        FILE_INDEX=$(printf "%03d" $BIN_COUNT)
                        ((BIN_COUNT++))
                    fi
                    
                    NEW_NAME="${CULTURE_NAME}_${FILE_TYPE}_${FILE_INDEX}.fa"
                    mv "$TEMP_FILE" "$COMBINED_DATA/$NEW_NAME"
                fi
            done
        fi
        
        # Copy checkm.txt and gtdb.gtdbtk.tax
        cp "$dir/checkm.txt" "$COMBINED_DATA/${CULTURE_NAME}-CHECKM.txt"
        cp "$dir/gtdb.gtdbtk.tax" "$COMBINED_DATA/${CULTURE_NAME}-GTDB-TAX.txt"
    fi
done

# Cleanup temporary mapping file
rm sample_map.txt
