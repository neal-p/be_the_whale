#!/bin/bash

CONFIG_FILE="docker_interactive_args.txt"
SHARED_DIRS_FILE="shared_directories.txt"


# Default values
cmd=""
declare -a v_values=()

# Usage function
usage() {
    echo "Usage: $0 --image|-i <image> [--cmd|-c <cmd>] [-v <value>... ]"
    echo "  --image, -i    Required: Image name (no spaces)"
    echo "  --cmd, -c      Optional: Command (no spaces, can only appear once)"
    echo "  -v             Optional: Repeated values (can be specified multiple times)"
    exit 1
}

# Parse options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --image|-i)
            if [[ -n "$2" && "$2" != -* ]]; then
                image="$2"
                shift 2
            else
                echo "Error: --image requires a non-empty argument."
                usage
            fi
            ;;
        --cmd|-c)
            if [[ -n "$2" && "$2" != -* && -z "$cmd" ]]; then
                cmd="$2"
                shift 2
            elif [[ -n "$2" && "$2" != -* && -n "$cmd" ]]; then
                echo "Error: --cmd can only be provided once."
                usage
            else
                echo "Error: --cmd requires a valid argument."
                usage
            fi
            ;;
        -v)
            if [[ -n "$2" && "$2" != -* ]]; then
                v_values+=("$2")
                shift 2
            else
                echo "Error: -v requires a valid value."
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
if [[ -z "$image" ]]; then
    echo "Error: --image is a required parameter."
    usage
fi

# Get full string of Vs
v_string=""
for value in "${v_values[@]}"; do
  v_string+="-v ${value} "
done


# Initialize an empty string for docker arguments
# And pre-configured shared dirs
DOCKER_ARGS=""

while IFS= read -r line
do
  # Skip empty lines and comments (lines starting with #)
  [[ -z "$line" || "$line" =~ ^#.*$ ]] && continue

  DOCKER_ARGS="$DOCKER_ARGS $line"
done < "$CONFIG_FILE"

while IFS= read -r line

do
  # Skip empty lines and comments (lines starting with #)
  [[ -z "$line" || "$line" =~ ^#.*$ ]] && continue

  DOCKER_ARGS="$DOCKER_ARGS -v $line"

done < "$SHARED_DIRS_FILE"


# Execute docker run with the arguments from the config file and any additional user arguments
echo "docker run ${DOCKER_ARGS} ${v_string} $image $cmd"
docker run ${DOCKER_ARGS} ${v_string} $image $cmd
