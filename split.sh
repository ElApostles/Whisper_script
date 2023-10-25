#!/bin/bash
set -eux;

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input_file"
    exit 1
fi

input_file="$1"
output_prefix="split"
duration="00:30:00" # 30 minutes

# Extract the file format from the input file
file_format=$(ffmpeg -i "$input_file" 2>&1 | sed -n -e 's/^.*Input #0, \([^,]*\),.*$/\1/p')

# Get the total duration of the input file in seconds
total_duration=$(ffmpeg -i "$input_file" 2>&1 | grep Duration | awk '{print $2}' | tr -d , | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')

# Initialize variables
start_time=0
counter=1

# Split the file into 30-minute segments
while (( $(echo "$start_time < $total_duration" | bc -l) )); do
    output_file="${output_prefix}_${counter}.${file_format}"
    ffmpeg -i "$input_file" -ss "$(printf "%02d:%02d:%02d" $((start_time/3600)) $(((start_time/60)%60)) $((start_time%60)))" -t "$duration" -c copy "$output_file"
    start_time=$(echo "$start_time + 1800" | bc)
    ((counter++))
    echo "$output_file"
done
