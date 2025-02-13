

num_sequences=$(grep -c "^>" "$1")


sequences=$(awk '
  /^>/ { 
    if (seq != "") print seq; 
    seq = "" 
    next 
  } 
  { seq = seq $0 } 
  END { print seq }' "$1")


awk_output=$(echo "$sequences" | awk '
{
  seq_length = length($0)
  total_length += seq_length
  

  
  if (seq_length > longest_length) {
    longest_length = seq_length
  }
  if (seq_length < shortest_length) {
    shortest_length = seq_length
  }

  # Calculate GC content
  gc_count = gsub(/[GgCc]/, "", $0)
  gc_total += gc_count
  base_total += seq_length
}

END {
avg_length = $((total_length / num_sequences))

gc_content = ((100* gc_total / base_total))

    print "FASTA File Statistics:";
    print "----------------------";
    print "Number of sequences: " seq_count;
    print "Total length of sequences: " total_length;
    print "Length of the longest sequence: " max_length;
    print "Length of the shortest sequence: " min_length;
    print "Average sequence length: " avg_length;
    print "GC Content (%): " gc_percent;
  
}')

<<<<<<< HEAD
=======
#variables using head and tail

#total_length=$(echo "$awk_output" | head -n 2 | tail -n 1)
#longest_length=$(echo "$awk_output" | head -n 3 | tail -n 1)
#shortest_length=$(echo "$awk_output" | head -n 4 | tail -n 1)
#avg_length=$(echo "$awk_output" | head -n 5 | tail -n 1)
#gc_content=$(echo "$awk_output" | tail -n 1)

>>>>>>> b7d7ba1 (Saving local changes before pull)

# Print results
echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_sequences"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_length"
echo "Length of the shortest sequence: $shortest_length"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_content %"
