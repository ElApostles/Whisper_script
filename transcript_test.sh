#!/bin/bash
set -eux

parse_option() {
    local prompt;
    if [ "$1" = "-p" ]; then
        shift;
        prompt_file="$1"
        if [ -f "$prompt_file" ]; then
            prompt=$(cat "$prompt_file");
            export prompt;
        fi
    fi
}

init_env() {
    if [ ! -e .env ]; then
        printf 'Error: File not found - .env' >&2;
        exit 1;
    fi
    set -a;
    source .env;
    set +a;

    input_file="$1"
    # Check if the input file exists
    if [ ! -f "$input_file" ]; then
        echo "Error: File not found - $input_file" >&2;
        exit 1;
    fi

    # Get the file's base name (remove path)
    base_name=$(basename "$input_file")

    # Remove the file's extension
    base_name="${base_name%.*}"

    # Create the output directory
    output_dir="output/$base_name"
    mkdir -p "$output_dir"
}

split_file() {
    # Check if the correct number of arguments is provided
    if [ "$#" -ne 1 ]; then
        echo "Usage: $0 input_file"
        exit 1
    fi

    input_file="$1"
    output_prefix="split"
    duration="00:20:00" # 20 minutes

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
}

transcript() {
    local input_file="$1"
    local output_file="$2"

    curl https://api.openai.com/v1/audio/transcriptions \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -H "Content-Type: multipart/form-data" \
        -F file="@/$PWD/$input_file" \
        -F model="whisper-1" \
        -F language="ko" > "$output_file"
}

_main() {
    mkdir -p output
    init_env "$@"

    local files_to_process
    files_to_process=$(split_file "$input_file" "$output_dir")

    for file in $files_to_process; do
        local base_name;
        base_name=$(basename "$file");
        local output_file="$output_dir/$base_name.txt";
        echo transcript! "$file" "$output_file"
        # transcript "$file" "$output_file";
    done
}

_main "$@"
