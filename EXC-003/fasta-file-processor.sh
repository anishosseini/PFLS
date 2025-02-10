sequences=$(grep -v "^>" "$1")

echo "$sequences" | awk '
{
  total_length = 0
  num_sequences = 0
  longest_length = 0
  shortest_length = 999999 
  gc_total = 0
  base_total = 0
}


{

  seq_length = length($0)
  total_length += seq_length; num_sequences++

  
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
  # Calculate average sequence length, it is easier by awk 
  avg_length = total_length / num_sequences

  # Calculate GC content percentage
  gc_content = ((100* gc_total / base_total))

}'
  echo "FASTA File Statistics:"
  echo "----------------------"
  echo "Number of sequences: $num_sequences"
  echo "Total length of sequences: $total_length"
  echo "Length of the longest sequence: $longest_length"
  echo "Length of the shortest sequence: $shortest_length"
  echo "Average sequence length: $avg_length"
  echo "GC Content (%): $gc_content %"