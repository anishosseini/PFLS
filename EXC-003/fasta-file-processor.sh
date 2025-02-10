


sequences=$(grep -v "^>" "$1")

awk_output=$(echo "$sequences" | awk '
BEGIN {
  total_length = 0
  num_sequences = 0
  longest_length = 0
  shortest_length = 999999 
  gc_total = 0
  base_total = 0
}

{
  seq_length = length($0)
  total_length += seq_length
  num_sequences++

  # Check for longest and shortest sequence
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
  avg_length = total_length / num_sequences

gc_content = ((100* gc_total / base_total))

  print num_sequences
  print total_length
  print longest_length
  print shortest_length
  print avg_length
  print gc_content

  
}')

variables using head and tail
num_sequences=$(echo "$awk_output" | head -n 1)
total_length=$(echo "$awk_output" | head -n 2 | tail -n 1)
longest_length=$(echo "$awk_output" | head -n 3 | tail -n 1)
shortest_length=$(echo "$awk_output" | head -n 4 | tail -n 1)
avg_length=$(echo "$awk_output" | head -n 5 | tail -n 1)
gc_content=$(echo "$awk_output" | tail -n 1)


# Print results
echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_sequences"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_length"
echo "Length of the shortest sequence: $shortest_length"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_content %"