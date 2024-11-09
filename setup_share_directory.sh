#!/bin/bash

host_path=$1
container_path=$2

mkdir -p $host_path
chmod -R 777 $host_path

full_host_path="$(readlink -e $host_path)"

echo "${full_host_path}:${container_path}" >> shared_directories.txt
