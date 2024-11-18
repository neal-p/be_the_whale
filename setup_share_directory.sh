#!/bin/bash

host_path=$1
container_path=$2


# Usage function
usage() {
    echo "Usage: $0 --host_path|-h <host_path> --container_path|-c <container_path>"
    echo "  --host_path, -h        Required: Path on the host"
    echo "  --container_path, -c    Required: Path inside the container"
    exit 1
}

# Parse options
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --host_path|-h)
            if [[ -n "$2" && "$2" != -* ]]; then
                host_path="$2"
                shift 2
            else
                echo "Error: --host_path requires a non-empty argument."
                usage
            fi
            ;;
        --container_path|-c)
            if [[ -n "$2" && "$2" != -* ]]; then
                container_path="$2"
                shift 2
            else
                echo "Error: --container_path requires a non-empty argument."
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
if [[ -z "$host_path" ]]; then
    echo "Error: --host_path is a required parameter."
    usage
fi

if [[ -z "$container_path" ]]; then
    echo "Error: --container_path is a required parameter."
    usage
fi

# Output the options for confirmation
echo "Host Path: $host_path"
echo "Container Path: $container_path"

mkdir -p $host_path
chmod -R 777 $host_path

full_host_path="$(readlink -e $host_path)"

echo "Configuring containers to link ${full_host_path} : ${container_path}"
echo "${full_host_path}:${container_path}" >> config/interactive_directories.txt
