#!/bin/bash

# Path to pubspec.yaml and CHANGELOG.md
PUBSPEC_FILE="pubspec.yaml"
CHANGELOG_FILE="CHANGELOG.md"

# Extract the current version from pubspec.yaml
current_version=$(grep '^version:' "$PUBSPEC_FILE" | awk '{print $2}')

if [ -z "$current_version" ]; then
  echo "Version not found in $PUBSPEC_FILE"
  exit 1
fi

# Normalize version format (e.g., strip any leading v and part after +)
normalized_version=$(echo "$current_version" | sed 's/^v//; s/\+.*//')

# Check if there's a corresponding changelog entry
if grep -q "## $normalized_version" "$CHANGELOG_FILE"; then
  echo "Changelog entry found for version $current_version."
else
  echo "No changelog entry found for version $current_version in $CHANGELOG_FILE."
  exit 1
fi
