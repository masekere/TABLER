#!/bin/bash

# Function to print an array in a formatted table
print_row() {
    local column_length="$1"
    shift
    local array=("$@")
    local num_columns=${#array[@]}

  # Generate the printf format string dynamically based on the number of columns
  local format_string="|"
  for (( k=0; k<num_columns; k++ )); do
    format_string+=" %-$((column_length))s |"
  done
  format_string+="\n"

  # Print the array using printf
  printf "$format_string" "${array[@]}"
}

# Function to print the border line for the table
print_border() {
    local num_columns="$1"
    local column_length="$(($2 + 2))"
    local border_string="+"
    local border_space=""

    for((i=0;i<column_length;i++)); do
        border_space+="-"
    done
    
    for((i=0;i<num_columns;i++)); do
        border_string+="$border_space+"
    done

    echo "$border_string"
    
}

# Function to calculate the length of the longest line in a file
length_of_longest_line() {
  local file="$1"
  awk '{
    if (length($0) > max_length) {
      max_length = length($0)
    }
  } END {
    max_length+=2
    print max_length
  }' "$file"
}

# Read the input file or text input
input_file="$1"
if [ -z "$input_file" ]; then
  echo "Usage: $0 <input_file>"
  exit 1
fi

# Initialize variables
declare -a columns
row_count=0

# Start processing the input file
while IFS= read -r line; do
  columns+=("$line")
  ((row_count++))
done < "$input_file"

# Calculate the number of rows and columns
column_length=$(length_of_longest_line "$input_file")
num_columns=$(( (row_count + 14) / 15 )) # Round up to the nearest integer for columns
max_rows=15

# Print table top border
print_border "$num_columns" "$column_length"

# Print the table content
for ((i = 0; i < max_rows; i++)); do
  row=()
  for ((j = 0; j < num_columns; j++)); do
    index=$((i + j * max_rows))
    if [ $index -lt "$row_count" ]; then
      row+=("${columns[$index]}")
    else
      row+=("")
    fi
  done
  
  print_row "$column_length"  "${row[@]}"
done

# Print table bottom border
print_border "$num_columns" "$column_length"

