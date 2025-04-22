#!/bin/bash

# Check if filename is passed
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <repo-list-file>"
    exit 1
fi

REPO_LIST_FILE="$1"
BACKUP_DIR="gitlab-backup"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Read file line by line and clone each repo
while IFS= read -r repo_url; do
    if [ -n "$repo_url" ]; then
        REPO_NAME=$(basename "$repo_url" .git)
        DEST_DIR="$BACKUP_DIR/$REPO_NAME"

        if [ -d "$DEST_DIR" ]; then
            echo "Skipping $REPO_NAME — already exists in $BACKUP_DIR."
        else
            echo "Cloning $repo_url into $DEST_DIR..."
            git clone "$repo_url" "$DEST_DIR"
        fi
    fi
done < "$REPO_LIST_FILE"
