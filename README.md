# Whisper_Script: A Simple Wrapper for OpenAI's Whisper API

Whisper_Script provides a streamlined and user-friendly interface to interact with OpenAI's Whisper API, facilitating the transcription of audio files with minimal setup.

## Getting Started

### Prerequisites

Ensure that you have the following prerequisites installed and configured on your system:

Bash
[OpenAI API Key](https://platform.openai.com/docs/api-reference/authentication)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/yourusername/whisper_script.git
```

2. Navigate to the project directory:

```
cd whisper_script
```

3. Make .env
Create a .env file in the root directory of your project. You can do this using a text editor, or by running the following command in your terminal:
```bash
touch .env
```

2. Adding the OPENAI_API_KEY
Open the .env file using a text editor of your choice, and add the following line:
```bash
OPENAI_API_KEY=your_openai_api_key_here
```
Replace your_openai_api_key_here with your actual OpenAI API key.

### Usage

To transcribe an audio file, follow the steps below:

1. Place your audio file in the desired directory.

2. Open your terminal and run the following command:

```bash
bash transcript.sh <file_name>
```

- Replace <infile_name> with the name of your audio file.

3. Upon successful execution, the transcribed text will be saved in the output directory, with the filename format: {FILENAME}.txt.

## Support

For any issues or inquiries, please open an issue in the [GitHub repository](https://github.com/ElApostles/whisper_script/issues).

## Contributing

Contributions are welcome! Please refer to the contribution guidelines for more information.

This refined version includes sections for prerequisites, installation, and support, providing users with a comprehensive guide to get started with your wrapper script. Additionally, the language has been polished for a more professional tone, and Markdown formatting has been utilized to enhance readability.
