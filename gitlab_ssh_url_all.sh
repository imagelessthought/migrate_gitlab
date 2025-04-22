#!/bin/bash

# Give SSH URL fro all repos
# Make sure ACCESS_TOKEN and GITLAB_URL are set in your environment:
# export ACCESS_TOKEN="your_actual_access_token_here"
# export GITLAB_URL="https://gitlab.cas.unt.edu"

OUTPUT_FILE="gitlab-repos.txt"
PER_PAGE=100
PAGE=1

if [[ -z "$ACCESS_TOKEN" || -z "$GITLAB_URL" ]]; then
  echo "ERROR: ACCESS_TOKEN and GITLAB_URL environment variables must be set."
  exit 1
fi

# Clear the output file at the start
> "$OUTPUT_FILE"

while :; do
  echo "Fetching page $PAGE..."

  RESPONSE=$(curl -s --header "PRIVATE-TOKEN: $ACCESS_TOKEN" \
    --header "Accept: application/json" \
    -D headers.txt \
    "$GITLAB_URL/api/v4/projects?simple=true&per_page=$PER_PAGE&page=$PAGE")

  # Write the SSH URLs to the output file
  echo "$RESPONSE" | jq -r '.[].ssh_url_to_repo' >> "$OUTPUT_FILE"

  # Check for next page from headers
  NEXT_PAGE=$(grep -Fi "X-Next-Page:" headers.txt | awk '{print $2}' | tr -d '\r')

  if [[ -z "$NEXT_PAGE" || "$NEXT_PAGE" == "0" ]]; then
    echo "All pages fetched."
    break  # No more pages
  fi

  PAGE=$NEXT_PAGE
done

echo "Repo list saved to $OUTPUT_FILE"
