

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

  
  print total_length
  print longest_length
  print shortest_length
  print avg_length
  print gc_content

  
}')


# Print results
echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_sequences"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_length"
echo "Length of the shortest sequence: $shortest_length"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_content %"
