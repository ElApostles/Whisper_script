#!/bin/sh
set -uex

init_env() {
	set -a
	source .env
	set +a

  # Get the file path from command line arguments
  input_file="$@"

  # Check if the input file exists
  if [ ! -f "$input_file" ]; then
    echo "Error: File not found - $input_file"
    exit 1
  fi

  # Get the file's base name (remove path)
  base_name=$(basename "$input_file")

  # Remove the file's extension
  base_name="${base_name%.*}"

  # Create the output file name
  output_file="output/$base_name.txt"

  # # TODO: if -p arg exist, replace with this.
  # prompt="$(cat prompt/prompt.txt)"
}

transcript() {
curl https://api.openai.com/v1/audio/transcriptions \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: multipart/form-data" \
  -F file="@/$PWD/$1" \
  -F model="whisper-1" \
  -F language="ko" > "$2"
}

_main() {
  mkdir -p output
	init_env "$@"
	transcript "$input_file" "$output_file"
}

_main "$@"
