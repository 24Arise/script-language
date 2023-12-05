#!/bin/bash

# shellcheck disable=SC2188
<<'EOF'
Description：Copying files from a git commit record (keeping the file subdirectory)
Parameter：destination_dir : Destination directory to which the file needs to be copied
Parameter：commit_hash1 : git commit hash (eg：8829535726472968759c64cedd93af24e0a33947、88295357）
Author: @24Arise
Date: 2023.12.05 17:48:00
Example：sh 05\ copy-files-from-commits.sh /Users/Arise/Developer/TEST01 fc08e3cce8
EOF

# Check if the target directory is provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <destination_dir> <commit_hash1> [<commit_hash2> ...]"
    exit 1
fi

# Get target directory
destination_dir="$1"
shift

# Iterate through each commit hash
while [ $# -gt 0 ]; do
    commit_hash="$1"
    echo "Files for commit: $commit_hash"

    # Get a list of files changed in a particular commit
    # shellcheck disable=SC2207
    files=($(git show --name-only --format=format: "$commit_hash"))

    # Number of Printed Documents
    num_files=${#files[@]}
    echo "Number of files: $num_files"

    for file in "${files[@]}"; do
        # Execute the copy command
        rsync -av --relative "$file" "$destination_dir"
        echo "Copied $file to $destination_dir"
    done
    echo "-----------------------"
    shift
done
