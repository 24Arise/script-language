#!/bin/bash

# shellcheck disable=SC2188
<<'EOF'
Description：Cut a large file into multiple smaller files by the maximum number of lines.
Parameter：input_filename : Large files to be cut
Parameter：max_lines : Maximum number of lines to be cut out of each file
Author: @24Arise
Date: 2023.12.06 13:46:00
Example：sh 06\ spilt-file.sh /Users/Arise/Developer/YINL.sql 20000
EOF

# Function to check if a value is numeric
is_numeric() {
    re='^[0-9]+$'
    if ! [[ $1 =~ $re ]]; then
        return 1
    else
        return 0
    fi
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <input_filename> <max_lines>"
    exit 1
fi

# Get the input filename and max_lines from command-line arguments
input_file="$1"
max_lines="$2"

# Check if the input file exists
if [ ! -f "$input_file" ]; then
    echo "File '$input_file' does not exist!"
    exit 1
fi

# Validate if max_lines is a numeric value
if ! is_numeric "$max_lines"; then
    echo "Please provide a valid numeric value for max_lines."
    exit 1
fi

# Define the initial line number
start_line=1

# Loop until the entire file is processed
file_counter=1
while [[ $start_line -le $(wc -l <"$input_file") ]]; do
    # Calculate the ending line number
    end_line=$((start_line + max_lines - 1))

    # Generate the output filename
    output_file="${input_file%.*}-$file_counter.${input_file##*.}"

    # Use sed to write the specified range of lines into the output file
    sed -n "${start_line},${end_line}p" "$input_file" >"$output_file"

    # Update the start line number and file counter
    start_line=$((end_line + 1))
    ((file_counter++))
done
