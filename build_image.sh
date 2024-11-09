#!/bin/bash

################################################################
# Parse input
##############

# Default values
file="Dockerfile_dev"

# Usage function
usage() {
    echo "Usage: $0 --name|-n <name> [--file|-f <file>]"
    echo "  --name, -n      Required: Name parameter (no spaces)"
    echo "  --file, -f      Optional: File name starting with 'Dockerfile' (default: Dockerfile_dev)"
    exit 1
}

# Function to validate file option
validate_file_option() {
    local file_option=$1
    if [[ ! -f "$file_option" ]]; then
        echo "Error: Specified file '$file_option' does not exist in the current directory."
        exit 1
    fi
}

# Parse options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --name|-n)
            if [[ -n "$2" && "$2" != -* ]]; then
                name="$2"
                shift 2
            else
                echo "Error: --name requires a non-empty argument."
                usage
            fi
            ;;
        --file|-f)
            if [[ -n "$2" && "$2" != -* ]]; then
                file="$2"
                shift 2
            else
                echo "Error: --file requires a valid argument."
                usage
            fi
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Check if required options are set
if [[ -z "$name" ]]; then
    echo "Error: --name is a required parameter."
    usage
fi

# Validate the file option
if [[ "$file" != "Dockerfile_dev" && "$file" != Dockerfile* ]]; then
    echo "Error: --file must start with 'Dockerfile'."
    usage
fi
validate_file_option "$file"

# Output the options for confirmation
echo "Name: $name"
echo "File: $file"


################################################################
# Actual Build
##############

docker build . --file $file -t $name
docker save --output=$name.tar $name

echo "Done"
